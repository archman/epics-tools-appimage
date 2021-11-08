.PHONY: test build

IMAGE := "tonyzhang/appimage-epics-tools:latest"

build:
	docker build -t $(IMAGE) .

test:
	docker run --rm -it \
		--user $(shell id -u):$(shell id -g) \
		-v $(shell pwd):/appbuilder \
		$(IMAGE) bash
