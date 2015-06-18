FROM dell/passenger-base:1.1
MAINTAINER Dell Cloud Market Place <Cloud_Marketplace@dell.com>

# Set environment variable for package install
ENV DEBIAN_FRONTEND noninteractive

# Install packages
RUN apt-get update && apt-get install -yq \
    git \
    imagemagick \
    libmysqlclient-dev \
    mysql-server-5.5 \
    nodejs \
    pwgen \
    supervisor \
    zlib1g-dev

# Clean package cache
RUN apt-get -y clean && rm -rf /var/lib/apt/lists/*

# Copy configuration files
COPY run.sh /run.sh
COPY my.cnf /etc/mysql/conf.d/my.cnf

# Remove pre-installed database
RUN rm -rf /var/lib/mysql/*

# Add MySQL utils
COPY create_mysql_admin_user.sh /create_mysql_admin_user.sh
RUN chmod 755 /*.sh

# Install adapter for mysql
RUN gem install mysql2

# Install Spree
RUN gem install spree -v 3.0

# Create Rails application
RUN rails _4.2.0_ new /app -s -d mysql

RUN cp -r /app /tmp/
RUN cp -r /opt/nginx/conf /tmp/

# Set volume folder for spree application files
VOLUME ["/app", "/var/lib/mysql","/opt/nginx/conf","/var/log/nginx"]

# Environmental variables
ENV MYSQL_PASS ""

# Expose port
EXPOSE 3306 443 80

CMD ["/run.sh"]
