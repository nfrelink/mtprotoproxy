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

WORKDIR /home/tgproxy/

COPY --chown=tgproxy . /home/tgproxy/
RUN test -f config.py

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

USER tgproxy

HEALTHCHECK --interval=30s --timeout=10s --retries=3 --start-period=10s \
  CMD python3 -c "import runpy, socket; config=runpy.run_module('config'); port=config.get('PORT', 443); s=socket.create_connection(('127.0.0.1', port), timeout=5); s.close()" || exit 1

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["python3", "mtprotoproxy.py"]
