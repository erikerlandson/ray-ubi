# If you need these visible after the FROM, be sure to
# add duplicate ARG declarations _after_ the FROM
ARG PY_MAJOR
ARG PY_MINOR
ARG RAY_VERSION

FROM quay.io/erikerlandson/ray-ubi:py-${PY_MAJOR}.${PY_MINOR}-ray-${RAY_VERSION}

USER root:0

# The autoscaler needs the kubectl binary to talk to the kube cluster API
ENV OC_CLIENT_RELEASE=4.6.0-0.okd-2021-01-23-132511
RUN echo \
 && echo "download and install the kubectl static binary" \
 && cd /tmp \
 && wget -nv https://github.com/openshift/okd/releases/download/${OC_CLIENT_RELEASE}/openshift-client-linux-${OC_CLIENT_RELEASE}.tar.gz \
 && tar xzf openshift-client-linux-${OC_CLIENT_RELEASE}.tar.gz \
 && mv kubectl /usr/bin \
 && chmod a+rx /usr/bin/kubectl \
 && echo \
 && echo "clean up" \
 && rm -rf /tmp/* \
 && echo

# ray operator requires deps for autoscaler functionality
COPY ./requirements.txt /tmp/
RUN echo \
 && echo "installing ray operator python deps" \
 && cd /opt/ray \
 && pipenv install -r /tmp/requirements.txt \
 && rm -rf /tmp/* /root/.cache /root/.local \
 && chown -R 9998:0 /opt/ray \
 && chmod -R g+rwX /opt/ray

# emulate anonymous uid
USER 9999:0
