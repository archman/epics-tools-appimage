IMAGE := "tonyzhang/appimage-epics-tools:latest"
.PHONY: bootstrap test build

bootstrap:
	docker run --rm -it \
		--user $(shell id -u):$(shell id -g) \
		-v $(shell pwd):/appbuilder \
		$(IMAGE) /appbuilder/bootstrap.sh

build:
	docker build -t $(IMAGE) .

test:
	docker run --rm -it \
		--user $(shell id -u):$(shell id -g) \
		-v $(shell pwd):/appbuilder \
		$(IMAGE) bash
