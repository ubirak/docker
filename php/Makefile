TAG=$(PHP_VERSION)
TAGS_TO_PULL=$(TAG)-raw $(TAG)
include ../Makefile

APCUBC_VERSION?=
RAPHF_VERSION?=2.0.0
AMQP_VERSION?=1.9.3
AST_VERSION?=0.1.6
COMPOSER_VERSION?=1.6.2
PRESTISSIMO_VERSION?=0.3.7
PHP_URL?="https://secure.php.net/get/php-$(PHP_VERSION).tar.xz/from/this/mirror"
PHP_ASC_URL?="https://secure.php.net/get/php-$(PHP_VERSION).tar.xz.asc/from/this/mirror"

build:
	@docker build \
		--cache-from $(DOCKER_IMAGE_NAME):$(TAG)-raw \
		--build-arg PHP_VERSION=$(PHP_VERSION) \
		--build-arg PHP_URL=$(PHP_URL) \
		--build-arg PHP_ASC_URL=$(PHP_ASC_URL) \
		--build-arg PHP_SHA256=$(PHP_SHA256) \
		--build-arg GPG_KEY_LIST="$(GPG_KEY_LIST)" \
		--build-arg APCUBC_VERSION=$(APCUBC_VERSION) \
		--build-arg RAPHF_VERSION=$(RAPHF_VERSION) \
		--build-arg AMQP_VERSION=$(AMQP_VERSION) \
		--build-arg AST_VERSION=$(AST_VERSION) \
		--target raw \
		-t $(DOCKER_IMAGE_NAME):$(TAG)-raw .
	@docker build \
		--cache-from $(DOCKER_IMAGE_NAME):$(TAG)-raw \
		--build-arg PHP_VERSION=$(PHP_VERSION) \
		--build-arg PHP_URL=$(PHP_URL) \
		--build-arg PHP_ASC_URL=$(PHP_ASC_URL) \
		--build-arg PHP_SHA256=$(PHP_SHA256) \
		--build-arg GPG_KEY_LIST="$(GPG_KEY_LIST)" \
		--build-arg APCUBC_VERSION=$(APCUBC_VERSION) \
		--build-arg RAPHF_VERSION=$(RAPHF_VERSION) \
		--build-arg AMQP_VERSION=$(AMQP_VERSION) \
		--build-arg AST_VERSION=$(AST_VERSION) \
		--cache-from $(DOCKER_IMAGE_NAME):$(TAG) \
		--build-arg COMPOSER_VERSION=$(COMPOSER_VERSION) \
		--build-arg PRESTISSIMO_VERSION=$(PRESTISSIMO_VERSION) \
		--target refined \
		-t $(DOCKER_IMAGE_NAME):$(TAG) .

test:
	docker run --rm $(DOCKER_IMAGE_NAME):$(TAG) php --version
	docker run --rm $(DOCKER_IMAGE_NAME):$(TAG) php -m