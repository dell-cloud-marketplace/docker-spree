#!/bin/bash

VOLUME_HOME="/app"


# Test if VOLUME_HOME has content
if [[ ! "$(ls -A $VOLUME_HOME)" ]]; then
     echo "Add Spree at $VOLUME_HOME"
     cp -R /tmp/app/* $VOLUME_HOME
  fi

 

# Start the Rails Server
/app/bin/bundle exec rails server
