ARG PY_MAJOR
ARG PY_MINOR
ARG RAY_VERSION

FROM quay.io/erikerlandson/ray-ml-ubi:py-${PY_MAJOR}.${PY_MINOR}-ray-${RAY_VERSION}

USER root:0

# ray-pipeline has to be installed from local repo
COPY ./ray-pipeline/ /tmp/ray-pipeline/

# other python deps
COPY ./requirements.txt /tmp/

RUN echo \
 && echo "installing c/c++ toolchain" \
 && microdnf install gcc gcc-c++ make cmake \
 && echo \
 && echo "installing ML python libraries" \
 && cd /opt/ray \
 && pipenv install /tmp/ray-pipeline \
 && pipenv install -r /tmp/requirements.txt \
 && chown -R 9998:0 /opt/ray \
 && chmod -R g+rwX /opt/ray \
 && echo \
 && echo "clean up" \
 && rm -rf /tmp/* /root/.cache /root/.local \
 && microdnf remove gcc gcc-c++ make cmake-data cmake \
 && microdnf clean all

# emulate anonymous uid
USER 9999:0
