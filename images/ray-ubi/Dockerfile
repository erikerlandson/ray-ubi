FROM registry.access.redhat.com/ubi8/ubi-minimal:8.3

WORKDIR /opt/ray

COPY Pipfile /opt/ray/

# environment for doing the pipenv install of the Pipfile
# WORKON_HOME tells pipenv to put the virtualenv in same dir so
# it gets properly used when container runs using anonymous uid
ENV LANG="C.UTF-8" \
    LC_ALL="C.UTF-8" \
    LC_CTYPE="C.UTF-8" \
    WORKON_HOME=/opt/ray \
    PIPENV_NOSPIN=1 \
    OC_CLIENT_RELEASE=4.6.0-0.okd-2021-01-23-132511

# I'm using python 3.6 specifically, as it works broadly
# and the ODH spark-cluster images also use it.
# 'which' is used by pipenv to locate a python interpreter to run
RUN microdnf install python36 which wget tar gzip \
 && microdnf clean all \
 && pip3 install pipenv \
 && echo \
 && echo "install the ray python environment" \
 && cd /opt/ray \
 && pipenv --python 3.6 install \
 # after the install, deleting .cache, .local and /tmp saves space \
 && rm -rf /tmp/* /root/.cache /root/.local \
 && chown -R 9998:0 /opt/ray \
 && chmod -R g+rwX /opt/ray \
 && echo \
 && echo "download and install the kubectl static binary" \
 && cd /tmp \
 && wget -nv https://github.com/openshift/okd/releases/download/${OC_CLIENT_RELEASE}/openshift-client-linux-${OC_CLIENT_RELEASE}.tar.gz \
 && tar xzf openshift-client-linux-${OC_CLIENT_RELEASE}.tar.gz \
 && mv kubectl /usr/bin \
 && chmod a+rx /usr/bin/kubectl \
 && rm -rf /tmp/* \
 && echo \
 && echo "clean up dnf packages" \
 && microdnf remove wget tar gzip \
 && microdnf clean all

# in the above, ray has been installed as a pipenv environment - if you want to run
# ray on this image, a way to do this is:
# $ cd /opt/ray
# $ . $(pipenv --venv)/bin/activate
# $ ray start ...

# to build images with additional dependencies installed:
# FROM <this image>
# RUN cd /opt/ray && pipenv install ...

# Define an entrypoint that does proper signal handling
ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static /tini
RUN chmod a+rx /tini
ENTRYPOINT ["/tini", "--"]

CMD [ "echo", "No default command" ]

# Emulate an anonymous uid, similar to executing in an OpenShift environment
USER 9999:0
