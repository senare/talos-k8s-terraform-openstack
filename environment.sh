#!/bin/bash

IMAGE='tooling:0.0.0-1'

docker pull ${IMAGE}

if ! docker inspect --type=image ${IMAGE} 1> /dev/null; then
  pushd tooling || exit
  docker build . -t ${IMAGE}
  popd
fi

docker run -it --rm \
  -v ${PWD}/overlays:/home/overlays \
  -v ${PWD}/live:/home/live \
  -v ${PWD}/modules:/home/modules \
  -v ${PWD}/secrets:/home/secrets \
  -v ${PWD}/target:/home/target \
  ${IMAGE}
