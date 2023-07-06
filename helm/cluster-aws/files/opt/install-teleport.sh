#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail

command -v teleport && exit 0

TELEPORT_VERISON="13.1.5"
TELEPORT_TARBALL="teleport-v${TELEPORT_VERISON}-linux-amd64-bin.tar.gz"

cd /opt
wget https://cdn.teleport.dev/${TELEPORT_TARBALL}
echo "Extracting $TELEPORT_TARBALL"
tar zxf $TELEPORT_TARBALL
sudo mv teleport/teleport /opt/bin/teleport
rm -vfr teleport ${TELEPORT_TARBALL}
