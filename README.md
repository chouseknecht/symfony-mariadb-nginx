# symfony-nginx-mariadb

Use as a starting point for creating and managing a containerized symfony application. Includes everything needed to start developing an application on your laptop as well as deploy it to OpenShfit or Kubernetes.

## Start developing

If you want to hop in and start creating your next symfony masterpiece, here's how to get started, after you install the requirements and clone this project:

```
# Set the working directory to the root of the cloned project
$ cd symfony-mariadb-nginx

# Build the images
$ make build

# Run the containers development mode
$ make run
```
The *symfony* and *mariadb* services will be started in an attached state or in the foreground, and output from each will appear in your terminal window. Since we're in development mode the *nginx* service will quietly stop.

The root of the project is mounted to */symfony* in the *ansible_symfony_1* container, and an empty project called *symfony* is automatically created. The *symfony* project exists in the root of local clone, and at */symfony/symfony* inside the *ansible_symfony_1* container. You can start writing code in the *symfony* directory.

## Accessing the web server

During development PHP web server is available on port 8000. You can access it in a web browser using the IP address of your Docker host. If you're running Docker Machine this will be the IP address of the vagrant box, which you can get by running `docker-mahine ip default`, where *default* is the name of the vagrant box.

When you visit the web site at http://<your Docker host IP>:8000, you will see the following default symfony page:

## Running console commands

Using a separate terminal window, you can run console commands using `make console` and pasing parameters. Using `docker exec` the console command will execute inside the *ansible_symfony_1* conainer and display output in your terminal window.

## Running compose commands

The *ansible_symfony_1* container includes composer, and you can access it using `make composer` and passing parameters. The make commands invokes `docker exec` to run the actual command inside the contianer, and the output is displayed in your terminal window. 

## Running commands directly

You can shell into the *ansible_symfony_1* container directly by running `docker exec -it ansible_symfony_1 /bin/bash`. This will put you at a bash shell prompt inside the container, and from there you can execut *php* and *composer* command directly.

## php.ini

A template is used to create the php.ini file inside the *ansible_symfony_1* container. Lots of variables can be set in *ansible/group_vars/all* These settings will be applied to the symfony container as well as the nginx container the next time you run *make build*



