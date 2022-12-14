#!/bin/bash
set -e
DIR=$(cd $(dirname ${BASH_SOURCE})/.. ; pwd)

export NO_RELOAD=true
PRINT_INSTRUCTIONS=true

function usage() {
  echo "8888888888888888888888888888888888888888888888888888888888888888"
  echo "8"
  echo "8  $0 [options]"
  echo "8  -d DIR    path to serve [required]"
  echo "8  -p PORT   default PORT=8080"
  echo "8  -h        hot reload on localhost"
  echo "8  -r        enable hot reload"
  echo "8  -i IFACE  choose network interface"
  echo "8  -n        don't print these instructions"
  echo "8  -- ...    forwarded to serve"
  echo "8"
  echo "8888888888888888888888888888888888888888888888888888888888888888"
  echo
}

while [ ! -z "$1" ]; do
  case "$1" in
    -d) shift; SERVE=$(cd $1 && pwd); shift;;
    -p) shift; export PORT=$1; shift;;
    -r) export NO_RELOAD=false; shift;;
    -h) export USE_LOCALHOST=true; shift;;
    -i) shift; export NET_IFACE=$1; shift;;
    -n) PRINT_INSTRUCTIONS=""; shift;;
    --) break;;
    *) usage;;
  esac
done

if [ "${PRINT_INSTRUCTIONS}" ]; then
  usage
fi

if [ -z "${SERVE}" ]; then
  exit 2
fi

if [ ! -e "${DIR}/node_modules" ]; then
  echo "You must first npm install"
  exit 1
fi

cd ${DIR} && node serve/index.js ${SERVE} $@
