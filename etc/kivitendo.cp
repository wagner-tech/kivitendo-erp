#!/bin/bash
set -e

# parameter: $1: base dir for copy (optional)

mkdir -p $1/opt
cp -a src/kivitendo-erp $1/opt
