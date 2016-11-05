# symfony-mariadb-nginx

A containerized [symfony](https://symfony.com/) stack you can use to start your next symfony project.

Using this framework you're instantly developing your app in containers, plus you get built-in tools to deploy your app to Kubernetes or Openshift. Start with containers and deploy with containers, all within the same framework. No duplication. No wasted effort.

Don't beleive it? Skip down to *[Start with the symfony demo](#symfony-demo)*, and try it out.

## Getting started

If you want to hop in and start creating your next symfony masterpiece, the following will get started. But if you want to kick the tires a bit and see how the project works, skip down to the *[Start with the symfony demo](#symfony-demo)* section, and see how to launch the [Symfony Demo](https://github.com/symfony/symfony-demo) project in containers.

To get started developing, you'll first need to clone this project and have the requirements installed. Once you've got that, then run the following commands to setup your development environment: 

```
# Set the working directory to the root of the cloned project
$ cd symfony-mariadb-nginx

# Build the images. NOTE: the following command will delete whatever is in the *symfony* directory. If you don't
# want that, then run `make build` instead.
$ make build_from_scratch

# Run in development mode
$ make run
```
The `make run` command, which is running `ansible-container run`, takes a few minutes to finish. When it does, you will see the following message from the *symfony* container:

```
symfony_1            |  ✔  Symfony 3.1.6 was successfully installed. Now you can:
symfony_1            |
symfony_1            |     * Change your current directory to /symfony/symfony
symfony_1            |
symfony_1            |     * Configure your application in app/config/parameters.yml file.
symfony_1            |
symfony_1            |     * Run your application:
symfony_1            |         1. Execute the php bin/console server:start command.
symfony_1            |         2. Browse to the http://localhost:8000 URL.
symfony_1            |
symfony_1            |     * Read the documentation at http://symfony.com/doc
symfony_1            |
symfony_1            | + cd /symfony/symfony
symfony_1            | + exec php bin/console server:run 0.0.0.0:8000
symfony_1            |
symfony_1            |  [OK] Server running on http://0.0.0.0:8000
symfony_1            |
symfony_1            |  // Quit the server with CONTROL-C.
symfony_1            |
```

The *symfony* and *mariadb* services are now running in the foreground, and output from each is being displayed in your terminal window. Since we're in development mode the *nginx* service is not needed, and so you may have noticed it quietly stop at the beginning.

The root of the project is mounted to */symfony* in the *ansible_symfony_1* container, and an empty project called *symfony* is automatically created at */symfony/symfony*, so inside the container you can access the project at */symfony/symfony*, and outside the container you can access it directly in the *symfony* folder found in the root directory.

### Accessing the web server

During development the PHP web server is running in the *ansible_symfony_1* container and is available on port 8000. You can access it in a web browser using the IP address of your Docker host. If you're running Docker Machine this will be the IP address of the vagrant box, which you can get by running `docker-mahine ip default`, where *default* is the name of the vagrant box.

When you visit the web site at [http://_your_docker_host_ip:8000](http://127.0.0.1:8000), you will see the following default symfony page:

<img src="https://github.com/chouseknecht/symfony-mariadb-nginx/blob/images/img/empty-project-page.png" alt="New project page" />

### Running console commands

Using a separate terminal window, you can run console commands using `make console` and pasing parameters. Using `docker exec` the console command will execute inside the *ansible_symfony_1* conainer and display output in your terminal window.

### Running compose commands

The *ansible_symfony_1* container includes composer, and you can access it using `make composer` and passing parameters. The make commands invokes `docker exec` to run the actual command inside the contianer, and the output is displayed in your terminal window. 

### Running commands directly

You can shell into the *ansible_symfony_1* container directly by running `docker exec -it ansible_symfony_1 /bin/bash`. This will put you at a bash shell prompt inside the container, and from there you can execut *php* and *composer* command directly.

### php.ini

A template is used to create the php.ini file inside the *ansible_symfony_1* container. Lots of variables can be set in *ansible/group_vars/all* These settings will be applied to the symfony container as well as the nginx container the next time you run *make build*

<h2 id="symfony-demo">Start with the symfony demo</h2>

Instead of starting with an empty project, you can start with a fully functioning demo, try it out, deploy it, and see how the framework performs.

You'll need to first clone this project and install the requirements. Once you've completed that, then run the following commands to start the demo:

```
# Set the working directory to the root of the clone
$ cd symfony-mariadb-nginx

# Build the container images with the demo project. WARNING: the following command will remove anything you may have 
# in the *symphony* folder.
$ make demo

# Run the project in development mode
$ make run
```

The above commands created a *symfony* directory containing the demo project. The root of the your local clone is mounted as */symfony* to the *ansible_symfony_1* container, so inside the container the demo project can be found at */symfony/symfony*, and outside it is simply the *symfony* directory in the root directory.

The PHP web servers is running inside *ansible_symfony_1* and listening on port 8000. You an access the server using a web browser and pointing to port 8000 at the IP address of your Docker host. If your running Docker Engine, then the IP address is most likely *127.0.0.1*. If you're running Docker Machine, you'll need the IP address of the vagrant box, which you can get by running `docker-machine ip default`, where *default* is the name of your vagrant box.

When you access the web site at [http://_your_docker_host_ip:8000](http://127.0.0.1:8000), you will see the following page:


During the startup of the *ansible_symfony_1* container, commands were automatically executed to create the *mysql* database, create the schema, and load the sample data. If you browse the backend page, for example, you will be able to click the *Login* button and see live data from the *mariadb* service.









