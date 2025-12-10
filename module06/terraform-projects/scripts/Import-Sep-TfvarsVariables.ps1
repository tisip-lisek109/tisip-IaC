param(
    [Parameter(Mandatory = $true)]
    [string]$KeyVaultName,

    [Parameter(Mandatory = $true)]
    [string]$TfvarsFilePath,

    [string]$Prefix = ''
)

# Read file line by line
$lines = Get-Content -LiteralPath $TfvarsFilePath

# Counter for successful imports
$successCount = 0

foreach ($line in $lines) {

    # Skip empty lines and comments
    if ([string]::IsNullOrWhiteSpace($line) -or $line.Trim().StartsWith('#')) {
        continue
    }

    # Parse line (format: variable_name = "value")
    if ($line -match '^\s*([a-zA-Z0-9_-]+)\s*=\s*(.+)$') {
        $variableName = $matches[1].Trim()
        $variableValue = $matches[2].Trim()

        # Remove quotes if present
        $variableValue = $variableValue -replace '^"(.*)"$', '$1'
        $variableValue = $variableValue -replace "^'(.*)'$", '$1'

        # Build secret name (with prefix if provided)
        if ($Prefix) {
            $secretName = "$Prefix-$variableName"
        }
        else {
            $secretName = $variableName
        }

        # Save to Key Vault
        try {
            az keyvault secret set --vault-name $KeyVaultName --name $secretName --value $variableValue --output none | Out-Null
            Write-Host ('OK saved secret {0} = {1}' -f $secretName, $variableValue)
            $successCount++
        }
        catch {
            Write-Host ('ERROR saving secret {0}: {1}' -f $secretName, $_) -ForegroundColor Red
        }
    }
}

Write-Host ''
Write-Host ('{0} secrets were saved in Key Vault {1}' -f $successCount, $KeyVaultName)
