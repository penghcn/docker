##gitolite
##wget https://raw.githubusercontent.com/penghcn/docker/master/git/gitolite/Dockerfile
FROM debian:jessie
MAINTAINER pengh "qingseyunlan@gmail.com"
## yourself password
ENV RSA_KEY_PASSPHRASE e0101ccc32364571eb9ef096116a19f78f317a23356ac0a3ca281ba3d5b06429
ENV RSA_KEY_STORE_PATH /data/rsa
ENV RSA_KEY_STORE_FILE ${RSA_KEY_STORE_PATH}/id_rsa
ENV RSA_KEY_PUB_FILE ${RSA_KEY_STORE_PATH}/id_rsa.pub

ENV GIT_USER git
## yourself password
ENV GIT_PASS 3c64cabe1fa4ad21724cef18eed9b3550511177b2643947cddcc3e62f28967f7

ENV GIT_REPOSITORIES /home/${GIT_USER}/repositories

## yourself git config
ENV GIT_CONF_USER pengh
ENV GIT_CONF_MAIL qingseyunlan@gmail.com

ENV GITOLITE_ADMIN_PATH $GIT_REPOSITORIES/gitosis-admin.git
## http://github.com/sitaramc/gitolite
ENV GITOLITE_GITHUB git://github.com/sitaramc/gitolite


RUN mkdir -p ${RSA_KEY_STORE_PATH} && cd ${RSA_KEY_STORE_PATH} 
RUN apt-get update && apt-get install -y openssh-server openssh-client git-core
RUN ssh-keygen -t rsa -N ${RSA_KEY_PASSPHRASE} -f ${RSA_KEY_STORE_FILE} 

RUN useradd -m ${GIT_USER} \
	&& echo ${GIT_USER}:${GIT_PASS} | chpasswd \
	&& mkdir -p ${GIT_REPOSITORIES} \
	&& chown ${GIT_USER}:${GIT_USER} ${GIT_REPOSITORIES} \
	&& chmod 755 ${GIT_REPOSITORIES} \
	&& git config --global user.name ${GIT_CONF_USER} \
	&& git config --global user.email ${GIT_CONF_MAIL} 

RUN su - git -c cd /tmp && mkdir -p /tmp/bin \
	&& git clone ${GITOLITE_GITHUB} \
	&& gitolite/install -to /tmp/bin \
	&& /tmp/bin/gitolite setup -pk ${RSA_KEY_PUB_FILE}

EXPOSE 22
