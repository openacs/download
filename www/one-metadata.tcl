# /packages/download/www/one-metadata.tcl
ad_page_contract {
     Show all revisions with a given metadata value.
     @author jbank@arsdigita.com [jbank@arsdigita.com]
     @creation-date Fri Dec 15 17:33:03 2000
     @cvs-id $Id$
} {
    metadata_id:naturalnum,notnull
    value
}

if { ![db_0or1row metadata {
    select dam.pretty_name,
           dam.data_type
    from download_archive_metadata dam
    where dam.linked_p = 't' and
          dam.metadata_id = :metadata_id
}] } {
    ad_return_complaint 1 [_ download.lt_Metadata_id_not_found]
    ad_script_abort
}
set answer_column [download::metadata_column $data_type]

##TODO: Add archive types
db_multirow archives archives "
        select da.archive_name,
               da.archive_id,
               count(dar.revision_id) as num_versions
        from download_arch_revisions_obj dar, download_archives_obj da
        where dar.archive_id = da.archive_id and
              dar.revision_id in (select revision_id from download_revision_data where $answer_column = :value and metadata_id = :metadata_id)
        group by da.archive_name, da.archive_id
"

set context [list [list "all-metadata?metadata_id=$metadata_id" "All $pretty_name"] "One $pretty_name"]
ad_return_template
