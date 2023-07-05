#!/bin/bash

TELEPORT_VERISON="13.1.5"
command -v teleport || curl https://goteleport.com/static/install.sh | bash -s $TELEPORT_VERISON
