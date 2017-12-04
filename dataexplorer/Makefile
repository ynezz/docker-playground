IMAGE_NAME ?= dataexplorer
IMAGE_VERSION ?= 3.3.1
TARBALL ?= dataexplorer-$(IMAGE_VERSION)-bin_GNULinux_x86_64.tar.gz

XSOCK ?= /tmp/.X11-unix
XAUTH ?= /tmp/.docker.xauth

CUSTOM_BUILD_PARAMS ?= \
	--build-arg USER_UID=$(shell id --user) \
	--build-arg USER_GID=$(shell id --group) \
	--build-arg IMAGE_VERSION=$(IMAGE_VERSION)

COMMON_RUN_ARGS ?= \
	--name $(DOCKER_INSTANCE) \
	--cap-add=SYS_ADMIN \
	--env DISPLAY \
	--env XAUTHORITY=$(XAUTH) \
	--volume $(XSOCK):$(XSOCK) \
	--volume $(XAUTH):$(XAUTH) \
	--device=/dev/bus/usb:/dev/bus/usb:rwm

define pre-run-step
	@touch $(XAUTH)
	@xauth nlist :0 | sed -e 's/^..../ffff/' | xauth -f $(XAUTH) nmerge -
endef

define pre-build-step
	make $(TARBALL)
endef

launch:
	@test -n "$$(docker inspect -f '{{.Created}}' $(IMAGE_TAG) 2>/dev/null)" || make build
	@docker inspect $(IMAGE_NAME) > /dev/null 2>&1 || make just-run
	@test $$(docker inspect -f '{{.State.Running}}' $(IMAGE_NAME) 2>/dev/null) = "true" || make start

$(TARBALL):
	wget http://download.savannah.nongnu.org/releases/dataexplorer/$@

include ../docker-common.mk
