# /packages/download/www/admin/spam-users-2.tcl
ad_page_contract {
     Spam downloaders.
     @author jbank@arsdigita.com [jbank@arsdigita.com]
     @creation-date Mon Jan  8 18:05:51 2001
     @cvs-id
} {
    userid_list:verify
    subject:notnull
    msgbody:notnull
}

ad_require_permission [ad_conn package_id] "admin"

set user_id [ad_verify_and_get_user_id]

set page_content "[ad_header "Spam Downloaders"]

<h2>Spam Downloaders</h2> 
<p>
[ad_context_bar "Spam Downloader"]

<h3>Spam Downloader </h3>

Spam is being sent out. You may move to a different url if you don't want to 
wait for this process to complete.

<p>
...
"

# Takes too long to send emails
ad_return_top_of_page $page_content

# send out email
set count 0
foreach to_user_id $userid_list {
    db_exec_plsql sendmail {
        begin
           :1 := nt.post_request(
                party_from => :user_id,
                party_to => :to_user_id,
                expand_group => 'f',
                subject => :subject,
                message => :msgbody);
        end;
    }
    incr count
}

set page_content "

<p>
<b>$count</b> users are spammed successfully!

[ad_footer]
"

ns_write $page_content






