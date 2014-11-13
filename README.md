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
SQLite        | 3.8.2      | Database

## Usage

### Start the container

To start your container with:

* A named container ("spree")
* Host port 3000 mapped to container port 3000 (default Spree application port)

Do:

    sudo docker run -d -p 3000:3000 --name spree dell/spree


and access Spree application from your browser:

    http://localhost:3000/

### Advanced Example 1
To start your image with a app volume (which will survive a restart) for the Spree application, database and configuration files, do:

    sudo docker run -d -p 3000:3000 -v /app:/app --name spree dell/spree

The Spree application, database and configuration files will be available in **/app** on the host.


###Administration Console

The Spree administration console can be accessed by the below URL. The default credentials are username ```spree@example.com``` and password ```spree123```.


     http://localhost:3000/admin


###Database Management

The SQLite database files can be found under ***app/db*** within the container or via the mapped volume folder ***/app***. To access the database command line sqlite program, the first step is to install nsenter (with Docker 1.2) on the host. If you are a DCM user, please ssh into the instance and then enter ***sqlite3*** in the command line.

###Administration

There is comprehensive documentation on using Spree, customisation and REST API information. This can be found from the below URL.

* [Spree Guides](http://guides.spreecommerce.com/)
* [Spree API Guide](http://guides.spreecommerce.com/api/)
* [Spree Source](https://github.com/spree/spree/tree/2-4-stable)



## Reference

### Image Details

Based on [rlister/dockerfiles](https://github.com/rlister/dockerfiles/tree/master/spree)

Pre-built Image   | [https://registry.hub.docker.com/u/dell/spree](https://registry.hub.docker.com/u/dell/spree) 
