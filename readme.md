# About

Devliveres an Container which includes the most used tools for an DevSecOps.  
The config and projects will be mapped from the host system. The user is ```coder```, and the local projects will be forwarded to ```/home/coder/projects```

# Why another toolbox
Yes, there are allready some similar projects.  
Personally I had trust issues to give in all my secrets or code as:
1) No Dockerfile available at all
2) If available, horrible to read or distributes about serveral includes/FROM's

For this I build my own.

# Details
I included several of my most requried tools.   
> All versions are the latest during the build time. This is not ideal and if you want to fix this feel free to provide an PR.
## Included packages:
**General**
- coder
- python3
- helm
- kubectl
- azure-cli
- terraform
- vault
- kubectx
- google-cloud-sdk

**Security**
- nmap
- mitmproxy
- theHarvester

# How to use
Run the run.sh or the following stand allone command (replace replace the two REPLACME)
```
docker run -d \
  --name cloudbox \
  -v $HOME/.kube:/home/coder/.kube \
  -v $HOME/.helm:/home/coder/.helm \
  -v $HOME/.ssh:/home/coder/.ssh \
  -v $HOME/REPLACME:/home/coder/project \
  -v $HOME/.gitconfig:/home/coder/.gitconfig \
  -v $HOME/.aws:/home/coder/.aws \
  -v $HOME/.azure:/home/coder/.azure \
  -v $HOME/ca-certificates:/usr/local/share/ca-certificates/extra \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $HOME/.oh-my-zsh:/home/coder/.oh-my-zsh \
  -v $HOME/.zshrc:/home/coder/.zshrc \
  -v $HOME//code-server-settings:/home/coder/.local/share/code-server/ \
  --net host \
  -e PASSWORD=REPLACEME \
  --env-file <(env | grep -i proxy) \
  --restart always \
  derbrobro/cloudbox:latest
```

Afterward you can launch your browser on localhost:8000, password ist the ```machine-id``` or ```REPLACEME``` (which should obviously replaced)/