FROM ubuntu:trusty
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
    build-essential \
    libssl-dev \
    libreadline-dev \
    libyaml-dev \
    libcurl4-openssl-dev \
    libmysqlclient-dev


# Copy configuration files
ADD start-mysqld.sh /start-mysqld.sh
ADD run.sh /run.sh
RUN chmod 755 /*.sh
ADD my.cnf /etc/mysql/conf.d/my.cnf

# Remove pre-installed database
RUN rm -rf /var/lib/mysql/*

# Add MySQL utils
ADD create_mysql_admin_user.sh /create_mysql_admin_user.sh
RUN chmod 755 /*.sh


# Install Ruby
ADD http://ftp.ruby-lang.org/pub/ruby/2.1/ruby-2.1.4.tar.gz /tmp/
RUN \
  cd /tmp && \
  tar -xzvf ruby-*.tar.gz && \
  rm -f ruby-*.tar.gz && \
  cd ruby-* && \
  ./configure --disable-install-doc && \
  make && \
  make install && \
  cd .. && \
  rm -rf ruby-*


# Install Ruby Gems
RUN gem install bundler --no-rdoc --no-ri

# Install adapter for mysql
RUN gem install mysql2

# Install Rails
RUN gem install rails -v 4.1.6

# Install Spree
RUN gem install spree -v 2.3.4

# Create Rails application
RUN rails _4.1.6_ new /app -s -d mysql

# Add Rails application to Spree
RUN spree install -A /app


RUN cp -r /app /tmp/

# Set volume folder for spree application files
VOLUME ["/app", "/var/lib/mysql"]

# Spree directory
WORKDIR /app


# Expose Spree port
EXPOSE 3000 3306
CMD ["/run.sh"]
