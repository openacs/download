# /packages/download/www/admin/approve-or-reject.tcl
ad_page_contract {
     
     @author jbank@arsdigita.com [jbank@arsdigita.com]
     @creation-date Wed Dec 13 10:10:30 2000
     @cvs-id $Id$
} {
    action:notnull
    revision_id:integer,notnull
    {return_url "[ad_conn package_url]"}
} -validate {
    valid_action_value {
        if { $action ne "approve" && $action ne "reject" } {
            ad_complain "The value for 'action' must be 'approve' or 'reject'"
        }
    }
}

set package_id [ad_conn package_id]

if {![db_0or1row revision_info_select {
select da.repository_id as repository_id,
       da.archive_id,
       da.archive_name,
       da.summary,
       dar.revision_id,
       dar.file_name,
       dar.version_name,
       dbms_lob.getlength(dar.content) as file_size,
       decode(da.latest_revision, dar.revision_id, 't', 'f') as current_version_p,
       dar.creation_user,
       dar.creation_date,
       u.last_name || ', ' || u.first_names as creation_user_name
from   download_archives_obj da,
       download_arch_revisions_obj dar,
       cc_users u
where  da.archive_id = dar.archive_id and
       dar.revision_id = :revision_id and
       u.user_id = dar.creation_user
}]} {
    ad_return_complaint 1 "The version id $revision_id was not found"
    return
}

if { $action eq "approve" } {
    set pretty_action "Approve"
    set pretty_noun "Approval"
} else {
    set pretty_action "Reject"
    set pretty_noun "Rejection"
}

ad_return_template

