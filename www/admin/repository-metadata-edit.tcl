# /packages/download/www/admin/repository-metadata-edit.tcl
ad_page_contract {
     
     @author jbank@arsdigita.com [jbank@arsdigita.com]
     @creation-date Fri Dec 15 14:53:56 2000
     @cvs-id
} {
    metadata_id:integer,notnull
}

set repository_id [download_repository_id]
ad_require_permission $repository_id "admin"

db_0or1row metadata_select {
    select 
      dam.metadata_id,
      dam.repository_id,
      dam.archive_type_id,
      nvl(dat.pretty_name, 'All') as archive_name,
      dam.sort_key,
      dam.pretty_name,
      dam.data_type,
      dam.required_p,      
      dam.linked_p,        
      dam.mainpage_p,
      dam.computed_p      
    from download_archive_metadata dam, download_archive_types dat
         where dam.repository_id = :repository_id and
               dam.metadata_id = :metadata_id and
               dam.archive_type_id = dat.archive_type_id(+) 
    order by archive_type_id
}

set choices [db_list choices {
    select label from download_metadata_choices where metadata_id = :metadata_id
}]
set choices [join $choices ","]


form create edit_metadata 
element create edit_metadata metadata_id -label "MetadataID" -datatype integer -widget hidden
element create edit_metadata archive_type_id -label "Archive Type" -datatype integer -widget select -optional
element create edit_metadata pretty_name -label "Field Name" -datatype text
element create edit_metadata sort_key -label "Sort Key" -datatype integer
element create edit_metadata data_type -label "Data Type" -datatype text -widget select -options { {"short text" "shorttext"} {"long text" "text"} {"boolean" "boolean"} {"number" "number"} {"integer" "integer"} {"date" "date"} {"choice" "choice"}}
element create edit_metadata choices -label "Choices (, seperated list of choices if data type is choice)" -datatype text -optional
element create edit_metadata required_p -label "Is the field required" -datatype text -widget select -value "f" -options {{"True" "t"} {"False" "f"}}
element create edit_metadata linked_p -label "Should there be a link to show all archives with this value" -datatype text -widget select -value "f" -options {{"True" "t"} {"False" "f"}}
element create edit_metadata mainpage_p -label "Should this value show up in the main page table" -datatype text -widget select -value "f" -options {{"True" "t"} {"False" "f"}}
element create edit_metadata computed_p -label "Is this value computed (probably no)?" -datatype text -widget select -value "f" -options {{"True" "t"} {"False" "f"}}

element set_properties edit_metadata archive_type_id -options  [concat {{"All" ""}} [db_list_of_lists archiv_types "
    select pretty_name, archive_type_id from download_archive_types where repository_id = $repository_id"]]

if {[form is_request edit_metadata]} {
    foreach name {metadata_id archive_type_id pretty_name sort_key data_type choices required_p linked_p mainpage_p computed_p} {
        element set_properties edit_metadata $name -value [set $name]
        element set_properties edit_metadata $name -values [set $name]
    }
}

if {[form is_valid edit_metadata]} {
    form get_values edit_metadata
    db_transaction {
        db_dml metadata_update {
            update download_archive_metadata set
                  archive_type_id = :archive_type_id,
                  sort_key = :sort_key,
                  pretty_name = :pretty_name,
                  data_type = :data_type,
                  required_p = :required_p,
                  linked_p = :linked_p,
                  mainpage_p = :mainpage_p,
                  computed_p = :computed_p
            where metadata_id = :metadata_id and
                  repository_id = :repository_id 
        }
        db_dml choices_delete {
            delete from download_metadata_choices where metadata_id = :metadata_id
        }

        if { $data_type == "choice" } {
            set choices [split $choices ","]
            set count 0
            foreach choice $choices {
                incr count
                db_dml choice_insert {
                    insert into download_metadata_choices (choice_id, metadata_id, label, sort_order)
                    values (download_md_choice_id_sequence.nextval, :metadata_id, :choice, :count)
                }
            }
        }
    }
    ad_returnredirect "repository-metadata"
}


ad_return_template