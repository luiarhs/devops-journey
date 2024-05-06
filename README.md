# DevOps Journey

### Install Dependencies

- Azure Subscription: https://azure.microsoft.com/en-us/free/
- .NET SDK: https://dotnet.microsoft.com/download
- Terraform: https://learn.hashicorp.com/tutorials/terraform/install-cli
- Helm: https://helm.sh/docs/intro/install/
- Azure Cli: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli
- Docker Desktop: https://www.docker.com/products/docker-desktop

### Tools
Visual Studio Code
GitHub Actions
Azure DevOps Pipelines

Terraform and Helm that we will be using to deploy.

### Create the resources in Azure use the following commands:

```sh
# Login To Azure
az login

# Create Resource Group
az group create --location region --name name-rg

# Set Subscription
az account set --subscription "subscription-id"

# Set Default Resource Group
az configure --defaults group=name-rg

# Create Storage Account
az storage account create --name name --location region --sku Standard_LRS

# Create Storage Container
az storage container create --name tfsname --account-name name

# Initialize Terraform
terraform init

# Terraform Plan
terraform plan

# Terraform Apply
terraform apply
```

### Project Structure
```
api/
|
web/
|
terraform/
│
├── modules/
│   ├── aks/
│   └── database/
├── environments/
│   ├── dev/
│   └── prod/
└── main.tf
│
├── README.md
│
└── .gitignore
```