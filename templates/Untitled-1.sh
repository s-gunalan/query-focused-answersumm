
ganpati add-group -g=tomo-data-s3ts -group_type=acl -critical=no -admin=tomo-grpadm -description="Grants access to $full_name data in Tomodata raw tables and data warehouse. For documentation, see go/tomo-plx. To request access to this group, use go/tomo-plx-access."

[-h] --description {STRING} --name {NAME} --namespace {Comma-separated list of namespace names or IDs}
                          [--active_directory {boolean: true, 1, false, or 0}] [--alternate_email {STRING}] [--contact_email {STRING}]
                          [--corp_posix {boolean: true, 1, false, or 0}] [--corp_uid {INT}] [--default_membership_duration {duration: "none" or "30d12h"}]
                          [--default_receive_email {boolean: true, 1, false, or 0}] [--default_send_email {boolean: true, 1, false, or 0}]
                          [--eligible_bypasses_prune {ELIGIBLE_BYPASSES_PRUNE}] [--ldap_google_com {boolean: true, 1, false, or 0}]
                          [--leaders {Comma-separated list of user.ns, %group.ns, or 12345}] [--locked {boolean: true, 1, false, or 0}]
                          [--managed_membership_policy_expr {STRING}] [--maximum_membership_duration {duration: "none" or "30d12h"}]
                          [--not_member {boolean: true, 1, false, or 0}] [--not_role_assignment_principal {boolean: true, 1, false, or 0}]
                          [--owners {Comma-separated list of user.ns, %group.ns, or 12345}] [--quiet {boolean: true, 1, false, or 0}] [--reason {STRING}]
                          [--requester {Comma-separated list of user.ns, %group.ns, or 12345}] [--self_owned {boolean: true, 1, false, or 0}]
                          [--sox_sensitive {boolean: true, 1, false, or 0}] [--status {ACTIVE or DISABLED}] [--system_id {integer}]
                          [--two_party_control {boolean: true, 1, false, or 0}]
                          [--type {ACL, ADMIN, APPENGINE_ROLE, BORG_ROLE, ON_DEMAND, REALM, REALM_GROUP, ROLE_POLICY, SERVER_AUTHORIZATION_REALMS, SERVER_AUTHORIZATION_USERS, SYSTEM, TEAM, TEAM_POLICY, or UNKNOWN_LEGACY}]

# Add it to mdb/tomo-data
ganpati add-member -g=tomo-data -m=tomo-data-"$sid" -expires=never -acl=members -approve_now=true -confirm=false


usage: ganpati2 membership add [-h] [--approve_now [true|false]] [--requester user.ns|%group.ns|ID]
                               [--disable_proposal_analysis constraint name [constraint name ...]] [--quiet [true|false]] [--reason STRING]
                               [--parent user.ns|%group.ns|ID] [--child user.ns|%group.ns|ID] [--type INCLUDE|EXCLUDE|ELIGIBLE|CANDIDATE]
                               [--expiration YYYY-MM-DD|YYYY-MM-DD HH:MM:SS|never] [--get_email [true|false]] [--description STRING]



ganpati2 membership add --parent %tomo-pocs.prod --child %tomo-pocs-s3ts.prod --expiration never  --approve_now true --description "Add SID specific POC group to the parent mdb/tomo-pocs for easy syncing with Google group tomo-pocs@google.com" 
