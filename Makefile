.PHONY: bootstrap test build

IMAGE := "tonyzhang/appimage-epics-tools:latest"

APP_NAME := "caget caput camonitor cainfo"
APP_NAME += "pvget pvput pvmonitor pvinfo"
APP_NAME += "softIoc softIocPVA"
# APP_NAME := ""

BASE_VERSION := 7.0.6.1
COMBINED := true

bootstrap:
	docker run --rm -it \
		--user $(shell id -u):$(shell id -g) \
		-v $(shell pwd):/appbuilder \
		-e ENV_APP_NAME="$(shell echo $(APP_NAME))" \
		-e ENV_COMBINED=$(COMBINED) \
		-e ENV_BASE_VERSION=$(BASE_VERSION) \
		-e ENV_PKG="" \
		$(IMAGE) /appbuilder/bootstrap.sh

build:
	docker build -t $(IMAGE) .

test:
	docker run --rm -it \
		--user $(shell id -u):$(shell id -g) \
		-v $(shell pwd):/appbuilder \
		$(IMAGE) bash
