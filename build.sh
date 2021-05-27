#!/bin/bash
set -x -e

# usage: build.sh <py-major> <py-minor> <full-ray-sha> <image-registry>
# example:
# ./build.sh 3 6 ea6bdfb9c1cc94492c117086913b18f821a3557a quay.io/erikerlandson

# eventually will replace ray sha with actual version when 2.x releases

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
export RAY_SHA_FULL=$3
export REGISTRY=$4

# eventually this will be actual version, like 2.0.0
export RAY_VERSION=${RAY_SHA_FULL:0:8}

# ray cares about keeping major+minor python aligned so it is important to tag it that way
export RAY_UBI_TAG="py-${PY_MAJOR}.${PY_MINOR}-ray-${RAY_VERSION}"

# base image currently has to install ray from nightly wheel which uses SHA
cat images/ray-ubi/requirements.txt.template | sed s/RAY_SHA_FULL/${RAY_SHA_FULL}/ > images/ray-ubi/requirements.txt
podman build --no-cache -t ${REGISTRY}/ray-ubi:${RAY_UBI_TAG} \
       --build-arg PY_MAJOR=${PY_MAJOR} --build-arg PY_MINOR=${PY_MINOR} \
       --build-arg RAY_SHA_FULL=${RAY_SHA_FULL} \
       ./images/ray-ubi

podman build --no-cache -t ${REGISTRY}/ray-operator-ubi:${RAY_UBI_TAG} \
       --build-arg PY_MAJOR=${PY_MAJOR} --build-arg PY_MINOR=${PY_MINOR} \
       --build-arg RAY_VERSION=${RAY_VERSION} \
       ./images/ray-operator-ubi

podman build --no-cache -t ${REGISTRY}/ray-ml-ubi:${RAY_UBI_TAG} \
       --build-arg PY_MAJOR=${PY_MAJOR} --build-arg PY_MINOR=${PY_MINOR} \
       --build-arg RAY_VERSION=${RAY_VERSION} \
       ./images/ray-ml-ubi

# ray-pipeline has to be installed from local repo
cp -rf /home/eje/git/ray-pipeline ./images/ray-pipelines-ubi/
podman build --no-cache -t ${REGISTRY}/ray-pipelines-ubi:${RAY_UBI_TAG} \
       --build-arg PY_MAJOR=${PY_MAJOR} --build-arg PY_MINOR=${PY_MINOR} \
       --build-arg RAY_VERSION=${RAY_VERSION} \
       ./images/ray-pipelines-ubi
