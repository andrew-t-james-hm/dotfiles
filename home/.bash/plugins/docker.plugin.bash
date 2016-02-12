# 'Helpers to get Docker setup correctly for boot2docker'

# Note, this might need to be different if you have an older version
# of boot2docker, or its configured for a different IP
if [[ `uname -s` == "Darwin" ]]; then
  if [ -z "$DOCKER_HOST" ]; then
      export DOCKER_HOST=tcp://192.168.59.103:2375
  fi

  docker-enter() {
    boot2docker ssh '[ -f /var/lib/boot2docker/nsenter ] || docker run --rm -v /var/lib/boot2docker/:/target jpetazzo/nsenter'
    boot2docker ssh -t sudo "/var/lib/boot2docker/docker-enter \"$1\""
  }
fi

# about 'attempt to remove the most recent container from docker ps -a'
function docker-remove-most-recent-container() {
  docker ps -a | head -2 | tail -1 | awk '{print $NF}' | xargs docker rm
}

# about 'attempt to remove the most recent image from docker images'
function docker-remove-most-recent-image() {
  docker images | head -2 | tail -1 | awk '{print $3}' | xargs docker rmi
}
