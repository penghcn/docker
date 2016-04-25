## gitolite
## git clone git@xx.xx.xx.xx:pengh/express
## http://blog.csdn.net/zhangjs0322/article/details/32711211
## http://github.com/sitaramc/gitolite

## wget https://raw.githubusercontent.com/penghcn/docker/master/git/gitolite/Dockerfile
## sudo docker build -t pengh/gitolite:0.1.6 .

FROM debian:jessie
MAINTAINER pengh "qingseyunlan@gmail.com"
## yourself password
## ENV RSA_KEY_PASSPHRASE e0101ccc32364571eb9ef096116a19f78f317a23356ac0a3ca281ba3d5b06429

ENV GIT_USER git
## yourself password
ENV GIT_PASS 3c64cabe1fa4ad21724cef18eed9b3550511177b2643947cddcc3e62f28967f7

ENV GIT_HOME /home/${GIT_USER}
ENV GIT_REPOSITORIES $GIT_HOME/repositories

## yourself git config
ENV GIT_CONF_USER pengh
ENV GIT_CONF_MAIL qingseyunlan@gmail.com

RUN apt-get update && apt-get install -y openssh-server git-core
## RUN ssh-keygen -t rsa -N ${RSA_KEY_PASSPHRASE} -f ${RSA_KEY_STORE_FILE} 
## 空密码
RUN ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa

RUN useradd -m ${GIT_USER} \
	&& echo ${GIT_USER}:${GIT_PASS} | chpasswd \
	&& mkdir -p ${GIT_REPOSITORIES} \
	&& chown ${GIT_USER}:${GIT_USER} ${GIT_REPOSITORIES} \
	&& chmod 755 ${GIT_REPOSITORIES} \
	&& git config --global user.name ${GIT_CONF_USER} \
	&& git config --global user.email ${GIT_CONF_MAIL} 

RUN cp ~/.ssh/id_rsa.pub ${GIT_HOME}/gitolite_admin_pengh.pub \
	&& echo 'cd $HOME && echo $HOME \
		&& mkdir -p $HOME/bin \
		&& git clone git://github.com/sitaramc/gitolite \
		&& gitolite/install -to $HOME/bin \
		&& $HOME/bin/gitolite setup -pk gitolite_admin_pengh.pub'\
	| tee /tmp/gitolite.sh\
	&& chmod 0777 /tmp/gitolite.sh
	
RUN su - ${GIT_USER} -s /bin/bash /tmp/gitolite.sh \
	&& rm /tmp/gitolite.sh \
	&& rm ${GIT_HOME}/gitolite_admin_pengh.pub

VOLUME $GIT_REPOSITORIES

CMD service ssh restart

EXPOSE 22
