DATA_DIRS = mariadb wordpress
_CREATE_DATA_DIRS = $(DATA_DIRS:%=create-%)
_DELETE_DATA_DIRS = $(DATA_DIRS:%=delete-%)

DOCKER_COMPOSE = docker-compose -f srcs/docker-compose.yml

up: $(_CREATE_DATA_DIRS)
	$(DOCKER_COMPOSE) up --build -d

create-%:
	mkdir -p /home/tdelage/data/$*

delete-%:
	sudo rm -rf /home/tdelage/data/$*

down:
	$(DOCKER_COMPOSE) down

clean: down $(_DELETE_DATA_DIRS)
	docker stop $$(docker ps -qa); \
	docker rm $$(docker ps -qa); \
	docker rmi -f $$(docker images -qa); \
	docker volume rm $$(docker volume ls -q); \
	docker network rm $$(docker network ls -q) || true

re: clean up


.PHONY: up down cleanup re create-% delete-%
