init: docker-down-clear \
	api-clear \
	docker-pull docker-build docker-up \
	api-init
up: docker-up
down: docker-down
restart: down up

check: lint analyze validate-schema test
lint: api-lint
analyze: api-analyze
validate-schema: api-validate-schema
test: api-test api-fixtures
test-unit: api-test-unit
test-functional: api-test-functional api-fixtures

update-deps: api-composer-update

docker-up:
	docker compose up -d

docker-down:
	docker compose down --remove-orphans

docker-down-clear:
	docker compose down -v --remove-orphans

docker-pull:
	docker compose pull

docker-build:
	docker compose build --pull

api-clear:
	docker run --rm -v ${PWD}:/app -w /app alpine sh -c 'rm -rf var/cache/* var/log/*'

api-init: api-composer-install api-wait-db api-migrations api-fixtures

api-composer-install:
	docker compose run --rm api-php-cli composer install

api-composer-update:
	docker compose run --rm api-php-cli composer update

api-wait-db:
	docker compose run --rm api-php-cli wait-for-it api-postgres:5432 -t 30

api-migrations:
	docker compose run --rm api-php-cli composer app doctrine:migrations:migrate -- --no-interaction

api-fixtures:
	docker compose run --rm api-php-cli composer app doctrine:fixtures:load -- --no-interaction

api-lint:
	docker compose run --rm api-php-cli composer lint
	docker compose run --rm api-php-cli composer php-cs-fixer fix -- --dry-run --diff

api-cs-fix:
	docker compose run --rm api-php-cli composer php-cs-fixer fix

api-analyze:
	docker-compose run --rm api-php-cli composer psalm -- --no-diff

api-analyze-diff:
	docker-compose run --rm api-php-cli composer psalm

api-validate-schema:
	docker compose run --rm api-php-cli composer app doctrine:schema:validate

api-test:
	docker compose run --rm api-php-cli composer test

api-test-coverage:
	docker compose run --rm api-php-cli composer test-coverage

api-test-unit:
	docker compose run --rm api-php-cli composer test -- --testsuite=unit

api-test-unit-coverage:
	docker compose run --rm api-php-cli composer test-coverage -- --testsuite=unit

api-test-functional:
	docker compose run --rm api-php-cli composer test -- --testsuite=functional

api-test-functional-coverage:
	docker compose run --rm api-php-cli composer test-coverage -- --testsuite=functional
