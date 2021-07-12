#!/bin/bash
set -euo pipefail
docker rm -f cloudbox

IMAGE_TAG="latest"
PW=$(cat /etc/machine-id)
echo "Password: ${PW}"

docker run -d \
  --name cloudbox \
  -v $HOME/.kube:/home/coder/.kube \
  -v $HOME/.helm:/home/coder/.helm \
  -v $HOME/.ssh:/home/coder/.ssh \
  -v $HOME/repo:/home/coder/project \
  -v $HOME/.gitconfig:/home/coder/.gitconfig \
  -v $HOME/.aws:/home/coder/.aws \
  -v $HOME/.azure:/home/coder/.azure \
  -v $HOME/ca-certificates:/usr/local/share/ca-certificates/extra \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $HOME/.oh-my-zsh:/home/coder/.oh-my-zsh \
  -v $HOME/.zshrc:/home/coder/.zshrc \
  -v $HOME//code-server-settings:/home/coder/.local/share/code-server/ \
  --net host \
  -e PASSWORD=${PW} \
  --env-file <(env | grep -i proxy) \
  --restart always \
  derbrobro/cloudbox:$IMAGE_TAG
