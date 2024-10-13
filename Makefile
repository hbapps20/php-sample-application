# Variables
COMPOSE=docker-compose

install-dev: composer.phar
	./composer.phar install
	ln --symbolic --no-dereference --force config-dev config

composer.phar:
	wget https://getcomposer.org/composer.phar
	chmod u+x composer.phar

# Construir los contenedores
build:
	$(COMPOSE) build

# Iniciar los contenedores
up:
	$(COMPOSE) up -d

# Detener los contenedores
down:
	$(COMPOSE) down

# Limpiar imágenes y contenedores
clean:
	$(COMPOSE) down --rmi all --volumes --remove-orphans
