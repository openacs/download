# /packages/download/www/admin/index.tcl
ad_page_contract {
     Top level admin page.
     @author jbank@arsdigita.com [jbank@arsdigita.com]
     @creation-date Tue Dec 12 15:11:08 2000
     @cvs-id $Id$
} {
}

array set repository [download::repository_info]
set repository_id $repository(repository_id)
set title $repository(title)
set description $repository(description)
set help_text $repository(help_text)

permission::require_permission -object_id $repository_id -privilege "admin"

ad_return_template