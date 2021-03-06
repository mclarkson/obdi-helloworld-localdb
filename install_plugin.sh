#!/bin/bash
#
# Obdi - a REST interface and GUI for deploying software
# Copyright (C) 2014  Mark Clarkson
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# helloworld-runscript plugin

[[ -z $guid ]] && {
  echo "ERROR: environment variable 'guid' must be set."
  exit 1
}

proto="https"
opts="-k -s" # don't check ssl cert, silent
ipport="127.0.0.1:443"

#
# Create a temporary file and a trap to delete it
#

t="/tmp/install_helloworld_localdb_$$"
touch $t
[[ $? -ne 0 ]] && {
    echo "Could not create temporary file. Aborting."
    exit 1
}
trap "rm -f -- '$t'" EXIT

#
# Create the plugin entry in obdi, so it can be shown in the sidebar
#

curl -k -d '{
    "Name":"helloworld-localdb",
    "Desc":"Hello World plugin.",
    "HasView":1,
    "Parent":"helloworld"
}' $proto://$ipport/api/admin/$guid/plugins | tee $t

# Grab the id of the last insert
id=`grep Id $t | grep -Eo "[0-9]+"`

#
# Add the AJS controller files
#
# These need to be loaded when the application starts
#

curl -k -d '{
    "Name":"helloworld-localdb.js",
    "Desc":"Controller for HelloWorld LocalDB",
    "Type":1,
    "PluginId":'"$id"',
    "Url":"helloworld-localdb/js/controllers/helloworld-localdb.js"
}' $proto://$ipport/api/admin/$guid/files

# Delete the temporary file and delete the trap
rm -f -- "$t"
trap - EXIT

# Now force all the golang plugins to compile...

curl -k "$proto://$ipport/api/admin/$guid/helloworld-localdb/helloworld-localdb"

