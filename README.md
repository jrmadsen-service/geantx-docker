# geantx-docker

GeantX Docker generation.

This repo is still under development!

## Repository Components

- TODO: add info

## Building

```bash
docker-compose up --no-start --build
```

## Enabling visualization

Add these functions to your `~/.bashrc` (Linux) or `~/.bash_profile` (macOS):

```bash
get-local-ip-address ()
{
    local LOCAL_IP="127.0.0.1";
    if [ "$(uname)" = "Darwin" ]; then
        LOCAL_IP=$(ipconfig getifaddr `route get nersc.gov | grep 'interface:' | awk '{print $NF}'`);
    else
        LOCAL_IP=$(ip route ls | tail -n 1 | awk '{print $NF}');
    fi;
    echo ${LOCAL_IP}
}

docker-x11 ()
{
    #
    # mounting:
    #       ${HOME}:/home/user
    # provides:
    #       ${HOME}/.Xauthority @ /root/.Xauthority
    # NOTE:
    #   this will enable editing of home directory within container
    #   that will commonly produce files owned by root so use with
    #   caution
    #

    # on macOS, be sure to XQuartz is open before executing
    if [ "$(uname)" = "Darwin" ]; then open -a XQuartz; fi

    local _IP_ADDR="$(get-local-ip-address)"
    local _DISPLAY="$(echo $DISPLAY | cut -d ':' -f 2)"
    echo "IP: ${_IP_ADDR}"
    echo "DISPLAY: ${_DISPLAY}"
    docker run -it --rm -v ${HOME}:/home/user \
        -v ${HOME}/.Xauthority:/root/.Xauthority:rw \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -e DISPLAY="${_IP_ADDR}:${_DISPLAY}" \
        --net=host \
        $@
}
```

Launch the container:

```bash
docker-x11 ${ADDITIONAL_ARGUMENTS} geantx/geant4 /bin/bash -l
docker-x11 ${ADDITIONAL_ARGUMENTS} geantx/geantv /bin/bash -l
docker-x11 ${ADDITIONAL_ARGUMENTS} geantx/geantx /bin/bash -l
```
