include ../Makefile

build:
	docker build --cache-from $(DOCKER_IMAGE_NAME):$(TAG) -t $(DOCKER_IMAGE_NAME):$(TAG) .

test: