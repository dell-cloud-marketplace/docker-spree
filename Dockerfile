FROM dell/rails
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
    libmysqlclient-dev


# Copy configuration files
ADD run.sh /run.sh
RUN chmod 755 /*.sh
ADD my.cnf /etc/mysql/conf.d/my.cnf

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

# Set volume folder for spree application files
VOLUME ["/app", "/var/lib/mysql"]

# Spree directory
WORKDIR /app

# Expose Spree port
EXPOSE 3000 3306
CMD ["/run.sh"]
