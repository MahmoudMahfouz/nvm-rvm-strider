# nvm-rvm-strider
Strider CI/CD with nvm and rvm

##Overview

Dockerized installation of [Strider](https://github.com/Strider-CD/strider) + [RVM](https://github.com/rvm/rvm) + [NVM](https://github.com/creationix/nvm)

```
docker run --name ci --link db:db --link mysql:mysql -p 3000:3000 -e "GENERATE_ADMIN_USER"=true -e SERVER_NAME="..." -e SMTP_HOST="..." -e SMTP_USER="..." -e SMTP_PASS="..." rvm-strider
```
##Dependencies

This docker needs a running Mongodb instance (local/remote)
you can use dockerized version of [mongodb](https://registry.hub.docker.com/_/mongo/).

```
docker pull mongo
docker run --name db mongo
// then link the db docker to Strider
```


##Known bugs

the environment variable GENERATE_ADMIN_USER is not creating admin user. create a user manually on mongodb using any client.
