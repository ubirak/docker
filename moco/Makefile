TAG=latest
TAGS_TO_PULL=$(TAG)
include ../Makefile

build:
	@docker build \
		--cache-from $(DOCKER_IMAGE_NAME):$(TAG) \
		-t $(DOCKER_IMAGE_NAME):$(TAG) .

test:
	docker run --rm $(DOCKER_IMAGE_NAME):$(TAG) moco help