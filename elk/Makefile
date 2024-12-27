# Variables
DOCKER_COMPOSE = docker-compose
DOCKER_COMPOSE_STACK_FILE = docker-stack.yml
DOCKER_COMPOSE_FILEBEAT_FILE = docker-filebeat.yml

# Targets
.PHONY: up start restart stop down logs check-elk-up fb-up fb-start fb-restart fb-stop fb-down fb-logs stop-all

up:
	$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_STACK_FILE) up -d

start:
	$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_STACK_FILE) start

restart:
	$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_STACK_FILE) restart

stop:
	$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_STACK_FILE) stop

down:
	$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_STACK_FILE) down

logs:
	$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_STACK_FILE) logs -f

# 需要确保 elk 这三个容器已经完全启动
# 这里我需要确定 elasticsearch、kibana、logstash 这三个容器已经完全启动，如果没有完全启动，那么我直接会终止后续的操作
check-elk-up:
	@echo "确保 ELK 容器已经完全启动"
	@if [ $$($(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_STACK_FILE) ps | grep -E "elasticsearch|kibana|logstash" | grep "Up" | wc -l) -ne 3 ]; then echo "\033[31mNot all services are up. \033[0m"; exit 1; else echo "\033[32mELK Running!\033[0m"; fi

fb-up:
	@make check-elk-up
	@echo "开始启动 Filebeat"
	$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILEBEAT_FILE) up -d

fb-start:
	@make check-elk-up
	@echo "开始启动 Filebeat"
	$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILEBEAT_FILE) start

fb-restart:
	@make check-elk-up
	@echo "开始重启 Filebeat"
	$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILEBEAT_FILE) restart

fb-stop:
	@echo "开始停止 Filebeat"
	$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILEBEAT_FILE) stop

fb-down:
	@echo "开始停止 Filebeat"
	$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILEBEAT_FILE) down

fb-logs:
	$(DOCKER_COMPOSE) -f $(DOCKER_COMPOSE_FILEBEAT_FILE) logs -f

stop-all:
	make stop
	make fb-stop