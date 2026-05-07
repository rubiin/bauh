#!/bin/bash
set -Ceufox pipefail

docker build -t bauh-appimage .

docker_args=(
	-e "BAUH_VERSION=${BAUH_VERSION}"
	-e "APPIMAGE_EXTRACT_AND_RUN=1"
	-v ./AppImageBuilder.yml:/build/AppImageBuilder.yml
	--rm
	--mount type=bind,source="$(pwd)",target=/build
)

if [[ -e /dev/fuse ]]; then
	docker_args+=(--cap-add=SYS_ADMIN --device /dev/fuse)
fi

docker run "${docker_args[@]}" bauh-appimage
# to run AppImageBuilder tests from inside the container, also mount: -v /var/run/docker.sock:/var/run/docker.sock
