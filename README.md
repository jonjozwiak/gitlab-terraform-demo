# GitLab Terraform Demo

Some code to create content within a GitLab environment.  This will create a public project with a repo and a sample Java app with CI build

## Usage

* Ensure you have a GitLab runner for your environment (not really needed - you can ignore this - you just won't have a pipeline run)
* Log into an existing GitLab server and create a personal access token.  In the upper right click your user icon and click `Edit Profile`.  Then on the left menu click 'Access Tokens'.  Create a personal access token with all scopes.  
  * MAKE CERTAIN THIS IS CALLED `Migration Token`
  * Direct by URL would be `https://YourGitlab.example.com/-/profile/personal_access_tokens`
* Clone this repo
* Create a var file like `env.tfvars` with your environment details

```hcl
gitlab_token = "glpat-#############"
gitlab_url   = "https://YourGitlab.example.com/api/v4/"
```

* Execute Terraform

```bash
apt-get update && apt-get -y install terraform
terraform init
terraform apply -var-file=env.tfvars
```

Note this will run `scripts/java_hello_automation.sh` to setup and configure the GitLab CLI and populate some repo content

* Once all done, cleanup:

```bash
terraform apply -destroy -var-file=env.tfvars
```
