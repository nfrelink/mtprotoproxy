#!/bin/sh

set -e

INSTANCES="${INSTANCES:-1}"

case "$INSTANCES" in
    ''|*[!0-9]*)
        echo "INSTANCES must be a positive integer (got '$INSTANCES')" >&2
        exit 1
        ;;
esac

if [ "$INSTANCES" -lt 1 ]; then
    echo "INSTANCES must be at least 1 (got '$INSTANCES')" >&2
    exit 1
fi

if [ "$#" -eq 0 ]; then
    set -- python3 mtprotoproxy.py
fi

pids=""

terminate() {
    for pid in $pids; do
        if kill -0 "$pid" 2>/dev/null; then
            kill "$pid" 2>/dev/null || true
        fi
    done
}

trap 'terminate; exit 0' INT TERM

i=1
while [ "$i" -le "$INSTANCES" ]; do
    echo "Starting mtprotoproxy instance $i/$INSTANCES" >&2
    "$@" &
    pids="$pids $!"
    i=$((i + 1))
done

status=0
set +e
for pid in $pids; do
    wait "$pid"
    code=$?
    if [ "$status" -eq 0 ] && [ "$code" -ne 0 ]; then
        status=$code
    fi
done
exit "$status"

