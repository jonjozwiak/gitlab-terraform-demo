# GitLab Terraform Demo

Some code to create content within a GitLab environment.  This will create a public project with a repo and a sample Java app with CI build

## Usage

* Ensure you have a GitLab runner for your environment (not really needed - you can ignore this - you just won't have a pipeline run)

  ```bash
  docker run -d --name gitlab-runner --privileged --network host --restart always \
  -v /srv/gitlab-runner/config:/etc/gitlab-runner -v /var/run/docker.sock:/var/run/docker.sock \
  --hostname 172.17.0.3 gitlab/gitlab-runner:latest

  export REG_TOKEN="<Your Runner Registration token>"
  docker run --rm -it --privileged --network host -v /srv/gitlab-runner/config:/etc/gitlab-runner \
  gitlab/gitlab-runner --debug -l debug register --non-interactive  --url "http://localhost" \
  --registration-token "$REG_TOKEN" --executor "docker" --docker-image alpine:latest --description "docker-runner" \
  --maintenance-note "Free-form maintainer notes about this runner" --tag-list "docker,aws" \
  --run-untagged="true"  --locked="false" --access-level="not_protected"

  # Update the runner to use host network (sigh)
  sudo vi /srv/gitlab-runner/config/config.toml
    # Under [runners.docker]
    network_mode = "host"
  
  # Restart the runner 
  docker ps 
  docker stop gitlab-runner  # Might need the container ID here instead of gitlab-runner
  docker start gitlab-runner
  ```

* Log into an existing GitLab server and create a personal access token.  In the upper right click your user icon and click `Edit Profile`.  Then on the left menu click 'Access Tokens'.  Create a personal access token with all scopes.  
  * MAKE CERTAIN THIS IS CALLED `Migration Token`
  * Direct by URL would be `https://YourGitlab.example.com/-/profile/personal_access_tokens`
* Clone this repo
* Create a var file like `env.tfvars` with your environment details

```hcl
gitlab_token = "glpat-#############"
gitlab_url   ="http://localhost"
##gitlab_url   = "https://YourGitlab.example.com/api/v4/"
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
