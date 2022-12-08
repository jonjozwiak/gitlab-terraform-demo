# GitLab Terraform Demo

Some code to create content within a GitLab environment.  This will create a public project with a repo and a sample Java app with CI build

## Usage

* Ensure you have a GitLab runner for your environment
* Log into an existing GitLab server and create a personal access token.  In the upper right click your user icon and click `Edit Profile`.  Then on the left menu click 'Access Tokens'.  Create a personal access token with all scopes.  
  * Direct by URL would be `https://YourGitlab.example.com/-/profile/personal_access_tokens`
* Clone this repo
* Create a var file like `env.tfvars` with your environment details

```hcl
gitlab_token = "glpat-#############"
gitlab_url   = "https://YourGitlab.example.com/api/v4/"
```

* Download and setup the GitLab CLI (used to cover things that Terraform can't)

```bash
wget https://gitlab.com/gitlab-org/cli/-/releases/v1.24.1/downloads/glab_1.24.1_Linux_x86_64.deb
sudo apt-get install ./glab_1.24.1_Linux_x86_64.deb
```

  * Save your personal access token in a file called my_token.txt
  * Authenticate with your token (updating your hostname appropriately).  Note in my case I had some unusual network config with containers and port forwarding so I needed to point API to http and localhost
  
  ```bash
  glab auth login --hostname YourGitlab.example.com --stdin < my_token.txt
  glab config set -h YourGitlab.example.com api_protocol http
  glab config set -h YourGitlab.example.com api_host localhost
  glab config set git_protocol https
  glab config set editor vim
  glab config set -h YourGitlab.example.com token YourAPIToken
  glab config set host YourGitlab.example.com
  glab auth status

  glab repo list -a
  # glab issue list -R mygroup/myrepo
  # glab mr create -f -s source_branch -b target_branch -t title_of_merge_request -d description_of_merge_request
  ```

* Execute Terraform

```bash
apt-get update && apt-get -y install terraform
terraform init
terraform apply -var-file=env.tfvars
```


* Once all done, cleanup:

```bash
terraform apply -destroy -var-file=env.tfvars
```

