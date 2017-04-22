# docker

## install on ubuntu 16.04
    sudo apt-get update  
    sudo apt-get install apt-transport-https ca-certificates  
    sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
    echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" | sudo tee /etc/apt/sources.list.d/docker.list
    sudo apt-get update
    apt-cache policy docker-engine
    
    sudo apt-get remove docker docker-engine
    sudo apt-get install docker-engine
    sudo docker -v
  
## Dockerfile
    gitolite
    php7-nginx-yaf
    nginx-openssl-1.0.2
    ...
