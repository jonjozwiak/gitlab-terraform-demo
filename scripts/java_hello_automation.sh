#!/bin/bash

# Note - This script expects GITLAB_TOKEN to be exported
# Note - The token must be named "Migration Token" (or modify below)
TOKEN_NAME="Migration Token"

# env.CODESPACE_NAME is the name of the codespace
CODESPACE_FORWARD="${CODESPACE_NAME}-80.preview.app.github.dev"
GITLAB_URL="https://${CODESPACE_FORWARD}/"

# Check for port 80 forwarded
if curl --max-time 5 -I "$GITLAB_URL" 2>&1 | grep -w "200\|301\|302" ; then     
  echo "$GITLAB_URL is up... continuing" 
else     
  echo "$GITLAB_URL is down.  Check that port forwarding to 80 is setup!!!"
  exit 0
fi


echo "############### Setting up GitLab CLI ###############" 
echo "### This writes to ~/.config/glab-cli/config.yml  ###"
echo "#####################################################"

wget https://gitlab.com/gitlab-org/cli/-/releases/v1.24.1/downloads/glab_1.24.1_Linux_x86_64.deb
sudo apt-get -y install ./glab_1.24.1_Linux_x86_64.deb

export GITLAB_HOSTNAME=$CODESPACE_FORWARD
glab auth login --hostname $GITLAB_HOSTNAME "$GITLAB_TOKEN"
glab config set -h $GITLAB_HOSTNAME api_protocol http
glab config set -h $GITLAB_HOSTNAME api_host localhost
glab config set git_protocol https
glab config set editor vim
glab config set -h $GITLAB_HOSTNAME token "$GITLAB_TOKEN"
glab config set host $GITLAB_HOSTNAME
glab config set token "$GITLAB_TOKEN"
glab config set gitlab_uri $GITLAB_HOSTNAME
glab auth status

echo "##########################################################"
echo "######## Pulling the repo and adding some content ########"
echo "##########################################################"

WORK_DIR=`mktemp -d`

# check if tmp dir was created
if [[ ! "$WORK_DIR" || ! -d "$WORK_DIR" ]]; then
  echo "Could not create temp dir"
  exit 1
fi

cd $WORK_DIR
glab repo clone demo-content/java-hello
cd - 
cd $WORK_DIR/java-hello

# http://<token-name>:<token>@localhost/group/repo.git
git remote set-url origin "http://$TOKEN_NAME:$GITLAB_TOKEN@localhost/demo-content/java-hello.git"

git checkout java-hello-mvp
git rm README.md
cp -rp $CODESPACE_VSCODE_FOLDER/gitlab-terraform-demo/files/* .
cp -rp $CODESPACE_VSCODE_FOLDER/gitlab-terraform-demo/files/.gitlab-ci.yml .
git add . 
git commit -am "initial commit for MVP"
git push

## Origin here must align to what is in 'glab auth config'
git remote set-url origin "${GITLAB_URL}demo-content/java-hello.git"

glab mr create -s java-hello-mvp -b main -t "Add Java Hello World MVP" -d "Closes #2 by implementing MVP" -R demo-content/java-hello

glab mr merge -m "LGTM" --when-pipeline-succeeds false -y -R demo-content/java-hello 1 

glab issue create -t "Design v2" -d "This is a placeholder for version 2 discussion" --label important -y -R demo-content/java-hello

cd - 
