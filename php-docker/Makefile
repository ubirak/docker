TAG=$(PHP_VERSION)-$(DOCKER_CONTAINER_VERSION)
TAGS_TO_PULL=$(TAG)
include ../Makefile

build:
	@docker build \
		--cache-from $(DOCKER_IMAGE_NAME):$(TAG) \
		--build-arg PHP_VERSION=$(PHP_VERSION) \
		--build-arg DOCKER_VERSION=$(DOCKER_CONTAINER_VERSION) \
		-t $(DOCKER_IMAGE_NAME):$(TAG) .

test:
	docker run --rm $(DOCKER_IMAGE_NAME):$(TAG) php --version
	docker run --rm $(DOCKER_IMAGE_NAME):$(TAG) docker --version
	docker run --user root --rm -v /var/run/docker.sock:/var/run/docker.sock $(DOCKER_IMAGE_NAME):$(TAG) docker image ls
