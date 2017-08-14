TAG=$(RABBITMQ_VERSION)
TAGS_TO_PULL=$(TAG)
FROM_FQIN=rabbitmq:$(RABBITMQ_VERSION)-alpine
include ../Makefile

build:
	docker build \
		--cache-from $(DOCKER_IMAGE_NAME):$(TAG) \
		--build-arg FROM_FQIN=$(FROM_FQIN) \
		-t $(DOCKER_IMAGE_NAME):$(TAG) .

test: