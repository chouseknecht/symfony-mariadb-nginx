#!/bin/bash
#
# Removes all containers and images associated with the app 
#

echo "Removing all symfony-mariadb-nginx containers and images..."

containers=$(docker ps -a --format "{{.Names}}" | grep -e ansible_symfony -e ansible_nginx -e ansible_mariadb | wc -l | tr -d '[[:space:]]')
if [ ${containers} -gt 0 ]; then 
    docker rm --force $(docker ps -a --format "{{.Names}}" | grep -e ansible_symfony -e ansible_nginx -e ansible_mariadb)
else
    echo "No ansible_symfony, ansible_mariadb, ansible_nginx containers found"
fi

images=$(docker images -a --format "{{.Repository}}:{{.Tag}}" | grep symfony-mariadb-nginx | wc -l | tr -d '[[:space:]]')
if [ ${images} -gt 0 ]; then
    docker rmi --force $(docker images -a --format "{{.Repository}}:{{.Tag}}" | grep symfony-mariadb-nginx )
else
    echo "No symfony-mariadb-nginx images found"
fi

