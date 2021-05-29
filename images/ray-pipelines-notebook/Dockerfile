ARG PY_MAJOR
ARG PY_MINOR
ARG RAY_VERSION

#FROM quay.io/erikerlandson/ray-ml-notebook:py-${PY_MAJOR}.${PY_MINOR}-ray-${RAY_VERSION}
FROM quay.io/thoth-station/s2i-minimal-py38-notebook:v0.0.14

#USER default:0

# ray-pipeline has to be installed from local repo
COPY ./ray-pipeline/ /tmp/ray-pipeline/

# other python deps
COPY ./requirements.txt /tmp/

RUN /opt/app-root/bin/pip3 install -r /tmp/requirements.txt
RUN /opt/app-root/bin/pip3 install /tmp/ray-pipeline
