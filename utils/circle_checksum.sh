#!/bin/bash

set -euo pipefail

while getopts "v:gh" opt; do
  case "$opt" in
    "v") circle_version="$OPTARG";;
    "h") echo "Usage:"
       echo "-v - Version of circle to use"
       exit 2
       ;;
    "?") echo "invalid option: -$OPTARG"; exit 1;;
  esac
done

if ! [[ "${circle_version:-}" ]]; then
  echo "Usage: ${BASH_SOURCE[0]} -v circle_version"
  exit 1
fi

filename="build_${circle_version}.tgz"
url="https://www.circle-lang.org/linux/${filename}"
echo "Downloading circle version ${circle_version} to calculate the checksum"
checksum=$(curl -f -S ${url} | shasum -a 256 |  awk '{ print $1 }')
cat <<-OUTPUT
============================================================
 Append the below dictionary element to _circle_builds in
 toolchain/internal/circle_builds.bzl
------------------------------------------------------------

    "${circle_version}": struct(
        version = "${circle_version}",
        url = "${url}",
        sha256 = "${checksum}",
    )

============================================================
OUTPUT
