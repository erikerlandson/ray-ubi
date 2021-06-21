# If you need these visible after the FROM, be sure to
# add duplicate ARG declarations _after_ the FROM
ARG PY_MAJOR
ARG PY_MINOR
ARG RAY_VERSION

FROM quay.io/erikerlandson/ray-ubi:py-${PY_MAJOR}.${PY_MINOR}-ray-${RAY_VERSION}

USER root:0

COPY ./requirements.txt /tmp/
ENV HOROVOD_WITH_GLOO=1

RUN echo \
 && echo "installing ML python libraries" \
 && cd /opt/ray \
 && pipenv install -r /tmp/requirements.txt \
 && chown -R 9998:0 /opt/ray \
 && chmod -R g+rwX /opt/ray \
 && echo \
 && echo "clean up" \
 && rm -rf /tmp/* /root/.cache /root/.local \
 && echo

# emulate anonymous uid
USER 9999:0
