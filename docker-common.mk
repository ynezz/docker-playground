IMAGE_VENDOR ?= true-systems
IMAGE_NAME ?= unknown
IMAGE_VERSION ?= latest
IMAGE_TAG ?= $(IMAGE_VENDOR)/$(IMAGE_NAME):$(IMAGE_VERSION)

DOCKER_INSTANCE ?= $(IMAGE_NAME)
DOCKER_CMD ?= docker
DOCKER_REGISTRY ?= docker.true-systems.cz
DOCKER_EXEC ?= $(DOCKER_CMD) exec -it $(DOCKER_INSTANCE)

COMMON_RUN_ARGS ?= --name $(DOCKER_INSTANCE)

.PHONY: build tag_latest push stop logs shell run run-debug

build:
ifdef pre-build-step
	$(call pre-build-step)
endif
	$(DOCKER_CMD) build $(CUSTOM_BUILD_PARAMS) -t $(IMAGE_TAG) .

tag_latest:
	$(DOCKER_CMD) tag -f $(IMAGE_TAG) $(IMAGE_VENDOR)/$(IMAGE_NAME):latest

push:
	$(DOCKER_CMD) push $(DOCKER_REGISTRY)/$(IMAGE_TAG)

stop:
	-$(DOCKER_CMD) stop --time=2 $(DOCKER_INSTANCE)
	-$(DOCKER_CMD) rm $(DOCKER_INSTANCE)

stop-no-delete:
	-$(DOCKER_CMD) stop $(DOCKER_INSTANCE)

logs:
	$(DOCKER_CMD) logs -f $(DOCKER_INSTANCE)

shell:
	$(DOCKER_EXEC) bash -l

start:
	$(DOCKER_CMD) start $(IMAGE_NAME)

just-run:
ifdef pre-run-step
	$(call pre-run-step)
endif
	$(DOCKER_CMD) run $(COMMON_RUN_ARGS) $(RUN_ARGS) -d -t $(IMAGE_TAG)

run:
	make stop
	make just-run

run-debug:
	make stop
	$(DOCKER_CMD) run $(COMMON_RUN_ARGS) $(RUN_DEBUG_ARGS) -i -t $(IMAGE_TAG)

service-install:
	sudo cp docker-host/docker-$(IMAGE_NAME).conf /etc/init/
	sudo initctl stop docker-$(IMAGE_NAME)
	sudo chown root.root /etc/init/docker-$(IMAGE_NAME).conf
	make build run stop-no-delete
	sudo initctl start docker-$(IMAGE_NAME)

prune-images:
	docker rmi $$(docker images -q -f dangling=true)
