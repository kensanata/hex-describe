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

## Building an image

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

To start the container from this image and run `hex-describe`:

```bash
docker run --publish=3000:3000 --publish=3010:3010 --publish=3020:3020 test/hex-describe \
  hex-describe daemon --listen "http://*:3000"
```

Find the container ID:

```
ID=$(docker ps | awk '/hex-describe/ { print $1 }')
```

And then, in a new shell, run `text-mapper` in the same container:

```bash
docker exec $ID text-mapper daemon --listen "http://*:3010"
```

And finally, in a new shell, run `face-generator` in the same
container:

```bash
docker exec $ID face-generator daemon --listen "http://*:3020"
```

This runs all three web applications in the same container and has
them listen on `http://127.0.0.1:3000`, `http://127.0.0.1:3010`, and
`http://127.0.0.1:3020` – and you can access the tree URLs from the
host, in other words, from your browser.

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
