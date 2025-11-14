FROM ubuntu:24.04

RUN apt-get update && apt-get install --no-install-recommends -y \
    python3 \
    python3-uvloop \
    python3-cryptography \
    python3-socks \
    libcap2-bin \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && setcap -r /usr/bin/python3.12 2>/dev/null || true \
    && setcap cap_net_bind_service=+ep /usr/bin/python3.12 \
    && useradd tgproxy -u 10000

USER tgproxy

WORKDIR /home/tgproxy/

COPY --chown=tgproxy mtprotoproxy.py config.py /home/tgproxy/

HEALTHCHECK --interval=30s --timeout=10s --retries=3 --start-period=10s \
  CMD python3 -c "import runpy, socket; config=runpy.run_module('config'); port=config.get('PORT', 443); s=socket.socket(); s.bind(('127.0.0.1', port)); s.close()" || exit 1

CMD ["python3", "mtprotoproxy.py"]
