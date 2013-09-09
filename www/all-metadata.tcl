# /packages/download/www/all-metadata.tcl
ad_page_contract {
     
     @author jbank@arsdigita.com [jbank@arsdigita.com]
     @creation-date Fri Dec 15 17:52:24 2000
     @cvs-id $Id$
} {
    metadata_id:naturalnum,notnull
    {orderby ""}
}

if { ![db_0or1row metadata {
    select dam.pretty_name,
           dam.data_type
    from download_archive_metadata dam
    where dam.linked_p = 't' and
          dam.metadata_id = :metadata_id
}] } {
    ad_return_complaint 1 "Metadata id not found"
}
set answer_column [download_metadata_column $data_type]
set metadata_select "metadata$metadata_id"

set table_def [list \
    [list $metadata_select $pretty_name {} \
        "<td><a href=one-metadata?[export_vars -url {metadata_id}]&value=\[ad_urlencode \$$metadata_select\]>\$$metadata_select</td>"] \
    {version_count "[_ download._Versions]" 
        {version_count $order}
        {<td>$version_count</td>}} \
    {archive_count "[_ download._Files]" 
        {archive_count $order}
        {<td>$archive_count</td>}} \
]


set sql_query "
        select $answer_column as $metadata_select, 
               count(dar.revision_id) as version_count,
               count(distinct dar.archive_id) as archive_count
        from download_revision_data drd, download_arch_revisions_obj dar
        where drd.revision_id = dar.revision_id and
              drd.metadata_id = :metadata_id
        group by $answer_column
        [ad_order_by_from_sort_spec $orderby $table_def]"

set table [ad_table \
        -Torderby $orderby \
        -Ttable_extra_html { width=100% } \
        -bind [ad_tcl_vars_to_ns_set metadata_id] \
        all_metadata_list $sql_query $table_def ]

ad_return_template