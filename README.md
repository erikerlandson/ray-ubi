# ray-ubi
A minimalist Ray distributed computing container image, based on Red Hat UBI

This image can be found at:
https://quay.io/repository/erikerlandson/ray-ubi
```sh
$ docker pull quay.io/erikerlandson/ray-ubi`
```

The `ray-ubi` image uses pipenv for install of ray and enables easy addition of python deps.
To build an image with additional python packages:
```
FROM <this image>
RUN cd /opt/ray && pipenv install ...
```

To run `ray` from this image:
```sh
# go to the pipenv environment
$ cd /opt/ray
# activate the virtualenv for this directory
$ . $(pipenv --venv)/bin/activate
# now you have all the pipenv deps for ray
$ ray start ...
```
