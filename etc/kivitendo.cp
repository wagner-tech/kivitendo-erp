#!/bin/bash
set -e
#test
# parameter: $1: base dir for copy (optional)

mkdir -p $1/opt
cp -a src/kivitendo-erp $1/opt
mv $1/opt/kivitendo-erp $1/opt/kivitendo-erp-3.4.1

mkdir -p $1/etc/apache2/sites-available
mkdir -p $1/etc/apache2/sites-enabled
cp src/kivitendo-erp/etc/kivitendo.conf $1/etc/apache2/sites-available
cd $1/etc/apache2/sites-enabled && ln -s ../sites-available/kivitendo.conf .
