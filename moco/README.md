# moco

ubirak moco docker containers distributed on [docker hub](https://hub.docker.com/r/ubirak/moco/tags/).

## How to run it?

```shell
$ docker run -v /my/own/moco-directory:/var/moco -p 8000:8000 ubirak/moco:latest
```

**Important:** your moco directory must contain a [moco.json](https://github.com/dreamhead/moco/blob/master/moco-doc/apis.md) file.

