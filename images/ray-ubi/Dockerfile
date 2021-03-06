FROM registry.access.redhat.com/ubi8/ubi-minimal:8.4

ARG PY_MAJOR
ARG PY_MINOR

USER root:0

# Define an entrypoint that does proper signal handling
ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static /tini
RUN chmod a+rx /tini
ENTRYPOINT ["/tini", "--"]

WORKDIR /opt/ray

# environment for doing the pipenv install of the Pipfile
# WORKON_HOME tells pipenv to put the virtualenv in same dir so
# it gets properly used when container runs using anonymous uid
ENV LANG="C.UTF-8" \
    LC_ALL="C.UTF-8" \
    LC_CTYPE="C.UTF-8" \
    WORKON_HOME=/opt/ray \
    PIPENV_NOSPIN=1 \
    PIPENV_DEFAULT_PYTHON_VERSION=${PY_MAJOR}.${PY_MINOR} \
    PIPENV_NO_INHERIT=True

# Install requested python version (example: python36)
# on ubi-minimal, available python are currently 'python36' and 'python38'
# The upstream nightly Ray wheel appears to not support python 3.8, so
# practially speaking the only python supportable from both ubi-minimal
# and ray is python 3.6, unless I modify this to install python from some other
# source than micro-dnf
# 'which' is used by pipenv to locate a python interpreter to run
# 'procps-ng' provides the 'uptime' command, which is invoked remotely by the
# ray operator/autoscaler
RUN echo \
 && echo "installing OS package deps" \
 && microdnf install which procps-ng wget tar gzip python${PY_MAJOR}${PY_MINOR} python${PY_MAJOR}${PY_MINOR}-devel gcc gcc-c++ make cmake \
 && microdnf clean all \
 && echo \
 && echo "installing pipenv" \
 && pip3 install pipenv

# creating an empty `.bashrc` below, because ray currently has a
# hard-coded assumption that `$HOME/.bashrc` exists. I am not setting
# HOME in these docker-files to avoid confusion during image build,
# but you should set HOME=/opt in your container yaml during deployment
# see: https://github.com/ray-project/ray/issues/14155

# the requirements.txt is generated from a template before building this dockerfile
COPY ./requirements.txt /tmp/

RUN echo \
 && echo "installing the ray python environment" \
 && mkdir -p /opt/ray \
 && cd /opt/ray \
 && pipenv --python ${PY_MAJOR}.${PY_MINOR} install -r /tmp/requirements.txt \
 # after the install, deleting .cache, .local and /tmp saves space \
 && rm -rf /tmp/* /root/.cache /root/.local \
 && chown -R 9998:0 /opt/ray \
 && touch /opt/.bashrc \
 && chmod -R g+rwX /opt

# in the above, ray has been installed as a pipenv environment - if you want to run
# ray on this image, a way to do this is:
# $ cd /opt/ray
# $ . $(pipenv --venv)/bin/activate
# $ ray start ...

# to build images with additional dependencies installed:
# FROM <this image>
# RUN cd /opt/ray && pipenv install ...

CMD [ "echo", "No default command" ]

# Emulate an anonymous uid
USER 9999:0
