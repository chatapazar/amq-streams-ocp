PROJECT_NAME=java-http-producer

all: java_build docker_build docker_push
build: java_build
clean: java_clean

include ../../../Makefile.docker

include ../../../Makefile.maven

.PHONY: build clean