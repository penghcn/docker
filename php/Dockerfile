##php-7.0.4-fpm nginx-1.9.12 yaf-3.0.2
FROM php:7.0.4-fpm
MAINTAINER pengh "qingseyunlan@gmail.com"

##install yaf
RUN pwd \
	&& curl -fsSL 'https://github.com/laruence/yaf/archive/yaf-3.0.2.tar.gz' -o yaf.tar.gz \
    && mkdir -p yaf \
    && tar -xf yaf.tar.gz -C yaf --strip-components=1 \
    && rm yaf.tar.gz \
    && ( \
        cd yaf \
        && phpize \
        && ./configure --with-php-config=php-config \
        && make -j$(nproc) \
        && make install \
    ) \
    && rm -r yaf \
    && docker-php-ext-enable yaf


##install nginx
ENV NGINX_VERSION 1.10.0-1~jessie

RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62 \
	&& echo "deb http://nginx.org/packages/debian/ jessie nginx" >> /etc/apt/sources.list \
	&& apt-get update \
	&& apt-get install --no-install-recommends --no-install-suggests -y \
						ca-certificates \
						nginx=${NGINX_VERSION} \
						nginx-module-xslt \
						nginx-module-geoip \
						nginx-module-image-filter \
						nginx-module-perl \
						nginx-module-njs \
						gettext-base \
	&& rm -rf /var/lib/apt/lists/*
# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
