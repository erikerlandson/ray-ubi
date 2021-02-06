FROM registry.access.redhat.com/ubi8/ubi-minimal:8.3

WORKDIR /opt/ray

COPY Pipfile /opt/ray/

# I'm using python 3.6 specifically, as it works broadly
# and the ODH spark-cluster images also use it.
# 'which' is used by pipenv to locate a python interpreter to run
RUN microdnf install python36 which \
 && microdnf clean all \
 && pip3 install pipenv

# environment for doing the pipenv install of the Pipfile
# WORKON_HOME tells pipenv to put the virtualenv in same dir so
# it gets properly used when container runs using anonymous uid
ENV LANG="C.UTF-8" \
    LC_ALL="C.UTF-8" \
    LC_CTYPE="C.UTF-8" \
    WORKON_HOME=/opt/ray \
    PIPENV_NOSPIN=1

# after the install, deleting .cache, .local and /tmp saves space
RUN cd /opt/ray \
 && pipenv --python 3.6 install \
 && rm -rf /tmp/* /root/.cache /root/.local \
 && chown -R 9998:0 /opt/ray \
 && chmod -R g+rwX /opt/ray

# Define an entrypoint that does proper signal handling
ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static /tini
RUN chmod a+rx /tini
ENTRYPOINT ["/tini", "--"]

CMD [ "echo", "No default command" ]

# Emulate an anonymous uid, similar to executing in an OpenShift environment
USER 9999:0
