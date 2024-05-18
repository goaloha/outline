MAKEFLAGS := --print-directory
SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c

BINARY=outline

# for go dev
GOCMD=go
GORUN=$(GOCMD) run
GOBUILD=$(GOCMD) build
GOTEST=$(GOCMD) test
GODOC=$(GOCMD) doc
GOGET=$(GOCMD) get
GOMOD=$(GOCMD) mod

export CGO_ENABLED=0
export FLAGS="-s -w"

# commands
.PHONY: default run build install test bench doc clean artifact
default:
	@echo "build target is required for $(BINARY)"
	@exit 1

# basic commands
run:
	$(GORUN) . v
build:
	$(GOBUILD) -v -ldflags $(FLAGS) -trimpath -o $(BINARY)
install: build
	mv $(BINARY) $$GOPATH/bin
test:
	$(GOTEST) -race -cover -covermode=atomic -v -count 1 .
bench:
	$(GOTEST) -parallel=4 -run="none" -benchtime="5s" -benchmem -bench=.
doc:
	$(GODOC) -all ...
clean:
	rm -f $(BINARY)*

# for ci
artifact:
	test -n "$(OSEXT)"
	mkdir -p _upload
	cp -f $(BINARY) _upload/$(BINARY).$(OSEXT)
