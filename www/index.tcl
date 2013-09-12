# /packages/download/www/index.tcl
ad_page_contract {
     Main download page.
     @author jbank@arsdigita.com [jbank@arsdigita.com]
     @creation-date Mon Dec 11 18:28:29 2000
     @cvs-id $Id$
} {
    {archive_type_id ""}
    {orderby "archive_name"}
    {query_string ""}
	{updated ""}
} -properties {
    title:onevalue
    description:onevalue
    help_text:onevalue
    write_p:onevalue
    admin_p:onevalue
    master_admin_p:onevalue    
}

set return_url "[ad_conn url]?[ad_conn query]"
set user_id [ad_conn user_id]

array set repository [download_repository_info]
set repository_id $repository(repository_id)

set master_admin_p [permission::permission_p -object_id [ad_conn package_id] -privilege admin]
set admin_p [permission::permission_p -object_id $repository_id -privilege admin]
set write_p [permission::permission_p -object_id $repository_id -privilege write]

set title $repository(title)
set description $repository(description)
set help_text $repository(help_text)

#select the current list of archives
set type_dimlist {}
db_foreach archive_type {
    select archive_type_id as at_id, pretty_name from download_archive_types where repository_id = :repository_id
} {
    lappend type_dimlist [list $at_id $pretty_name [list where "da.archive_type_id = $at_id"]]
}
lappend type_dimlist {"" "#download.all#" {}}

set dimensional [list [list versions "#download.Versions#" current [list \
									 [list current "[_ download.current]" {where "[db_map archive_where_clause]"} ] \
									 [list all "[_ download.all]" {where "da.archive_id = dar.archive_id"} ]
								     ]]\
		     [list archive_type_id "[_ download.Type]" "" $type_dimlist] \
		     [list updated "[_ download.Updated]" all [list \
								   [list 1d "[_ download.last_24hrs]" {where "[db_map date_clause_1]"}] \
								   [list 1w "[_ download.last_week]"  {where "[db_map date_clause_7]"}] \
								   [list 1m "[_ download.last_month]" {where "[db_map date_clause_30]"}] \
								   [list all "[_ download.all]" {}]]
		     ]]

if { $admin_p } {
    set approval ""
    lappend dimensional [list approved "[_ download.Approval]" approved \
			     [list \
				  [list pending "[_ download.pending]"   {where "dar.approved_p is null"}] \
				  [list approved "[_ download.approved]" {where "dar.approved_p = 't'"}] \
				  [list rejected "[_ download.rejected]" {where "dar.approved_p = 'f'"}] \
				  [list all "[_ download.all]" {}] \
				  ]
			 ]
} else {
    set approval "       and dar.approved_p = 't'  "
}

set element_list {
    archive_name {
        label "Software Name"
        display_template {
            <a href='@downloads_multirow.download_url@'>
            <img src='@downloads_multirow.download_img@' border=0>
            </a> &nbsp;<a href=@downloads_multirow.revision_url@>@downloads_multirow.archive_name@ @downloads_multirow.version_name@</a> 
            &nbsp;(@downloads_multirow.file_size@k)<br>@downloads_multirow.summary@
        } 
        orderby "archive_name"
    }
    archive_type {
        label "Software Type"
        orderby "archive_type"
    }
    downloads {
        label "# Downloads"
        orderby "downloads"
    }
}

#Setup the metadata
set metadata_selects ""
db_foreach metadata {
    select dam.metadata_id,
           dam.pretty_name,
           dam.data_type,
           dam.linked_p
    from download_archive_metadata dam
    where dam.mainpage_p = 't' and
          dam.repository_id = :repository_id and
          (dam.archive_type_id = :archive_type_id or dam.archive_type_id is null)
    order by sort_key
} {
    set answer_column [download_metadata_column $data_type]
    set metadata_select "metadata$metadata_id"
    append metadata_selects ", (select $answer_column from download_revision_data where revision_id = dar.revision_id and metadata_id = $metadata_id) as $metadata_select
    "
    if { $linked_p == "t" } {
        set display "<a href=one-metadata?[export_vars -url {metadata_id}]&value=@downloads_multirow.$metadata_select@>@downloads_multirow.$metadata_select@</a>"
    } else {
        set display ""
    }
    lappend element_list $metadata_select [list label $pretty_name display_template $display]
}

##Add on the metadata columns

if { $admin_p } {
    lappend element_list approved_p {
        label "[_ download.Approval]"
        display_template {
            <font color=@downloads_multirow.approved_color@>@downloads_multirow.approved_text@</font> 
            \[<font size=-1><a href='@downloads_multirow.approved_url@'>@downloads_multirow.approved_action@</a></font>\]
        }
    }
}

template::list::create -name download_list \
    -multirow downloads_multirow \
    -elements $element_list \
    -filters {archive_type_id {} query_string {} updated {}}

set img_url "[ad_conn package_url]/graphics/download.gif"
db_multirow -extend {metadata_url download_img revision_url download_url approved_color approved_text approved_url approved_action reject_url} downloads_multirow download_index_query {*} {
    set download_img $img_url
    if {$approved_p} {
        set approved_url [export_vars -base admin/approve-or-reject {{action reject} revision_id return_url}]
        set approved_text "approved"
        set approved_color green
        set approved_action "reject"
    } else {
        set approved_url [export_vars -base admin/approve-or-reject {{action approve} revision_id return_url}]
        set approved_text "rejected"
        set approved_action approve
        set approved_color red
    }

    set download_url "download/$file_name?revision_id=$revision_id"
    set revision_url "one-revision?revision_id=$revision_id"
    set metadata_url [export_vars -base one-metadata {metadata_id}]

}


set dimensional_html [ad_dimensional $dimensional]

db_multirow types types_select {
    select archive_type_id, pretty_name, description from download_archive_types where repository_id = :repository_id
}

db_multirow my_revisions my_revisions {
        select da.archive_name,
               dar.version_name,
               dar.revision_id,
               dar.approved_p,
               nvl(dar.approved_comment, 'No comment') approved_comment,
               to_char(dar.creation_date,'Mon DD, YYYY') as creation_date
    from download_arch_revisions_obj dar, download_archives_obj da
    where da.repository_id = :repository_id and
          dar.archive_id = da.archive_id and
          approved_p != 't' and
          dar.creation_user = :user_id
    order by creation_date
}



ad_return_template
