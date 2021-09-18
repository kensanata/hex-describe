## Docker

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

### Running the latest Text Mapper and Hex Describe

Remember, you probably want both applications. Therefore, first follow
the instructions for a Text Mapper Docker image. Check whether it
worked:

```bash
docker images
```

You should see the image `test/text-mapper` in the list:

```text
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
test/text-mapper    latest              a080e575bd83        2 hours ago         876MB
perl                latest              4307319f1e3e        4 weeks ago         860MB
```

The Hex Describe image we’re going to build depends on it.

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

To start the container from this image and run `hex-describe`:

```bash
docker run --publish=3000:3000 --publish=3010:3010 test/hex-describe \
  hex-describe daemon --listen "http://*:3000"
```

Find the container ID:

```
ID=$(docker ps | awk '/hex-describe/ { print $1 }')
```

And then to also run `text-mapper` in the same container:

```bash
docker exec $ID text-mapper daemon --listen "http://*:3010"
```

This runs both web applications in the same container and has it
listen on both `http://127.0.0.1:3000` and `http://127.0.0.1:3010` –
and you can access both URLs from the host.

## Troubleshooting

To redo the image, you first have to prune the stopped containers
using it.

```bash
docker container prune
```

Then you can delete the image:

```bash
docker image rm test/hex-describe
```

