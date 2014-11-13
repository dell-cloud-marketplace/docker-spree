FROM ubuntu:trusty
MAINTAINER Dell Cloud Market Place <Cloud_Marketplace@dell.com>


# Set environment variable for package install
ENV DEBIAN_FRONTEND noninteractive

# Install packages
RUN apt-get update && apt-get install -yq \
    git \
    nodejs \
    imagemagick \
    libsqlite3-dev \
    sqlite3 \
    zlib1g-dev \
    build-essential \
    libssl-dev \
    libreadline-dev \
    libyaml-dev \
    libcurl4-openssl-dev 


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

# Install Rails
RUN gem install rails -v 4.1.6

# Install Spree
RUN gem install spree -v 2.3.4

# Create Rails application
RUN rails _4.1.6_ new /app -s

# Add Rails application to Spree
RUN spree install -A /app

RUN cp -r /app /tmp/

# Set volume folder for spree applciation files
VOLUME /app

# Spree directory
WORKDIR /app

# Run scripts
ADD run.sh /run.sh
RUN chmod 755 /*.sh

# Expose Spree port
EXPOSE 3000
CMD ["/run.sh"]
