# Infrastruktur som kode – modul06

## 📋 Forhåndskrav
- Terraform `>= 1.6`
- Azure CLI installert og innlogget (`az login`)
- Tilgang til en ressursgruppe og storage account for tfstate
- SSH‑nøkkel generert lokalt (`~/.ssh/id_rsa.pub`)

### Bootstrap av tfstate‑backend
Terraform state lagres i et Azure Storage‑konto. Før første init var det opprettet:
- Ressursgruppe: `rg-tfstate-tomlis`
- Storage account: `sttf99oib8`
- Container: `tfstate`

Eksempel:
```bash
az group create -n rg-tfstate-tomlis -l westeurope
az storage account create -n sttf99oib8 -g rg-tfstate-tomlis -l westeurope --sku Standard_LRS
az storage container create -n tfstate --account-name sttf99oib8

Backend konfigureres via backend.hcl i hvert miljø (dev, test):
resource_group_name  = "rg-tfstate-tomlis"
storage_account_name = "sttf99oib8"
container_name       = "tfstate"
key                  = "platform-dev.tfstate"   # eller platform-test.tfstate
use_azuread_auth     = true
use_cli              = true


🚀 Hvordan kjøre miljøene:

cd composition/dev
terraform init -backend-config="backend.hcl"
terraform plan -var-file dev.tfvars
terraform apply -var-file=dev.tfvars
terraform output

cd composition/test
terraform init -backend-config="backend.hcl"
terraform plan -var-file test.tfvars
terraform apply -var-file=test.tfvars
terraform output

🔧 Moduler og komposisjon («wiring»)
Network‑modul
Oppretter:

Virtual Network (VNet)
Subnet
Network Security Group (NSG) med regler:
Tillat TCP 80 (HTTP) fra alle
Tillat TCP 22 (SSH) fra egen IP (ssh_source_ip)
Assosiasjon mellom Subnet og NSG

Inputs:
name_prefix, location, environment
vnet_address_space, subnet_prefixes
ssh_source_ip, tags

Outputs:
vnet_id
subnet_id

Compute‑modul
Oppretter:
Public IP
Network Interface (NIC)
Linux VM (Ubuntu) med cloud‑init som installerer NGINX

Inputs:
name_prefix, location, environment
subnet_id (fra network‑modul)
vm_size, admin_username, admin_ssh_public_ke
tags

Outputs:
public_ip_address
nginx_url

Komposisjon
composition/dev og composition/test oppretter Resource Group og kaller modulene.
subnet_id fra network kobles direkte til compute.
Outputs fra compute (nginx_url) eksponeres som sluttresultat.

🔹 Navn
Alle ressurser bygges med name_prefix + type. Med name_prefix = "tomlis-demo-dev" får man:
Ressursgruppe: tomlis-demo-dev-rg
Virtual Network: tomlis-demo-dev-vnet
Subnet: tomlis-demo-dev-subnet
Netwo Security Group: tomlis-demo-dev-nsg
Virtual Machine: tomlis-demo-dev-vm
Public IP: tomlis-demo-dev-pip
Network Interface: tomlis-demo-dev-nic

➡️ Dette gir konsistent og lett gjenkjennelig navngivning på tvers av miljøer.

🔹 Tags
Felles tags injiseres i alle ressurser:
environmet = dev (eller test i test‑miljøet)
owner = tomasz
costcenter = training
➡️ Disse taggene sikrer sporbarhet og kostnadsfordeling, og gjør det enkelt å filtrere ressurser i Azure.