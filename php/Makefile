.PHONY: help pull build test tag images push

TARGETS:=$(MAKEFILE_LIST)
ITSELF:=$(lastword $(MAKEFILE_LIST))
MAKEFILE_PATH:=$(abspath $(lastword $(TARGETS)))
TAGS_TO_PUSH:=latest ${TAG}

help: ## This help
	@grep -E '^[a-z A-Z_-]+:.*?## .*$$' $(TARGETS) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

FQIN=karibbu/${IMAGE_NAME}:${TAG}
LATEST=karibbu/${IMAGE_NAME}:latest

pull: ## Pull docker image
	@docker pull ${LATEST} > /dev/null 2>&1 || echo "${FQIN} does not exist yet. Will build it."

build: ## Build docker image. Use f=true to force
	docker build \
		--cache-from ${LATEST} \
		--build-arg FROM_FQIN=${FROM_FQIN} \
		--build-arg COMPOSER_VERSION=${COMPOSER_VERSION} \
		--build-arg PRESTISSIMO_VERSION=${PRESTISSIMO_VERSION} \
		--build-arg APCUBC_VERSION=${APCUBC_VERSION} \
		--build-arg RAPHF_VERSION=${RAPHF_VERSION} \
		--build-arg AMQP_VERSION=${AMQP_VERSION} \
		-t ${FQIN} .

test: ## Test built docker image
	docker run --rm ${FQIN} php --version;
	docker run --rm ${FQIN} php -m;

tag: ## Make a tag alias latest to the built image
	@docker tag ${FQIN} ${LATEST}

images: ## List built images
	docker image ls karibbu/${IMAGE_NAME}

push: $(TAGS_TO_PUSH) ## Push built images

$(TAGS_TO_PUSH):
	docker push karibbu/${IMAGE_NAME}:$@