IMAGE = quay.io/swade1987/jenkins
SNAP_PIPELINE_COUNTER?="unknown"

QUAY_USERNAME=swade1987
QUAY_EMAIL=steven@stevenwade.co.uk
QUAY_PASSWORD?="unknown"

# Construct the image tag.
VERSION=0.1.$(SNAP_PIPELINE_COUNTER)

build-local:
	docker build -t swade_jenkins .

run-local:
	docker run -d --name swade_jenkins -p 8080:8080 -p 50000:50000 swade_jenkins

delete-local:
	docker rm -f swade_jenkins
	docker rmi swade_jenkins

build:
	docker build -t $(IMAGE):$(VERSION) .

login:
	docker login -e $(QUAY_EMAIL) -u $(QUAY_USERNAME) -p $(QUAY_PASSWORD) quay.io

push:
	docker push $(IMAGE):$(VERSION)
	docker rmi $(IMAGE):$(VERSION)