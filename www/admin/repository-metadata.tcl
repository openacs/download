# /packages/download/www/admin/repository-metadata.tcl
ad_page_contract {
     Repository metadata
     @author jbank@arsdigita.com [jbank@arsdigita.com]
     @creation-date Tue Dec 12 15:58:00 2000
     @cvs-id $Id$
} {
}

set repository_id [download_repository_id]
set title "Download Repository Metadata"
set context [list "Metadata"]

form create add_metadata
element create add_metadata metadata_id -label "MetadataID" -datatype integer -widget hidden
element create add_metadata archive_type_id -label "Archive Type" -datatype integer -widget select -optional
element create add_metadata pretty_name -label "Field Name" -datatype text
element create add_metadata sort_key -label "Sort Key" -datatype integer
element create add_metadata data_type -label "Data Type" -datatype text -widget select -options { {"short text" "shorttext"} {"long text" "text"} {"boolean" "boolean"} {"number" "number"} {"integer" "integer"} {"date" "date"} {"choice" "choice"}}
element create add_metadata choices -label "Choices (, separated list of choices if data type is choice)" -datatype text -optional
element create add_metadata required_p -label "Is the field required" -datatype text -widget select -value "f" -options {{"True" "t"} {"False" "f"}}
element create add_metadata linked_p -label "Should there be a link to show all archives with this value" -datatype text -widget select -value "f" -options {{"True" "t"} {"False" "f"}}
element create add_metadata mainpage_p -label "Should this value show up in the main page table" -datatype text -widget select -value "f" -options {{"True" "t"} {"False" "f"}}
element create add_metadata computed_p -label "Is this value computed (probably no)?" -datatype text -widget select -value "f" -options {{"True" "t"} {"False" "f"}}

element set_properties add_metadata archive_type_id -options  [concat {{"All" ""}} [db_list_of_lists archiv_types "
    select pretty_name, archive_type_id from download_archive_types where repository_id = $repository_id"]]

if { [form is_request add_metadata] } {
    element set_properties add_metadata metadata_id -value [db_nextval acs_object_id_seq]
}

if {[form is_valid add_metadata]} {
    form get_values add_metadata
    db_transaction {
        db_dml metadata_insert {
            insert into download_archive_metadata (
              metadata_id,
              repository_id, 
              archive_type_id,
              sort_key,
              pretty_name,
              data_type,
              required_p,
              linked_p,
              mainpage_p,
              computed_p)
            values (
              :metadata_id,
              :repository_id, 
              :archive_type_id,
              :sort_key,
              :pretty_name,
              :data_type,
              :required_p,
              :linked_p,
              :mainpage_p,
              :computed_p)
        }

        if { $data_type eq "choice" } {
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
        #Clear up all old values to defaults
        foreach name {archive_type_id pretty_name sort_key data_type choices} {
            element set_properties add_metadata $name -value ""
        }
        foreach name {required_p linked_p mainpage_p computed_p} {
            element set_properties add_metadata $name -value "f"
        }
        element set_properties add_metadata metadata_id -value [db_nextval acs_object_id_seq]
    }
}

db_multirow metadata metadata_select {
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
               dam.archive_type_id = dat.archive_type_id(+)
    order by archive_type_id, sort_key
}

ad_return_template
