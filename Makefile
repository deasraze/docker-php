init: docker-down-clear \
	project-clear \
	docker-pull docker-build docker-up \
	project-init
up: docker-up
down: docker-down
restart: down up

update-deps: composer-update

docker-up:
	docker-compose up -d

docker-down:
	docker-compose down --remove-orphans

docker-down-clear:
	docker-compose down -v --remove-orphans

docker-pull:
	docker-compose pull

docker-build:
	docker-compose build --pull

project-clear:
	docker run --rm -v ${CURDIR}:/app -w /app alpine sh -c 'rm -rf var/cache/* var/log/*'

project-init: composer-install

composer-install:
	docker-compose run --rm php-cli composer install

composer-update:
	docker-compose run --rm php-cli composer update
