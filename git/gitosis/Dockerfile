##gitosis
##wget https://raw.githubusercontent.com/penghcn/docker/master/git/gitosis/Dockerfile
FROM debian:jessie
MAINTAINER pengh "qingseyunlan@gmail.com"
## yourself password
ENV RSA_KEY_PASSPHRASE 07310b97d7daa0faa0c613d1023297a7da5edbf1154c17b4865106adc8f78520
ENV RSA_KEY_STORE_PATH /data/rsa
ENV RSA_KEY_STORE_FILE ${RSA_KEY_STORE_PATH}/id_rsa
ENV RSA_KEY_PUB_FILE ${RSA_KEY_STORE_PATH}/id_rsa.pub

ENV GIT_USER git
## yourself password
ENV GIT_PASS ee79beaa129e56a49f79901815f1d54f0cf2bfb538bf879c19469c180d80e323

ENV GIT_REPOSITORIES /home/${GIT_USER}/repositories

## yourself git config
ENV GIT_CONF_USER pengh
ENV GIT_CONF_MAIL qingseyunlan@gmail.com

ENV GITOSIS_ADMIN_PATH $GIT_REPOSITORIES/gitosis-admin.git
ENV GITOSIS_GITHUB https://github.com/res0nat0r/gitosis.git


RUN mkdir -p ${RSA_KEY_STORE_PATH} && cd ${RSA_KEY_STORE_PATH} 
RUN apt-get update && apt-get install -y openssh-server openssh-client git-core python-setuptools  
RUN ssh-keygen -t rsa -N ${RSA_KEY_PASSPHRASE} -f ${RSA_KEY_STORE_FILE} 

RUN useradd -m ${GIT_USER} \
	&& echo ${GIT_USER}:${GIT_PASS} | chpasswd \
	&& mkdir -p ${GIT_REPOSITORIES} \
	&& chown ${GIT_USER}:${GIT_USER} ${GIT_REPOSITORIES} \
	&& chmod 755 ${GIT_REPOSITORIES} \
	&& git config --global user.name ${GIT_CONF_USER} \
	&& git config --global user.email ${GIT_CONF_MAIL} 
	
RUN cd /tmp && git clone ${GITOSIS_GITHUB} && cd gitosis \
	&& python setup.py install 
RUN su - git -c gitosis-init < ${RSA_KEY_PUB_FILE} \
	&& chmod 755 ${GITOSIS_ADMIN_PATH}/hooks/post-update

EXPOSE 22
