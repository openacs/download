# /packages/download/www/admin/spam-users-2.tcl
ad_page_contract {
     Spam downloaders.
     @author jbank@arsdigita.com [jbank@arsdigita.com]
     @creation-date Mon Jan  8 18:05:51 2001
     @cvs-id $Id$
} {
    user_id_list:verify
    subject:notnull
    msgbody:notnull
}

permission::require_permission -object_id [ad_conn package_id] -privilege "admin"

set user_id [ad_conn user_id]

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
foreach to_user_id $user_id_list {
    set from_addr [acs_user::get_element -user_id $user_id -element email]
    set to_addr [acs_user::get_element -user_id $to_user_id -element email]
    acs_mail_lite::send -to_addr $to_addr -from_addr $from_addr \
        -subject $subject -body $msgbody
    incr count
}

set page_content "

<p>
<b>$count</b> users are spammed successfully!

[ad_footer]
"

ns_write $page_content






