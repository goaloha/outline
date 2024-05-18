MAKEFLAGS := --print-directory
SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c

BINARY := outline

export CGO_ENABLED=0
export FLAGS="-s -w"

.PHONY: default run build install test bench doc clean artifact

default:
	@echo "build target is required for $(BINARY)"
	@exit 1

run:
	go run . -v

build:
	go build -v -ldflags $(FLAGS) -trimpath -o $(BINARY)

install: build
	install -m 0755 $(BINARY) $(GOPATH)/bin

test:
	go test -race -cover -covermode=atomic -v -count 1 .

bench:
	go test -parallel=4 -run="none" -benchtime="5s" -benchmem -bench=.

doc:
	go doc -all ...

clean:
	rm -f $(BINARY)*

artifact:
	test -n "$(OSEXT)"
	mkdir -p _upload
	cp -f $(BINARY) _upload/$(BINARY).$(OSEXT)
