#docker-spree
This is a base Docker image to run a [Spree Commerce](http://spreecommerce.com/) - an open-source e-commerce Rails application.



## Components
The software stack comprises the following components:

Name          | Version    | Description
--------------|------------|------------------------------
Ubuntu        | Trusty     | Operating system
Spree         | 2.3.4      | E-commerce software
Ruby          | 2.1.4      | Programming language
Ruby on Rails | 4.1.6      | Web application framework

## Usage

### Start the container

To start your container with:

* A named container ("spree")
* Host port 3000 mapped to container port 3000 (default Spree application port)

Do:

    sudo docker run -d -p 3000:3000 --name spree dell/spree


and access Spree application from your browser:

    http://localhost:3000/


###Administration Console

The Spree administration console can be accessed by the below URL. The default credentials are username **spree@example.com** and password **spree123**.


     http://localhost:3000/admin


###Administration

There is a full documentation on using Spree, customisation and REST API information. This can be found from the below URL.

* [Guides](http://guides.spreecommerce.com/)
* [API Guide](http://guides.spreecommerce.com/api/)



## Reference

### Image Details

Based on [rlister/dockerfiles](https://github.com/rlister/dockerfiles/tree/master/spree)

Pre-built Image   | [https://registry.hub.docker.com/u/dell/spree](https://registry.hub.docker.com/u/dell/spree) 
