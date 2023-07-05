#!/bin/bash

command -v teleport && exit 0

cd /opt
echo "Extracting $TELEPORT_TARBALL"
tar zxf $TELEPORT_TARBALL
teleport/install
rm -vfr teleport
