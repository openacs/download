# /packages/download/www/all-metadata.tcl
ad_page_contract {
     
     @author jbank@arsdigita.com [jbank@arsdigita.com]
     @creation-date Fri Dec 15 17:52:24 2000
     @cvs-id $Id$
} {
    metadata_id:naturalnum,notnull
    {orderby:token ""}
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

if {$orderby eq ""} {
    set orderby $metadata_select
}
set elements [list \
                  $metadata_select {label $pretty_name display_template {<a href='@metadata.url_one_metadata@&value=@metadata.$metadata_select@'>@metadata.$metadata_select@</a>} orderby "$metadata_select"} \
                  version_count { label "[_ download._Versions]" orderby version_count } \
                  archive_count { label "[_ download._Files]" orderby archive_count}]

              
template::list::create -name metadata_list \
    -multirow metadata \
    -html {width "100%"} \
    -elements $elements -filters {metadata_id {}}

set sql_query "
        select $answer_column as $metadata_select, 
               count(dar.revision_id) as version_count,
               count(distinct dar.archive_id) as archive_count
        from download_revision_data drd, download_arch_revisions_obj dar
        where drd.revision_id = dar.revision_id and
              drd.metadata_id = :metadata_id
        group by $answer_column
        [template::list::orderby_clause -orderby -name metadata_list]"

db_multirow -extend {url_one_metadata} metadata all_metadata_list $sql_query {
    set url_one_metadata [export_vars -base one-mestada {metadata_id}]
}

ad_return_template