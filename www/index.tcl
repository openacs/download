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


set table_def [list \
		   [list archive_name "[_ download.Software_Name_1]"\
			{lower(archive_name) $order} \
			{<td><a href=download-verify?revision_id=$revision_id><img src=[ad_conn package_url]/graphics/download.gif border=0></a> &nbsp;<a href=one-revision?revision_id=$revision_id>$archive_name $version_name</a> &nbsp;(${file_size}k)<br>$summary</td>}
		    ] \
	       [list archive_type "[_ download.Software_Type]" "" ""] \
	       [list downloads "[_ download._Downloads]" "" ""] \
	      ]

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
        set display "<td><a href=one-metadata?[export_url_vars metadata_id]&value=\[ad_urlencode \$$metadata_select\]>\$$metadata_select</td>"
    } else {
        set display ""
    }
    lappend table_def [list $metadata_select $pretty_name {} $display]
}

##Add on the metadata columns

if { $admin_p } {
    lappend table_def [list dar.approved_p "[_ download.Approval]" \
        {} \
        {<td> \
	[ad_decode $approved_p \
            "t" "<font color=green>approved</font> 
                \[<font size=-1>
                 <a href=admin/approve-or-reject?action=reject&[export_url_vars revision_id return_url]>reject</a></font>\]" \
            "f" "<font color=red>rejected</font>
                \[<font size=-1>
                 <a href=admin/approve-or-reject?action=approve&[export_url_vars revision_id return_url]>approve</a>\]" \
                "pending 
                \[<font size=-1>
                 <a href=admin/approve-or-reject?action=approve&[export_url_vars revision_id return_url]>approve</a> |
                 <a href=admin/approve-or-reject?action=reject&[export_url_vars revision_id return_url]>reject</a></font>\]
	"]
	    </td>}]
    }

set sql_query "
select da.archive_id,
       dat.pretty_name as archive_type,
       da.archive_type_id,
       da.archive_name,
       da.summary,
       dar.revision_id,
       dar.file_name,
       dar.version_name,
       dbms_lob.getlength(dar.content) as file_size,       
       (select count(*) from download_downloads where revision_id = dar.revision_id) as downloads,
       dar.approved_p 
       $metadata_selects
from   download_archives_obj da,
       download_archive_types dat,
       download_arch_revisions_obj dar
where  da.repository_id = :repository_id and
       dat.archive_type_id = da.archive_type_id and
       da.archive_id = dar.archive_id and
       acs_permission.permission_p(dar.revision_id, :user_id, 'read') = 't'
       $approval
       [ad_dimensional_sql $dimensional where]
       [ad_order_by_from_sort_spec $orderby $table_def]"

set dimensional_html [ad_dimensional $dimensional]
set table [ad_table \
        -Torderby $orderby \
        -Tband_colors {{} {\"\#cccccc\"}} \
        -bind [ad_tcl_vars_to_ns_set user_id repository_id] \
        -Ttable_extra_html { cellpadding=3 } \
        download_index_query $sql_query $table_def ]


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