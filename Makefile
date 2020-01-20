# Copyright (c) Mainflux
# SPDX-License-Identifier: Apache-2.0

BUILD_DIR = build
SERVICES = ws coap lora opcua
DOCKERS = $(addprefix docker_,$(SERVICES))
DOCKERS_DEV = $(addprefix docker_dev_,$(SERVICES))
CGO_ENABLED ?= 0
GOARCH ?= amd64

define compile_service
	CGO_ENABLED=$(CGO_ENABLED) GOOS=$(GOOS) GOARCH=$(GOARCH) GOARM=$(GOARM) go build -mod=vendor -ldflags "-s -w" -o ${BUILD_DIR}/mainflux-protocols-$(1) cmd/$(1)/main.go
endef

define make_docker
	$(eval svc=$(subst docker_,,$(1)))

	docker build \
		--no-cache \
		--build-arg SVC=$(svc) \
		--build-arg GOARCH=$(GOARCH) \
		--build-arg GOARM=$(GOARM) \
		--tag=mainflux/$(svc) \
		-f docker/Dockerfile .
endef

define make_docker_dev
	$(eval svc=$(subst docker_dev_,,$(1)))

	docker build \
		--no-cache \
		--build-arg SVC=$(svc) \
		--tag=mainflux/$(svc) \
		-f docker/Dockerfile.dev ./build
endef

all: $(SERVICES)

.PHONY: all $(SERVICES) dockers dockers_dev latest release

clean:
	rm -rf ${BUILD_DIR}

cleandocker:
	# Stop all containers (if running)
	docker-compose \	-f docker/lora-adapter/docker-compose.yml \
		-f docker/opcua-adapter/docker-compose.yml \
    	-f docker/coap-adapter/docker-compose.yml \
		-f docker/ws-adapter/docker-compose.yml stop
	
	# Remove mainflux-protocols containers
	docker ps -f name=mainflux -aq | xargs -r docker rm

	# Remove exited containers
	docker ps -f name=mainflux -f status=dead -f status=exited -aq | xargs -r docker rm -v

	# Remove unused images
	docker images "mainflux\/*" -f dangling=true -q | xargs -r docker rmi

	# Remove old mainflux images
	docker images -q mainflux\/* | xargs -r docker rmi

ifdef pv
	# Remove unused volumes
	docker volume ls -f name=mainflux -f dangling=true -q | xargs -r docker volume rm
endif

install:
	cp ${BUILD_DIR}/* $(GOBIN)

test:
	go test -mod=vendor -v -race -count 1 -tags test $(shell go list ./... | grep -v 'vendor\|cmd')


$(SERVICES):
	$(call compile_service,$(@))

$(DOCKERS):
	$(call make_docker,$(@),$(GOARCH))

$(DOCKERS_DEV):
	$(call make_docker_dev,$(@))

dockers: $(DOCKERS)

dockers_dev: $(DOCKERS_DEV)

changelog:
	git log $(shell git describe --tags --abbrev=0)..HEAD --pretty=format:"- %s"

latest: dockers
	$(call docker_push,latest)

release:
	$(eval version = $(shell git describe --abbrev=0 --tags))
	git checkout $(version)
	$(MAKE) dockers
	for svc in $(SERVICES); do \
		docker tag mainflux/$$svc mainflux/$$svc:$(version); \
	done
	$(call docker_push,$(version))

runall:
	docker-compose \
	 	-f docker/lora-adapter/docker-compose.yml \
		-f docker/opcua-adapter/docker-compose.yml \
    	-f docker/coap-adapter/docker-compose.yml \
		-f docker/ws-adapter/docker-compose.yml up \

runlora:
	docker-compose \
		-f docker/lora-adapter/docker-compose.yml up

runopcua:
	docker-compose \
		-f docker/opcua-adapter/docker-compose.yml up
runcoap:
	docker-compose \
		-f docker/coap-adapter/docker-compose.yml up

runws:
	docker-compose \
		-f docker/ws-adapter/docker-compose.yml up


