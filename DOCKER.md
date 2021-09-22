# Docker

## Quickstart

If you don’t know anything about Docker, this is how you set it up.

```bash
# install docker on a Debian system
sudo apt install docker.io
# add the current user to the docker group
sudo adduser $(whoami) docker
# if groups doesn’t show docker, you need to log in again
su - $(whoami)
```

## Running an old image you download from Docker Hub

This downloads an old image and runs it. It was probably built a long
time ago and you should *never ever* expose it to the Internet! Run it
at home, for your own enjoyment. 😅

```bash
docker run --publish=3000:3000 --publish=3010:3010 --publish=3020:3020 kensanata/hex-describe
```

## Building a new image

These instructions install three web applications in one image: Face
Generator, Text Mapper and Hex Describe.

There is a Dockerfile to build this in the repository. Check out the
repository, change into the working directory, and build a docker
image, tagging it `test/hex-describe`:

```bash
git clone https://alexschroeder.ch/cgit/hex-describe
cd hex-describe
docker build --tag test/hex-describe .
```

If you remove the `--notest` argument in the Dockerfile, this is a
good way to check for missing dependencies. 😁

## Running Face Generator, Text Mapper and Hex Describe

To start the container from this image and run all three web
applications:

```bash
docker run --publish=3000:3000 --publish=3010:3010 --publish=3020:3020 test/hex-describe
```

## Troubleshooting

To redo the image with new checkouts from git, you first have to prune
the stopped containers using it:

```bash
docker container prune
```

Then you can delete the image:

```bash
docker image rm test/hex-describe
```

To upload to Docker Hub:

```
ID=$(docker images | awk '/test\/hex-describe/ { print $3 }')
docker tag $ID kensanata/hex-describe:latest
docker login
docker push kensanata/hex-describe
```

Check it out
[on Docker Hub](https://hub.docker.com/r/kensanata/hex-describe).
