# symfony-mariadb-nginx

A containerized [symfony](https://symfony.com/) stack you can use to start your next symfony project.

Using this framework you're instantly developing your app in containers, plus you automatically get built-in tools that will deploy your app directly to Kubernetes or Openshift.

Start with containers and deploy with containers, all within the same framework. No duplication. No wasted effort.

Don't believe it? After installing the requirements, skip to *[Start with the symfony demo](#symfony-demo)*, and try it out.

## Requirements

- [Ansible](http://docs.ansible.com/ansible/intro_installation.html)
- [Ansible Container](https://github.com/ansible/ansible-container)
- make
- [Docker Engine](https://www.docker.com/products/docker-engine) or [Docker Machine](https://docs.docker.com/machine/install-machine/)
- clone this project by running `git@github.com:chouseknecht/symfony-mariadb-nginx.git`

If installing Docker Machine, we recommend installing version 1.11.2, as the newer 1.12 release has not been tested with Ansible Container.

## Getting started

If you want to hop in and start creating your next symfony masterpiece, the following will get started. But if you want to kick the tires a bit and see how the project works, skip down to the *[Start with the symfony demo](#symfony-demo)* section, and see how to launch the [Symfony Demo](https://github.com/symfony/symfony-demo) project in containers.

To get started developing, you'll first need to clone this project and have the requirements installed. Once you've got that, then run the following commands to setup your development environment: 

```
# Set the working directory to the root of the cloned project
$ cd symfony-mariadb-nginx

# Build the images. WARNING: the following command will remove any project you may have 
# in the *symphony* folder.
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

# Build the images. WARNING: the following command will remove any project you may have 
# in the *symphony* folder.
$ make build_from_scratch

# Run the demo project
$ make demo
```
When the `make demo` command completes, you will see the following output in the terminal window:

```
symfony_1            |  --- ------------------------------ ------------------
symfony_1            |       Bundle                         Method / Error
symfony_1            |  --- ------------------------------ ------------------
symfony_1            |   ✔   FrameworkBundle                relative symlink
symfony_1            |   ✔   WhiteOctoberPagerfantaBundle   relative symlink
symfony_1            |  --- ------------------------------ ------------------
symfony_1            |
symfony_1            |  [OK] All assets were successfully installed.
symfony_1            |
symfony_1            | > Sensio\Bundle\DistributionBundle\Composer\ScriptHandler::installRequirementsFile
symfony_1            | > Sensio\Bundle\DistributionBundle\Composer\ScriptHandler::prepareDeploymentTarget
symfony_1            |     Skipped installation of bin bin/doctrine-dbal for package doctrine/dbal: file not found in package
symfony_1            |     Skipped installation of bin bin/doctrine for package doctrine/orm: file not found in package
symfony_1            |     Skipped installation of bin bin/doctrine.php for package doctrine/orm: file not found in package
symfony_1            | + php bin/console doctrine:schema:create
mariadb_1            | 2016-11-05  2:06:34 140288996005632 [Warning] IP address '172.17.0.4' could not be resolved: Name or service not known
symfony_1            | ATTENTION: This operation should not be executed in a production environment.
symfony_1            |
symfony_1            | Creating database schema...
symfony_1            | Database schema created successfully!
symfony_1            | + php bin/console doctrine:fixtures:load --no-interaction
symfony_1            |   > purging database
symfony_1            |   > loading AppBundle\DataFixtures\ORM\LoadFixtures
symfony_1            | + cd /symfony/symfony
symfony_1            | + exec php bin/console server:run 0.0.0.0:8000
symfony_1            |
symfony_1            |  [OK] Server running on http://0.0.0.0:8000
symfony_1            |
symfony_1            |  // Quit the server with CONTROL-C.
```
The *symfony* and *mariadb* services are now running in the foreground, and output from each is being displayed in your terminal window. Since we're in development mode the *nginx* service is not needed, and so you may have noticed it quietly stop at the beginning.

The root of the project is mounted to */symfony* in the *ansible_symfony_1* container, and an empty project called *symfony* is automatically created at */symfony/symfony*, so inside the container you can access the project at */symfony/symfony*, and outside the container you can access it directly in the *symfony* folder found in the root directory.

### Accessing the web server

The PHP web server is running inside *ansible_symfony_1* and listening on port 8000. You an access the server using a web browser and pointing to port 8000 at the IP address of your Docker host. If you're running Docker Engine, then the IP address is most likely *127.0.0.1*. If you're running Docker Machine, you'll need the IP address of the vagrant box, which you can get by running `docker-machine ip default`, where *default* is the name of your vagrant box.

When you access the web site at [http://_your_docker_host_ip:8000](http://127.0.0.1:8000), you will see the following page:

<img src="https://github.com/chouseknecht/symfony-mariadb-nginx/blob/images/img/demo-app-page.png" alt="Demo app page" />

During the startup of the *ansible_symfony_1* container, commands were automatically executed to create the *mysql* database, create the schema, and load the sample data. If you click the *Browse backend* button, for example, you will be able to click the *Login* button and see live data from the *mariadb* service.

## Test your code

When you reach a point where you're ready to perform a build and test your code, run the following commands. You can run these commands with either the empty project, the demo project, or your project:

```
# Set the working directory to the root of the clone
$ cd symfony-mariadb-nginx

# Rebuild the images. This will copy your latest app code into the nginx image.
$ make build

# Rund the containers in production mode
$ make run_prod
```
Now you will have the *mariadb* and *nginx* services running in the foreground, and this time the symfony service quietly stopped.

We don't want to run the PHP web server in production. Instead, we want to run something more robust like Nginx with PHP-FPM FastCGI, and so that's exactly what we're doing here.  

The *nginx* service has a copy of the app code deployed as a static asset to */var/www/nginx/*, in the same way we would deploy to a typical production web server, and inside the *nginx* container we're running supervisord to manage an nginx process and a php-fpm process. The nginx process listens for requests on port 8888, and forwards valid requests to the php-fpm process via a Unix socket.

### Load demo data

If you're using the demo project, you'll need to manualy create the database schema and load the data. You can do this by opening a command shell on the *nginx* container and running the *console* commands. Here are the exact commands:

```
# Open a command shell in the nginx container
$ docker exec -it ansible_nginx_1 /bin/bash

# Set the working directory to the web directory
$ cd /var/www/nginx

# Create the database schema
$ php bin/console doctrine:schema:create

# Load the data
php bin/console doctrine:fixtures:load --no-interaction
```

### Learn about the build process

To understand more about how the `build` process works, take a look at  [ansible/main.yml](https://github.com/chouseknecht/symfony-mariadb-nginx/blob/master/ansible/main.yml). This is an Ansible playbook, which Ansible Container executes to build each of the services in our project.

### Access the production web server

Access the web server exactly the same as before, except this time use port 8888.

## Deploying to OpenShift

For this example, we're using the [OpenShift All-In-One VM](https://www.openshift.org/vm/), so to follow along you'll need to have the VM running, and the [oc client](https://github.com/openshift/origin/releases/tag/v1.3.0) installed.

After you start the VM for the first time, the following message will be displayed, revealing the IP address of the VM and access instructions:

```
==> default: Successfully started and provisioned VM with 2 cores and 5 G of memory.
==> default: To modify the number of cores and/or available memory modify your local Vagrantfile
==> default:
==> default: You can now access the OpenShift console on: https://10.2.2.2:8443/console
==> default:
==> default: Configured users are (<username>/<password>):
==> default: admin/admin
==> default: user/user
==> default: But, you can also use any username and password combination you would like to create
==> default: a new user.
==> default:
==> default: You can find links to the client libraries here: https://www.openshift.org/vm
==> default: If you have the oc client library on your host, you can also login from your host.
==> default:
==> default: To use OpenShift CLI, run:
==> default: $ oc login https://10.2.2.2:8443
```
### Authenticate with the oc client

Log in using the *admin* account

```
# Authenticate with the new VM
$ oc login https://10.2.2.2:8443
username: admin
password:
```

### Configure insecure registry access

For the deployment we'll be pushing images to the insecure registry hosted on the VM. The address of the registry is *hub.* followed by the IP address of the VM. For example, `hub.10.2.2.2`. Add an entry to your local */etch/hosts* file pointing this name to the IP address of the VM. 

You'll need to configure Docker to access the registry. If you're running Docker Engine, follow the [instructions here](https://docs.docker.com/registry/insecure/#/deploying-a-plain-http-registry) to add the *--insecure-registry* option.

If you're running Docker Machine, create a new VM that allows insecure access to the regsitry:

```
# Create a new Docker Machine VM named 'devel'. Replace 10.2.2.2 with the IP of your VM.
$ docker-machine create -d virtualbox --engine-insecure-registry hub.10.2.2.2 --virtualbox-host-dns-resolver devel
```

### Allow insecure access to the route

Using a web browser, access the OpenShift console at https://10.2.2.2:8443/console, replacing 10.2.2.2 with the IP address of your VM, and perform the following to allow insecure access to the registry:

- Open the *default* project
- From the Applications menu, access *routes*, and open the *docker-registry* route. 
- Edit the route
- Click on *Show options for secured routes*
- Set *TLS Termination* to *Edge*
- *Insecure Traffic* to *Allow*.

### Create a new OpenShift project

We'll need an OpenShift project with the same name as the project we've been working on. The project name is the name you chose when you cloned this repo. If you kept *symfony-mariadb-nginx*, then create a project with that name, for example:

```
# Create a new project with a name matching our local repo name
$ oc new-project symfony-mariadb-nginx --description="Deploying a symfony project to openshift" --display-name="symfony demo"

# Grant admin on the new project to your user account (admin)
$ oc policy add-role-to-user admin admin
```
### Log into the registry

If you completed the steps above, you should be able to login into the registry using a token generated by the *oc* client. The following command handles the login in one step:

```
# Log into the registry. Replace 10.2.2.2 with the IP of your VM.
$ docker login -u admin -p $(oc whoami -t) http://hub.10.2.2.2
Login Succeeded
```
### Build the images

Build the images to make sure your have the laetst code deployed in the *nginx* image. Also, if you had to create a new Docker Machine VM, it has no images, so you'll need to build them. Run the build command as follows:

```
# Set the working directory to the root of the project
$ cd symfony-mariadb-nginx

# Build the images
$ make build
```

### Push the images to the OpenShift registry

Before we can deploy, we need to push our images onto the OpenShift VM by executing `ansible-container push`. In the following example replace 10.2.2.2 with the IP of your VM and *symfony-mariadb-nginx* with the name of your project:

```
# Push the images to the OpenShift registry
$ ansible-container push --push-to http://hub.10.2.2.2/symfony-mariadb-nginx
```

### Generate the deployment playbook and role

We need to transform our orchestration document [ansible/container.yml](https://github.com/chouseknecht/symfony-mariadb-nginx/blob/master/ansible/container.yml) into deployment instrutions for OpenShift by running `ansible-container shipit`. This will generate an Ansible playbook and role that will execute the deployment:

```
```



















