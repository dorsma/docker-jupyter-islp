#!/bin/bash

export SCRIPTS="$(dirname "$(realpath "${BASH_SOURCE-$0}")")"
$SCRIPTS/run.sh local-build
