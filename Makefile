# Change this to podman if you are on RHEL8+
DOCKER ?= docker
APPTAINER ?= apptainer
SHARED_DIR ?= ./shared
OVERLAY_DIR ?= ./overlay
MAX_THREADS ?= 16

UID := $(shell id -u)
GID := $(shell id -g)

.DEFAULT_GOAL := .docker_build

.docker_build: Dockerfile scripts/*
	"$(DOCKER)" build --build-arg "MAX_THREADS=$(MAX_THREADS)" -t p4iab .
	touch "$@"

p4iab.tar.gz: .docker_build
	"$(DOCKER)" save p4iab:latest | gzip > "$@"

p4iab.sif: p4iab.def .docker_build
	sudo "$(APPTAINER)" build "$@" "$<"
	sudo chown $(UID):$(GID) "$@"

run:
	@mkdir -p "$(SHARED_DIR)"
	@test -n "$(shell docker image ls -q p4iab)" \
		|| (echo Cannot find image p4iab:latest, has it been built yet? 1>&2 \
		&& false)
	@"$(DOCKER)" run --rm -it --privileged -v "$(SHARED_DIR):/home/p4/shared" \
		-e TERM -u p4 --entrypoint p4iab_docker_entry.sh p4iab:latest

app-run:
	@mkdir -p "$(SHARED_DIR)" "$(OVERLAY_DIR)"
	@test -e p4iab.sif \
		|| (echo Cannot find p4iab.sif, has it been built yet? 1>&2 \
		&& false)
	@lsmod | grep overlay > /dev/null || sudo modprobe overlay
	@sudo $(APPTAINER) run --allow-setuid --overlay "$(OVERLAY_DIR)" \
		-B "$(SHARED_DIR):/home/p4/shared" p4iab.sif

clean:
	"$(DOCKER)" container prune
	"$(DOCKER)" image prune -a
	rm -f .docker_build p4iab.tar.gz p4iab.sif

clean-data:
	sudo rm -rf $(OVERLAY_DIR) $(SHARED_DIR)

.PHONY: sc-run run clean clean-data
