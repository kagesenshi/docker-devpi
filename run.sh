#!/bin/bash
set -e
set -x
export DEVPISERVER_SERVERDIR=/mnt
export DEVPI_CLIENTDIR=/tmp/devpi-client
[[ -f $DEVPISERVER_SERVERDIR/.serverversion ]] || initialize=yes

if [ "${OUTSIDE_URL}x" == "x" ];then
    echo "OUTSIDE_URL environment is required"
    exit 2
fi

kill_devpi() {
    test -n "$DEVPI_PID" && kill $DEVPI_PID
}
trap kill_devpi EXIT

# For some reason, killing tail during EXIT trap function triggers an
# "uninitialized stack frame" bug in glibc, so kill tail when handling INT or
# TERM signal.
kill_tail() {
    test -n "$TAIL_PID" && kill $TAIL_PID
}
trap kill_tail INT
trap kill_tail TERM

if [[ $initialize = yes ]]; then
  devpi-init --root-passwd ${DEVPI_PASSWORD}
  devpi-gen-secret --secretfile /mnt/.devpi-secret
fi

devpi-server --host 0.0.0.0 --port 3141 --secretfile /mnt/.devpi-secret --outside-url $OUTSIDE_URL 
