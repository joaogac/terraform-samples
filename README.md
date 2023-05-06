# terraform-samples

## CloudFormation vs Terraform

* JSON/YAML / HCL
* Parameters / Variables
* Mapping / Local variables
* Conditions / Logical Operators
* Resources / Resources
* Intrinsic Functions / Functions
* Nested Stacks  / Modules
* Implicit dependency / Automatic dependency


```
terraform init
terraform validate
terraform plan -out file.tfplan
terraform apply
terraform destroy
terraform fmt
terraform console
terraform state mv
```

> https://registry.terraform.io/

Providers are written in Go

- providers.tf
- locals.tf
- variables.tf
- network.tf

## AWS Authentication

* Static credentials
* Environment variables
* (AWS CLI) Shared credentials/configuration file
* Instance profile
* Code build, ECS and EKS Roles 
* EC2 Instance Metadata Service

## AWS Provider

```
provider "aws" {
   version = "~> 2.0"
   alias = "networking"
   region = var.region
   access_key = var.access_key
   secret_key = var.secret_key
}
```

```
export AWS_ACCESS_KEY_ID=YOUR_ACCESS_KEY
export AWS_SECRET_ACCESS_KEY=YOUR_SECRET_ACCESS_KEY
```


* AWS_SHARED_CREDENTIALS_FILE
* AWS_DEFAULT_REGION
* AWS_PROFILE
* AWS_SESSION_TOKEN # session token for MFA


> hashicorp/random provider  
> Unique Strings -> for unique resource's names

## Looping constructors
* count
* for_each
* dynamic blocks (not coverage)

## Terraform expressions
* Interpolation and heredoc
* Arithmetic and logical operators
* Conditional expressions
* For expressions

## Terraform Functions

### Bult-in 

```
min()
max()
templatefile()
lower()
upper()
merge(coll1, coll2)
cidrsubnet()
cidrhost()
lookup( local.common_tags, "company", "Unknown" )
range()
terraform.workspace
```

## Terraform Modules
- Allow common configurations to be reused
It's a configuration that uses inputs, resources and outputs a value

Availables at terraform public's registry

Code reuse

1. Remote or local source
2. Versioning
3. Scoping  
   
Only way for a parent module pass information to a child module is thought input variables  
And back to the parent though output values  


## Terraform Workspaces
Provides a way to create multiple environments from a single configuration. Identicals

* main_config.tf
* common.tfvars

```
dev/file.state
uat/file.state
prod/file.state
```

```
terraform plan -state=".\dev\dev.state" -var-file="common.tfvars" -var-file=".\dev\dev.tfvars" 
```


## Workspace Example
You can leverage the Infrastructure as a Code concepts throughout workspaces, having pieces that are reusable and idempotent

### CI/CD concepts 
Separate state data for each environment
Support for multiple environments 

```
terraform.tfstate.d
terraform.workspace

terraform workspace new dev
terraform workspace select
terraform workspace list
terraform plan
```

```
variables.tf = where we declare our variables
terraform.tfvars = where we declare the values of our variables
```

### Sensitive values
Recommended way: environment variables in our pipeline, or using Terraform Secrets Service

Should mark the variables as sensitive


## Multiple AWS Providers

```
provider "aws" {} #default
provider "aws" { 
   alias = "security"
   region = var.region
   profile = "security"
} 

aws configure --profile infra
aws configure --profile sec
```

## Data Sources
Retrieves information about the Identity used by the provider 

```
data "aws_caller_identity" "infra" {
   provider = aws.infra
}
```

One of the things caller identity returns is the ```account_id```

## Assume role feature

## AWS Remote State

Moving state data for a remote location allows for team collaboration
> Multiple supported backends

* Standard
* Enhanced (Terraform Cloud and Terraform Enterprise)

All otherwise will be considered standards

> Special features
* Locking
* Workspaces

In AWS you can use S3 to store your state data for you, and DynamoDB for locking you state data for you... and supports encryption

Authentication methods:
* Instance profile (EC2)
* Access & secret keys (similar to AWS CLI)
* Credentials file & profile (similar to .aws file)
* Session token

## Migrating Terraform State

```
terraform {
   backend "S3" {
      bucket = "globo-infra-12345"
      key = "terraform-state"
      region = "us-east-1"
   }
}

terraform init -backend-config="profile=infra"
```

## State as Data source

```
data "terraform_remote_state" "networking" {
   backend = "s3"
   config = {
      bucket = var.net_bucket_name
      key = var.net_bucket_key
      region = var.net_bucket_region
   }
}
```

## AWS CI/CD Tools Setup

```
TF_INPUT
WORKSPACE_NAME
```

Using Data Sources and CloudFormation templates

* Accounts (aws_caller_identity)
* Regions & AZs (aws_availability_zones, aws_subnet_ids)
* Images
* VPCs, subnets
* EC2


## CloudFormation Templates
You can use a CloudFormation template in the Terraform configuration  
Use Cases:

* Existing templates & deployments
* Provider updates
* CF stacks & data sources

```
resource "aws_cloudformation_stack" "stack" {
   name = "app-stack"
   template_body = file("app-stack.template")
   parameters = { ... }
   on_failure = "ROLLBACK"
}
```

It creates a Lambda through a CFN template
See "9-cf-template"


##  Next-steps  
> Hashicorp Terraform Associate