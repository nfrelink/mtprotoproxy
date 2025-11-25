# Async MTProto Proxy #

Fast and simple to setup MTProto proxy written in Python.

## Starting Up ##
    
1. `git clone -b stable https://github.com/nfrelink/mtprotoproxy.git; cd mtprotoproxy`
2. `cp config.py.example config.py` and edit **PORT**, **USERS** and optionally an **AD_TAG**
3. *(Docker users)* `cp docker-compose.yml.example docker-compose.yml` and tweak the ports/mounts as needed
4. *(Bare-metal users)* `pip install --no-cache-dir -r requirements.txt`
5. `docker-compose up -d` (or just `python3 mtprotoproxy.py` if you don't like Docker)
6. *(optional, get a link to share the proxy)* `docker-compose logs`

![Demo](https://alexbers.com/mtprotoproxy/install_demo_v2.gif)

## Channel Advertising ##

To advertise a channel get a tag from **@MTProxybot** and put it to *config.py*.

## Performance ##

The proxy performance should be enough to comfortably serve about 4 000 simultaneous users on
the VDS instance with 1 CPU core and 1024MB RAM.

## More Instructions ##

- [Running without Docker](https://github.com/nfrelink/mtprotoproxy/wiki/Running-Without-Docker)
- [Optimization and fine tuning](https://github.com/nfrelink/mtprotoproxy/wiki/Optimization-and-Fine-Tuning)

## Advanced Usage ##

The proxy can be launched:
- with a custom config: `python3 mtprotoproxy.py [configfile]`
- several times, clients will be automaticaly balanced between instances
- with uvloop module to get an extra speed boost
- with runtime statistics exported to [Prometheus](https://prometheus.io/)
