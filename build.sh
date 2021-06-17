#!/bin/bash
set -x -e

# usage: build.sh <py-major> <py-minor> <ray-version> <image-registry>
# example:
# ./build.sh 3 6 1.4.0 quay.io/erikerlandson

# intended to be run from top of the repo, for example:
# cd /path/to/ray-ubi
# ./build.sh

# Note: if desired you should be able to replace 'podman' with 'docker'
# as a drop-in replacement

# On ubi-minimal, available python are currently 'python36' and 'python38'
# The upstream nightly Ray wheel appears to not support python 3.8, so
# practially speaking the only python supportable from both ubi-minimal
# and ray is python 3.6, unless I modify the docker-file to install python
# from some other source than micro-dnf

# command line args
export PY_MAJOR=$1
export PY_MINOR=$2
export RAY_VERSION=$3
export REGISTRY=$4

# ray cares about keeping major+minor python aligned so it is important to tag it that way
export RAY_UBI_TAG="py-${PY_MAJOR}.${PY_MINOR}-ray-${RAY_VERSION}"

cat images/ray-ml-notebook/requirements.txt.template | sed s/RAY_VERSION/${RAY_VERSION}/ > images/ray-ml-notebook/requirements.txt
podman build --no-cache -t ${REGISTRY}/ray-ml-notebook:${RAY_UBI_TAG} \
       --build-arg PY_MAJOR=${PY_MAJOR} --build-arg PY_MINOR=${PY_MINOR} \
       ./images/ray-ml-notebook

cat images/ray-ubi/requirements.txt.template | sed s/RAY_VERSION/${RAY_VERSION}/ > images/ray-ubi/requirements.txt
podman build --no-cache -t ${REGISTRY}/ray-ubi:${RAY_UBI_TAG} \
       --build-arg PY_MAJOR=${PY_MAJOR} --build-arg PY_MINOR=${PY_MINOR} \
       ./images/ray-ubi

podman build --no-cache -t ${REGISTRY}/ray-operator-ubi:${RAY_UBI_TAG} \
       --build-arg PY_MAJOR=${PY_MAJOR} --build-arg PY_MINOR=${PY_MINOR} \
       --build-arg RAY_VERSION=${RAY_VERSION} \
       ./images/ray-operator-ubi

podman build --no-cache -t ${REGISTRY}/ray-ml-ubi:${RAY_UBI_TAG} \
       --build-arg PY_MAJOR=${PY_MAJOR} --build-arg PY_MINOR=${PY_MINOR} \
       --build-arg RAY_VERSION=${RAY_VERSION} \
       ./images/ray-ml-ubi
