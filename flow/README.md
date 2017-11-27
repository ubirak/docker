# flow

ubirak flow docker containers distributed on [docker hub](https://hub.docker.com/r/ubirak/flow/tags/).

It aims to follow [official node alpine flavour](https://hub.docker.com/_/node/) so you can use it in multi stage docker builds it should not break musl ABI.

# Troubleshooting

### If you experience some `Worked exited (code: 15) error on Linux host`

Then run the container like that:
```shell
docker run --rm -it -v $(pwd):/app -v /dev/shm:/dev/shm ubirak/flow:latest flow check
```

If it still don't work, try with tmpfs:
```shell
docker run --rm -it -v $(pwd):/app --tmpfs=/tmp ubirak/flow:latest flow check
```

