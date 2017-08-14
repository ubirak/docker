TAG=$(FLOW_VERSION)
TAGS_TO_PULL=$(TAG)
include ../Makefile

build:
	docker build \
		--cache-from $(DOCKER_IMAGE_NAME):$(TAG) \
		--build-arg FLOW_VERSION=${FLOW_VERSION} \
		--build-arg OCAML_VERSION=${OCAML_VERSION} \
		-t $(DOCKER_IMAGE_NAME):$(TAG) .

test:
	docker run --rm $(DOCKER_IMAGE_NAME):$(TAG) flow version;