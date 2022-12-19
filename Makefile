VERSION := 0.0.1
DOCKER = docker
WHO ?= jmmisd
IMG_BASENAME = jenkinstest
LOCAL_IMG := $(WHO)/$(IMG_BASENAME)
IMG_TAG ?= $(VERSION)
LOCAL_REGISTRY = localhost:5000


.PHONY: all
all: image push-local-reg

.PHONY: image
image:
	$(DOCKER) build --no-cache -f ./Dockerfile \
		--build-arg VERSION=$(VERSION) -t $(LOCAL_IMG):$(IMG_TAG) .
	$(DOCKER) image prune --force --filter label=stage=builder

.PHONY: push-local-reg
push-local-reg:
	$(DOCKER) tag $(LOCAL_IMG):$(IMG_TAG) \
		$(LOCAL_REGISTRY)/$(IMG_BASENAME):$(IMG_TAG)
	$(DOCKER) push $(LOCAL_REGISTRY)/$(IMG_BASENAME):$(IMG_TAG)
	
.PHONY: clean-image clean-local clean
clean: clean-local clean-image
clean-local:
	-$(RM) -v $(BIN)
clean-image:
	-$(DOCKER) rmi $(LOCAL_IMG):$(IMG_TAG)
