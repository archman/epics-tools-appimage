.PHONY: bootstrap test pull wheel clean test-install

IMAGE := "tonyzhang/appimage-epics-tools:latest"

APP_NAME := "caget caput camonitor cainfo"
APP_NAME += "pvget pvput pvmonitor pvinfo"
APP_NAME += "softIoc softIocPVA"
APP_NAME += "caRepeater caConnTest caEventRate casw ca_test catime iocLogServer makeBpt msi p2p pvcall pvlist"
APP_NAME := "" # all ELFs

BASE_VERSION ?= 7.0.7
# COMBINED ?= true
COMBINED ?= false

bootstrap: pull
	docker run --rm -it \
		-v $(shell pwd):/appbuilder \
		-e ENV_APP_NAME="$(shell echo $(APP_NAME))" \
		-e ENV_COMBINED=$(COMBINED) \
		-e ENV_BASE_VERSION=$(BASE_VERSION) \
		-e ENV_PKG="" \
		$(IMAGE) /appbuilder/bootstrap.sh

test: pull
	docker run --rm -it \
		-v $(shell pwd):/appbuilder \
		$(IMAGE) bash

pull:
	docker pull $(IMAGE)

wheel: clean
	python3 setup.py bdist_wheel

clean:
	/bin/rm -rf build dist

test-install:
	pip install dist/*.whl --user --upgrade --force-reinstall
	caget
