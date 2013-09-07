# /packages/download/www/admin/approve-or-reject-2.tcl
ad_page_contract {
     
     @author jbank@arsdigita.com [jbank@arsdigita.com]
     @creation-date Wed Dec 13 10:10:30 2000
     @cvs-id $Id$
} {
    action:notnull
    revision_id:integer,notnull
    { approved_comment [db_null] }
    {return_url "[ad_conn package_url]"}
} -validate {
    valid_action_value {
        if { $action != "approve" && $action != "reject" } {
            ad_complain "The value for 'action' must be 'approve' or 'reject'"
        }
    }
}

array set repository_info [download_repository_info]

set repository_id $repository_info(repository_id)
set user_id [ad_conn user_id]

permission::require_permission -object_id $repository_id -privilege "admin"

if { $action == "approve" } {
    set approved_p "t"
    set approval_action "approving"
    set approval_status "APPROVED"
} else {
    set approved_p "f"
    set approval_action "rejecting"
    set approval_status "NOT APPROVED"
}

# Here's where we update the database to set the version as approved
if [catch {
    db_dml version_approve "
       update download_archive_revisions
         set approved_p = :approved_p,
             approved_comment = :approved_comment,
             approved_user = :user_id,
             approved_date = sysdate
       where revision_id = :revision_id
    " 
} errmsg] {
    ad_return_error "Problem $approval_action version" "There was a problem $approval_action the version
    in the database.  Here's the error message: $errmsg"
    return
}

# Everything after here is email related, so let's send the user on their way
ad_returnredirect $return_url
# do not abort/return here!

if {[parameter::get -package_id [ad_conn package_id] -parameter approval_notification -default 1] == 1} {
    # We want to send email to use who submitted the version to let
    # them know it's approved (or rejected).
    
    # This is the email address of the user who submitted the version.
    db_1row creation_email_select {
        select da.archive_name,
               dar.creation_user,
               dar.version_name
          from download_arch_revisions_obj dar, download_archives_obj da
         where da.archive_id = dar.archive_id and dar.revision_id = :revision_id
    } 

    # This is the email address and name of the user who approved (or rejected) the version
    db_1row approving_user_select {
        select email as approving_email,
               first_names || ' ' || last_name as approving_name
          from cc_users 
         where user_id = :user_id
    }

    set body "
    Your posting to [ad_system_name] $repository_info(title): $archive_name $version_name
    
    [ad_url][ad_conn package_url]/one-revision?revision_id=$revision_id
    
    was approved by $approving_name:\n\n$approved_comment"

    set subject "$repository_info(title):  $archive_name $version_name $approval_status: "

    db_exec_plsql sendmail {
        begin
           :1 := acs_mail_nt.post_request(
                party_from => :user_id,
                party_to => :creation_user,
                expand_group => 'f',
                subject => :subject,
                message => :body);
        end;
    }
}
