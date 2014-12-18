FROM dell/passenger-base
MAINTAINER Dell Cloud Market Place <Cloud_Marketplace@dell.com>

# Set environment variable for package install
ENV DEBIAN_FRONTEND noninteractive

# Install packages
RUN apt-get update && apt-get install -yq \
    mysql-server=5.5.40-0ubuntu0.14.04.1 \
    git \
    nodejs \
    imagemagick \
    zlib1g-dev \
    libmysqlclient-dev \
    pwgen \
    supervisor

# Copy configuration files
ADD run.sh /run.sh
ADD my.cnf /etc/mysql/conf.d/my.cnf
ADD supervisord-nginx.conf /etc/supervisor/conf.d/supervisord-nginx.conf

# Remove pre-installed database
RUN rm -rf /var/lib/mysql/*

# Add MySQL utils
ADD create_mysql_admin_user.sh /create_mysql_admin_user.sh
RUN chmod 755 /*.sh

# Install adapter for mysql
RUN gem install mysql2

# Install Spree
RUN gem install spree -v 2.3.4

# Create Rails application
RUN rails _4.1.6_ new /app -s -d mysql

RUN cp -r /app /tmp/
RUN cp -r /opt/nginx/conf /tmp/

# Set volume folder for spree application files
VOLUME ["/app", "/var/lib/mysql","/opt/nginx/conf","/var/log/nginx"]

# Expose port
EXPOSE 3306 80 443

CMD ["/run.sh"]
