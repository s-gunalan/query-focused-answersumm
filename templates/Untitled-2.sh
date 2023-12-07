#!/bin/bash

read -p 'SID: ' sid
read -p 'Name (eg. Google Photos): ' name

# Trim both variables
sid="$(echo -e "${sid}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
name="$(echo -e "${name}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"

# Lowercase the SID and declare $sid_upper
sid=${sid,,}
sid_upper=${sid^^}

# Make the name: name (SID)
full_name="$name (${sid_upper})"

read -r -d '' confirm << EOM
This script will create the following groups for: $full_name
  tomo-data-$sid
  tomo-data-$sid-sphinx
  tomo-pocs-$sid
EOM
echo -e "$confirm\n"
read -p "Ok to proceed? (y/n): " should_proceed
if [[ ! $should_proceed =~ ^[Yy]$ ]]
then
    [[ "$0" = "${BASH_SOURCE[0]}" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
fi

# Create mdb/tomo-data-sid
ganpati2 group add --name tomo-data-"$sid" --type ACL --namespace prod --owners tomo-grpadm.prod,%tomo-grpadm.prod --description "Grants access to $full_name data in Tomodata raw tables and data warehouse. For documentation, see go/tomo-plx. To request access to this group, use go/tomo-plx-access."

# Add it to mdb/tomo-data
ganpati2 membership add --parent %tomo-data.prod --child %tomo-data-"$sid".prod --expiration never --approve_now true 

# Create Sphinx managed group underneath mdb/tomo-data-sid
ganpati2 group add --name tomo-data-"$sid"-sphinx  --namespace prod --type TEAM --owners tomo-sphinx-grpadm.prod --description "Sphinx managed group granting access to mdb/tomo-data-$sid, or $full_name data in Tomodata raw tables and data warehouse. For documentation, see go/tomo-plx."

# Add it to mdb/tomo-data-sid with MEMBERS expansion
ganpati2 membership add --parent %tomo-data-"$sid".prod --child %tomo-data-"$sid"-sphinx.prod --expiration never  --approve_now true  
#-acl=members -confirm=false



# Create mdb/tomo-pocs-sid
ganpati2 group add --name tomo-pocs-"$sid" --namespace prod --type TEAM  --owners tomo-grpadm.prod --description "All Tomo POCs (points of contact) for $full_name. This group approves Sphinx requests for Tomo data access in PLX." 
#-critical=no

# Add it to mdb/tomo-pocs
ganpati2 membership add --parent %tomo-pocs-"$sid".prod --child %tomo-pocs.prod --expiration never  --approve_now true --description "Add SID specific POC group to the parent mdb/tomo-pocs for easy syncing with Google group tomo-pocs@google.com" 
#--acl MEMBERS -confirm=false

# Add it to mdb/tomo-data-sid
ganpati2 membership add --parent %tomo-data-"$sid".prod --child %tomo-pocs-"$sid".prod --expiration never --approve_now true  --description "Ensure POCs have READ access to tomodata PLX tables." 
#-acl=members -confirm=false

