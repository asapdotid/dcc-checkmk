# Docker Compose Checkmk - Monitoring

As a monitoring software, Checkmk offers comprehensive and specialized solutions for dealing with the very diverse environments of IT infrastructures. This inevitably requires a very comprehensive documentation which goes beyond the mere description of the obvious. Our User Guide will help you as much as possible to better understand Checkmk, use Checkmk to implement your requirements, as well as helping you to discover new ways of solving problems

## Running Docker Compose (makefile)

Help

```bash
make help
```

Initial commands

| Commands    | Description                                                |
| ----------- | ---------------------------------------------------------- |
| `make init` | Initial environments for running make `.make/.env`         |
| `make env`  | Initial environments for running Docker compose `src/.env` |

> Update `Chekmk raw` version on file `.make/.env` </br>
> Update `Docker compose` environments `src/.env`

Docker Compose commands

| Commands       | Description            |
| -------------- | ---------------------- |
| `make up`      | Docker compose up      |
| `make down`    | Docker compose down    |
| `make restart` | Docker compose restart |
| `make config`  | Docker compose config  |
| `make logs`    | Docker compose logs    |
| `make ps`      | Docker compose ps      |

Utility commands

| Commands      | Description                                                   |
| ------------- | ------------------------------------------------------------- |
| `make omd`    | Running `omd` script in container with ARGS="status"          |
| `make passwd` | Running `cmk-passwd` script in container with USER="cmkadmin" |
| `make shell`  | Running shell script in container with ARGS="ls -al"          |

## License

MIT / BSD

## Author Information

This Docker Compose Checkmk was created in 2024 by [Asapdotid](https://github.com/asapdotid) 🚀
