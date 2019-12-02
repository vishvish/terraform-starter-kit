# Terraform-Starter-Kit

The code here bootstraps an infrastructure from a single entrypoint, the `./do` script. Firstly, Ansible creates a state bucket for Terraform, and then Terraform can be run layer-by-layer to provision any kind of infrastructure. It works locally as well as through Jenkins, so long as the Environment variables are defined.

For Terraform, the `./do` script runs both headlessly and interactively. Interactively, the script will offer options based on the available environments, available layers, and the three Terraform commands, plan, apply and destroy.

Updated the tags system to use Cloudposse's slick Terraform module here: https://github.com/cloudposse/terraform-null-label



#### Example

To build a bare bones infra consisting on a single VPC with a single private subnet, do the following once the dependencies are installed and the environment variables are present.

    ./do bootstrap # this creates the S3 bucket for the Terraform state
    ./do

    # And interactively choose an env, then the first layer, 001_vpc
    # Then 'plan' or 'apply'

This will plan or build the infrastructure. When finished, run `./do` again, but choose to destroy. Then,

    ./do teardown

This will remove the cleanup the state bucket in S3.

#### Dependencies

    Python
    Ansible
    AWS Cli
    Boto
    Terraform
    Bash

### Using `direnv`

Copy `envrc.template` to `.envrc` and fill in the appropriate details.

### Add your own environment

Copy `./environments/999_example` to a new directory under ./environments.

## Prepare the system

Create the S3 bucket required for Terraform state management:

    ./do bootstrap

Or:

    ansible-playbook 000_bootstrap.yml

### Run interactively

    ./do

And follow the prompts.

## When finished, cleanup

    ./do teardown

Or:

    ansible-playbook 001_teardown.yml

This removes both the infra and then finally the S3 bucket for state management.

## Run headlessly

#### Setup/teardown

    ./do bootstrap

And

    ./do teardown

Then, the format is:

    ./do <command> -e <env_name> -l <layer_name>

Where available commands are `plan`, `apply` and `destroy`.

    ./do plan -e 999_example -l 001_vpc
