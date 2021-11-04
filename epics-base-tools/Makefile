IMAGE := "tonyzhang/xenial-appimage:latest"
.PHONY: bootstrap test

bootstrap:
	docker run --rm -it \
		--user $(shell id -u):$(shell id -g) \
		-v $(shell pwd):/appbuilder \
		$(IMAGE) /appbuilder/bootstrap.sh

test:
	docker run --rm -it \
		--user $(shell id -u):$(shell id -g) \
		-v $(shell pwd):/appbuilder \
		$(IMAGE) bash
