# Overview

## Prerequisites

1. You should have received a user ID and password for the lab environment.  You will use those credentials to log into an Azure tenant where you can complete the labs.

# Lab: Hashicorp Terraform Intro

## Prerequisites
1. All lab instructions are to be completed in the Azure Cloud Shell unless otherwise noted

## Log into the Azure portal
1. Visit [https://portal.azure.com](https://portal.azure.com). You will be prompted to reset your password.
1. Once logged in, open the Cloud Shell.

   ![Cloud Shell](/.images/cloud-shell.png)
1. Select "Bash" when prompted for your shell type (if asked).

   ![Cloud Shell Bash](/.images/cloud-shell-welcome.png)
1. If this is the first time you're opening Cloud Shell, you must setup your Cloud Shell storage. This storage has been preprovisioned for you, but needs to be connected to Cloud Shell. If you're not sure the details of the storage account, we encourage you to explore the Azure Portal to discover them!
   - Select "Show advanced settings"
   - Select your storage account region first
   - Use an existing resource group, selecting the resource group where your Cloud Shell storage account is located
   - Use an existing storage account and point it to the storage account that was preprovisioned
   - Use an existing file share and type "cloudshell" into the text box

   ![Cloud Shell Storage](/.images/cloud-shell-storage.png)

## Clone the terraform-intro repository to Cloud Shell
1. Clone the [terraform-intro](https://github.com/InsightDI/terraform-intro) repository into `~/terraform-intro` by executing the following command:
```
git clone https://github.com/InsightDI/terraform-intro.git
```
2. Change into the `terraform-intro` directory:
```
cd terraform-intro
```

## Explore the Terraform CLI
Terraform ships as a binary - a single executable file. This binary is used to do everything from applying a Terraform configuration (more on that later) to interacting with the Terraform state file.
1. View the terraform binary:
```
which terraform
```
2.  Note that in Cloud Shell, the binary is stored in the `/usr/local/bin` directory, which is part of the shell's PATH:
```
env | grep PATH
```
3. View the terraform commands:
```
terraform
```
4. Make note of the `Main commands` section - we will be using a number of these during the lab.
1. Take quick glance over the `All other commands` section as well
1. Determine the version of Terraform running in Cloud Shell:
```
terraform version
```
7.  Note that Terraform is versioned with a [semantic version](https://semver.org/) number.
1. Copy the version number output from the command to your clipboard, e.g. `1.0.2`. You do not need to copy the "v" that prepends the version number as we won't be using it.
1. Because Terraform ships as a single binary, it's easy to install any version you need. Simply visit [releases.hashicorp.com/terraform](https://releases.hashicorp.com/terraform/) to see available versions.

## Set the Terraform version in code
It's best practice to set the version of Terraform you're using to write your infrastructure-as-code in the code itself.
1. Open the Cloud Shell code editor

   ![Cloud Shell Editor](/.images/cloud-shell-editor.png)
1. Expand the `terraform-intro` directory from the FILES tree
1. Open the file named `providers.tf` and find the `terraform {}` block
1. Update the `required_version = "~> YOURVERSIONHERE"`, replacing "YOURVERSIONHERE" with the version you copied to your clipboard in the previous step.
   - Please leave the "~> " in front of your version. This is called the [pessimistic contstraint operator](https://www.terraform.io/docs/language/expressions/version-constraints.html#gt--1) which allows for variation in the patch number of the required version.
1. Your `providers.tf` file should look something like this, though your version may vary:
```
terraform {
  required_version = "~> 1.0.2"
  ...
}
```
6. Hit `CTRL + S` to save the file

## Configure the AzureRM provider
Terraform interacts with one or more APIs (and thus, clouds) via providers. Therefore, you will typically see one or more provider configurations in Terraform code. In this section, we're going to discover the latest provider version for `azurerm`, which is used to interact with the Azure Resource Manager API.
1. Official Terraform providers can be found in the Terraform Registry at [registry.terraform.io](https://registry.terraform.io). Open a web browser an navigate to https://registry.terraform.io now.
1. Click "Browse Providers"

![Terraform Registry](/.images/terraform-registry.png)

3. Select "Azure" from the list of providers
1. From the "Overview" tab, copy and paste the azurerm provider VERSION to your clipboard
1. Note the "Documentation" tab - this is where all of the documentation for the provider is located - as in, if you're developing Terraform against Azure, you will use this documentation extensively :)
1. Go back to your editor in Cloud Shell and open `providers.tf` if it isn't already open
1. Find the `required_providers` block, and within, the `azurerm` block.
1. Edit the `version = "VERSION"` and paste in the version you found from the registry
1. Your `providers.tf` file should look something like this, though your azurerm version may vary:
```
terraform {
  ...
  required_providers {
    azurerm = {
      version = "2.68.0"
    }
  }
  ...
}
```
10. Hit `CTRL + S` to save the file

## Initialize Terraform
Any time you make changes to the `terraform {}` block, you will need to initialize Terraform. The same is true for the first time you go to run a Terraform configuration.
1. Use the Terraform CLI from Cloud Shell to initialize Terraform:
```
terraform init
```
2. Notice how you didn't pass any flags into the command to tell it where to find your Terraform configuration files? That's because Terraform CLI reads through the directory from where it is executed and loads in all of the files ending in "[.tf](https://www.terraform.io/docs/language/files/index.html#file-extension)" automatically. Neat!
3. From the code editor, refresh the FILES window.

![Refresh editor](/.images/cloud-shell-refresh-editor.png)

4. You should now see the following additional files or directories:
```
.terraform/
.terraform.lock.hcl
```
5. Expand the `.terraform/` directory tree as far as it will let you. This directory is where Terraform stores all provider information.
   - This directory should not be checked into source code
6. Open the `.terraform.lock.hcl` file.
   - This file contains version information for all providers references in the Terraform configuration, including hashes used to calculate the provider configuration in order to provide consistency from one run to the next.
   - This file should be checked into source code

## Update Terraform to reflect your unique environment
We're almost ready to deploy some resources in Azure, but first, you'll need to update your variables to reflect your unique environment.
1. Open `variables.tf` in the editor. Variables define values that can be input into Terraform at plan, apply, and destroy time.
   - Some variables, such as `location` have a default value that will be used if no value is supplied
   - Other variables are required input - they can either be defined as an environment variable `TF_VAR_<var name>`, defined in a "tfvars" file, or manually entered at plan/apply/destroy time when prompted by the Terraform CLI
1. Open `terraform.tfvars` in the editor - we'll use this file to define our variable values.
1. Set `prefix = "YOURPREFIXNAME"` to your first initial and lastname, e.g. `dbenedic`
1. Open the [Azure Portal](https://portal.azure.com) and find the name of your unique resource group. For example, my resource group is named `lab-062521-dben`.
1. Copy the resource group name and paste it into the `terraform.tfvars` file value for `resource_group_name`. Your tfvars file should look something like this (your strings will vary):
```
prefix = "dbenedic"
resource_group_name = "lab-062521-dben"
```
6. Hit `CTRL + S` to save the file

## Run a Terraform Plan
Terraform is great because it has a workflow that allows you to see the predicted changes before you apply them. This is known as a "plan".
1. From Cloud Shell, within the `terraform-intro` directory, run the following to generate a plan:
```
terraform plan
```
2. Note that our plan is NOT making any changes yet, it's just communicating with the Azure API and comparing what exists (reality) vs. what we have in our code (source of truth).
1. Your plan should show a bunch of resource "adds" with a green "+"
1. The plan summary should show `2 to add, 0 to change, 0 to destroy`
   - The summary allows you to see, at-a-glance, what resources Terraform thinks it's going to add, change, or destroy when it is run.
   - "Adds" are typically ok, but still worth looking at closely.
   - "Changes" or "Destroys" are destructive actions that require understanding before applying the plan.
1. It is best practice to output a plan and use that plan output to run an apply against that plan to ensure consistency between the plan and apply phases.

## Run another Terraform Plan, and output the plan
1. From Cloud Shell, within the `terraform-intro` directory, run the following to generate a plan and store its output:
```
terraform plan -out myplan.tfplan
```
2. Run `ls -la | grep "myplan.tfplan"` from Cloud Shell to stat the plan file
1. Run `cat myplan.tfplan` from Cloud Shell - note that the plan is not readable!

## Run Terraform Apply to create some stuff!
1. From Cloud Shell, within the `terraform-intro` directory, run the following to take our plan output and "make it so":
```
terraform apply myplan.tfplan
```
2. If you get an error during your apply, your plan will no longer be valid (by design). You can 1) rerun the plan and outupt a new plan or 2) run `terraform apply` and manually approve the plan when prompted
1. Let the apply run - it will tell you when it's finished!
1. Click on the output labelled `url = https://<some_fqdn>` - this will open the web page you just deployed to Azure... pat yourself on the back.
   - Note: when clicking the url from Cloud Shell, you may see an errant `"` at the end of your url in the address bar - be sure to remove that and try your url again!
1. Navigate to the [Azure Portal](https://portal.azure.com) and checkout your resources Terraform deployed for you in the spoke resource group

## Run Terraform Apply again - seeing any changes?
1. From Cloud Shell, within the `terraform-intro` directory, run the following to plan and apply with auto approval:
```
terraform apply -auto-approve
```
1. Note what Terraform does when there are no changes amongst your Terraform code, the state file, and Azure

## Explore Terraform state
Terraform uses a state file to keep track of its last-known state of resources it has applied. The statefile is important because it allows future Terraform plans and applies to happen incrementally and keeps your infrastructure idempotent.
1. After each Terraform apply, a statefile version is created. If it's the first apply, the statefile itself is also created.
1. From Cloud Shell, within the `terraform-intro` directory, run the following to see the statefiles that were created:
```
ls | grep tfstate
```
3. Note that you have 2 statefiles - a `terraform.tfstate` and a `terraform.tfstate.backup`
1. Run the following command to output the statefile to stdout:
```
cat terraform.tfstate
```
5. A few things of note about the statefile:
   - It's in JSON format
   - It has a version number
   - It tracks the version of Terraform that was used to generate it
   - It has a GUID called "lineage"
   - It contains outputs from the Terraform apply
   - It contains a record of the resources it provisioned

## Moving a local statefile to a remote backend
Part of Terraform's power lies in its statefile. When you start to grow a team that works with Terraform, you need a shared location to store, read, and write statefiles. Enter remote state.
1. Open `providers.tf` from the editor again
1. Find the commented-out block labelled `backend "azurerm"`. A backend is used to define a remote backend - in this case an Azure Storage Account. We're going to use a storage account that was pre-provisioned in your Azure lab environment.
1. Highlight the entire block of code that is commented out and hit `CTRL + /` to uncomment it.
1. From the Azure Portal, find the storage account you created in your lab resource group. Note the storage account name.
1. Still from the Azure Portal, locate the "Containers" section on the navigation bar under the "Data storage" heading.
1. Make note of the container name.
   - If you haven't already created a container or don't see one in the portal, create one now.
1. Back in the Cloud Shell editor, in the `providers.tf` file, update the `storage_account_name` and `container_name` to reflect the values you just looked up in the portal.
1. Run the following from Cloud Shell, following the prompts to move your statefile when asked:
```
terraform init
```
1. Once you have successfully moved the state into the remote backend, you may remove the local statefiles:
```
rm terraform.tfstate && rm terraform.tfstate.backup
```
2. Run another terraform apply to confirm everything is working:
```
terraform apply -auto-approve
```
3. IMPORTANT!!! Terraform state contains HIGHLY SENSITIVE information and should be SECURED accordingly! Same goes for source control, so don't check it in, ok?
   - Bonus points if you can figure out how we're preventing state from getting checked into the `terraform-intro` repo...

## Cleanup
Alas, all good things must come to an end. Time to destroy some stuff! After all, [rapid elasticity](https://nvlpubs.nist.gov/nistpubs/Legacy/SP/nistspecialpublication800-145.pdf) is one of the reasons why we use the cloud, right? BURN IT DOWN!
1. From Cloud Shell, within the `terraform-intro` directory, run the following to tear down our deployment:
```
terraform destroy
```
2. Review the items that Terraform is planning destroy (like a plan, but in reverse!) and type "yes" to approve.
1. Wait for Terraform to finish destroying stuff.
1. You're done! Congrats!
