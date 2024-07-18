VERSION := $(shell cat VERSION)

.DEFAULT_GOAL := test

.PHONY: test
test:
	go test -count=1 $${TEST_ARGS}

.PHONY: testrace
testrace:
	go test -count=1 $${TEST_ARGS} -race

.PHONY: fmt
fmt:
	go fmt ./...

.PHONY: tag
tag:
	git tag -a $(VERSION) -m "Release $(VERSION)"
	git push --tags

.PHONY: release
release: tag
	git push origin main
