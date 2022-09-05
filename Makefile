.PHONY: shell test help requirements

SHELL				   := /bin/bash

BASEDIR					= $(shell pwd)
-include ${BASEDIR}/.env

ENVIRONMENT			   ?= development

PROJECT					= ros

PROJDIR					= ${BASEDIR}
TESTDIR					= ${BASEDIR}/tests
DOCSDIR					= ${BASEDIR}/docs

DOCKER_COMPOSE		   ?= docker-compose

DOCKER_IMAGE		   ?= ${DOCKER_REGISTRY}/${DOCKER_USERNAME}/${PROJECT}
DOCKER_BUILDKIT		   ?= 1

JOBS				   ?= $(shell $(PYTHON) -c "import multiprocessing as mp; print(mp.cpu_count())")

NULL					= /dev/null

define log
	$(eval CLEAR     = \033[0m)
	$(eval BOLD		 = \033[0;1m)
	$(eval INFO	     = \033[0;36m)
	$(eval SUCCESS   = \033[0;32m)

	$(eval BULLET 	 = "→")
	$(eval TIMESTAMP = $(shell date +%H:%M:%S))

	@printf "${BULLET} ${$1}[${TIMESTAMP}]${CLEAR} ${BOLD}$2${CLEAR}\n"
endef

ifndef VERBOSE
.SILENT:
endif

.DEFAULT_GOAL 		   := help

clean: ## Clean cache, build and other auto-generated files.
ifneq (${ENVIRONMENT},test)
	@clear
	$(call log,SUCCESS,Cleaning Successful)
else
	$(call log,SUCCESS,Nothing to clean)
endif

docker-pull: ## Pull Latest Docker Images
	$(call log,INFO,Pulling latest Docker Image)

	if [[ -d "${BASEDIR}/docker/files" ]]; then \
		for folder in `ls ${BASEDIR}/docker/files`; do \
			docker pull $(DOCKER_IMAGE):$$folder || true; \
		done; \
	fi

	@docker pull $(DOCKER_IMAGE):latest || true

docker-build: clean docker-pull requirements ## Build the Docker Image.
	$(call log,INFO,Building Docker Image)

	if [[ -d "${BASEDIR}/docker/files" ]]; then \
		for folder in `ls ${BASEDIR}/docker/files`; do \
			docker build ${BASEDIR}/docker/files/$$folder --tag $(DOCKER_IMAGE):$$folder $(DOCKER_BUILD_ARGS) ; \
		done \
	fi

	@[[ -f "${BASEDIR}/Dockerfile" ]] && docker build $(BASEDIR) --tag $(DOCKER_IMAGE) $(DOCKER_BUILD_ARGS)
	
	if [[ -f "${BASEDIR}/docker-compose.yml" ]]; then \
		$(DOCKER_COMPOSE) build; \
	fi

docker-push: ## Push Docker Image to Registry.
	@docker push $(DOCKER_IMAGE) --all-tags

help: ## Show help and exit.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)