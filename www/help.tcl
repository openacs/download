# /packages/download/www/help.tcl
ad_page_contract {
     
     @author jbank@arsdigita.com [jbank@arsdigita.com]
     @creation-date Tue Dec 12 22:17:40 2000
     @cvs-id
} {
}

array set repository [download_repository_info]
set title $repository(title)
set help_text $repository(help_text)
set context_bar [list "Help on $title"]

ad_return_template
