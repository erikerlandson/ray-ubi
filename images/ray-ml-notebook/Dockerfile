ARG PY_MAJOR
ARG PY_MINOR

# this is my mirror of thoth nb image builds, named consistently for easy automation
# will fail for any image with a python version I haven't mirrored
# currently, the only odh notebook python that ray-pipeline works with is py38
# python < 3.7 is known to NOT work due to ray-pipeline dep on SimpleQueue
FROM quay.io/erikerlandson/odh-jupyter:py${PY_MAJOR}${PY_MINOR}

# other python deps
COPY ./requirements.txt /tmp/

RUN /opt/app-root/bin/pip3 install -r /tmp/requirements.txt
