IMAGE_NAME ?= virtualbox
IMAGE_VERSION ?= 5.2

XSOCK ?= /tmp/.X11-unix
XAUTH ?= /tmp/.docker.xauth

CUSTOM_BUILD_PARAMS ?= \
	--build-arg IMAGE_NAME=$(IMAGE_NAME) \
	--build-arg IMAGE_VERSION=$(IMAGE_VERSION)

COMMON_RUN_ARGS ?= \
	--name $(DOCKER_INSTANCE) \
	--cap-add=SYS_ADMIN \
	--env DISPLAY \
	--env XAUTHORITY=$(XAUTH) \
	--volume $(XSOCK):$(XSOCK) \
	--volume $(XAUTH):$(XAUTH)

define pre-run-step
	@touch $(XAUTH)
	@xauth nlist :0 | sed -e 's/^..../ffff/' | xauth -f $(XAUTH) nmerge -
endef

launch:
	@test -n "$$(docker inspect -f '{{.Created}}' $(IMAGE_TAG) 2>/dev/null)" || make build
	@docker inspect $(IMAGE_NAME) > /dev/null 2>&1 || make just-run
	@test $$(docker inspect -f '{{.State.Running}}' $(IMAGE_NAME) 2>/dev/null) = "true" || make start

include ../docker-common.mk
