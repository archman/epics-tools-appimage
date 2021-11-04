IMAGE := tonyzhang/xenial-appimage:latest

download:
	wget https://github.com/linuxdeploy/linuxdeploy/releases/download/continuous/linuxdeploy-x86_64.AppImage

build:
	docker build -t $(IMAGE) .

push:
	docker push $(IMAGE)
