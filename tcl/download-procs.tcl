# /packages/download/tcl/download-procs.tcl
ad_library {
     Procs used by the download module.
     @author jbank@arsdigita.com [jbank@arsdigita.com]
     @creation-date Tue Dec 12 15:13:52 2000
     @cvs-id
}

# @author jbank@arsdigita.com [jbank@arsdigita.com]
# @creation-date Tue Dec 12 15:14:13 2000
ad_proc download_repository_info { {package_id ""} {do_redirect 1}} {
    Get information about the repository mounted for package_id.
} {
    if [empty_string_p $package_id] {
        set package_id [ad_conn package_id]
    }
    if { ![db_0or1row repository_info {
        select repository_id, title, description, help_text from download_repository_obj where parent_id = :package_id
    } -column_array repository ] } {
        #Package not setup
        if { $do_redirect } {
            set admin_p [ad_permission_p $package_id "admin"]
            if { $admin_p } {
                set repository_id [db_nextval acs_object_id_seq]
                set return_url "[ad_conn package_url]admin/repository-types"
                ad_return_error "Not setup" "Please <a href=\"[ad_conn package_url]admin/repository-ae?[export_url_vars repository_id return_url]\">configure this instance of the download module</a>."
            } else {
                ad_return_error "Not setup" "Please have an admin configure this instance of the download module."
            }
        }
    } else {
        if { $do_redirect } {
            set repository_id $repository(repository_id)
            set count [db_string type_info {
                select count(*) from download_archive_types where repository_id = :repository_id
            }]
                if { $count == 0 } {
                    set return_url "[ad_conn url]?[ad_conn query]"
                    ad_return_error "Not setup" "Please <a href=\"[ad_conn package_url]admin/repository-types?[export_url_vars repository_id return_url]\">add a download type</a>."
                }
            }
    }
    return [array get repository]
}

ad_proc download_repository_id { {package_id ""} {do_redirect 1}} {
    Get repository_id mounted for package_id.
} {
    array set repository [download_repository_info $package_id $do_redirect]
    return $repository(repository_id)
}

# @author jbank@arsdigita.com [jbank@arsdigita.com]
# @creation-date Tue Dec 12 17:52:07 2000
ad_proc download_metadata_widget { data_type name metadata_id {user_value ""}} {
    Return a widget to take input of the given data_type
} {
    set html ""
    set element_name "metadata.$metadata_id"
    switch -- $data_type {
	"number" {
	    append html "<input type=text name=$element_name value=\"[philg_quote_double_quotes $user_value]\" size=10>"
	}
	"integer" {
	    append html "<input type=text name=$element_name value=\"[philg_quote_double_quotes $user_value]\" size=10>"
	}
	"shorttext" {
	    append html "<input type=text name=$element_name value=\"[philg_quote_double_quotes $user_value]\" size=20>"
	}

	"text" {
	    append html "<textarea name=$element_name>$user_value</textarea>" 
	}
	"date" {
	    append html "[ad_dateentrywidget $element_name $user_value]" 
	}
	"boolean" {
            append html "<select name=$element_name>
            <option value=\"\">Select One</option>
            <option value=\"t\" [ad_decode $user_value "t" "selected" ""]>True</option>
            <option value=\"f\" [ad_decode $user_value "f" "selected" ""]>False</option>
            </select>
            "
        }
        "choice" {
            append html "<select name=$element_name>
            <option value=\"\">Select One</option>\n"
            db_foreach download_metadata_choices "select choice_id, label
            from download_metadata_choices
            where metadata_id = :metadata_id
            order by sort_order" {
                if { $user_value == $choice_id } {
                    append html "<option value=$choice_id selected>$label</option>\n"
                } else {
                    append html "<option value=$choice_id>$label</option>\n"
                }
            }
            append html "</select>"
        }
    }
    return "
            <tr><th align=right valign=top>$name</th>
                <td>$html</td>
            </tr>"
}

ad_proc download_file_downloader {
} {
    Sends the requested file to the user.  Note that the path has the 
    original file name, so the browser will have a sensible name if you 
    save the file.  Version downloads are supported by looking for
    the form variable version_id.  We don't actually check that the 
    version_id matches the path, we just serve it up.
} {
    ad_page_contract {
    } {
	{ revision_id:naturalnum,notnull "" }
	{ download_id:naturalnum,notnull "" }
        { reason_id "" }
	{ reason_other ""}
    }
    
    ns_log Notice "download_file_downloader: $revision_id"

    set user_id [ad_verify_and_get_user_id]
    set download_ip [ad_conn peeraddr]
    if [catch {
        set download_hostname [ns_hostbyaddr $download_ip]
    }] {
        set download_hostname [db_null]
    }
    set user_agent  [ns_set iget [ad_conn headers] user-agent]

    regexp "[ad_conn package_url]download/(.*)" [ad_conn url] match path

    if [empty_string_p $revision_id] {
        ad_script_abort
    }

    ad_require_permission $revision_id "read"

    ##Record the download for all time!!
    set double_click_p [db_string download_count "select count(*) from download_downloads where download_id = :download_id"]
    if { $double_click_p == 0 } {
        if [catch {
            db_dml download_insert {
                insert into download_downloads (
                download_id, 
                user_id, 
                revision_id, 
                download_date, 
                download_ip,
                download_hostname,
                user_agent,
                reason_id,
                reason)
                values
                (:download_id, 
                :user_id, 
                :revision_id, 
                sysdate, 
                :download_ip,
                :download_hostname,
                :user_agent,
                :reason_id,
                :reason_other)
            }
        } errmsg] {
            ns_log Error "Download: Unable to log download due to an error: $errmsg"
        }
    }

    db_1row file_type "
    select mime_type 
    from   cr_revisions 
    where  revision_id = :revision_id"

    ReturnHeaders $mime_type

    db_write_blob version_write "select content
                                 from   cr_revisions
                                 where  revision_id = :revision_id"



    return filter_return
}

##Borrowed from file-storage
ad_proc download_maybe_create_new_mime_type {
    file_name
} {
    The content repository expects the MIME type to already be defined
    when you upload content.  We use this procedure to add a new type
    when we encounter something we haven't seen before.
} {

    set mime_type [ns_guesstype $file_name]
    set extension [string trimleft [file extension $file_name] "."]

    # don't know how to generate nice names like "JPEG Image"
    # have to leave it blank for now

    #set pretty_mime_type ???

    if { [db_string mime_type_exists "
    select count(*) from cr_mime_types
    where  mime_type = :mime_type"] == 0 } {
	db_dml new_mime_type "
	insert into cr_mime_types
	(mime_type, file_extension)
	values
	(:mime_type, :extension)"
    }

    return $mime_type
}

# @author jbank@arsdigita.com [jbank@arsdigita.com]
# @creation-date Fri Dec 15 14:07:02 2000
ad_proc download_metadata_column { data_type } { Dummy comment.} {
    switch -- $data_type {
        date { set answer_column "date_answer" }
        boolean { set answer_column "boolean_answer" }
        number { set answer_column "number_answer" }
        integer { set answer_column "number_answer" }
        choice { set answer_column "choice_answer" }
        text { set answer_column "clob_answer" }
        default {
            set answer_column "varchar_answer"
        }
    }
    return $answer_column
}


# @author jbank@arsdigita.com [jbank@arsdigita.com]
# @creation-date Fri Dec 15 16:14:40 2000
ad_proc download_validate_metadata { repository_id metadata_info archive_type_id } {
    Validate metadata arguments for a given archive_type
} {
    ns_log Notice "FOOOO: $metadata_info"
    array set metadata $metadata_info
    set metadata_with_missing_responses [list]
    ##Iterate over the metadata information
    db_foreach metadata {
        select 
        dam.metadata_id,
        dam.pretty_name,
        dam.data_type,
        dam.required_p
        from download_archive_metadata dam
        where dam.repository_id = :repository_id and
        dam.computed_p = 'f' and
        (dam.archive_type_id = :archive_type_id or
         dam.archive_type_id is null)
        order by sort_key
    } {
        if { $data_type == "date" } {
            if [catch  { set metadata($metadata_id) [validate_ad_dateentrywidget "" metadata.$metadata_id [ns_getform]]} errmsg] {
                ad_complain "$errmsg: Please make sure your dates are valid."
            }
        }
        if { [exists_and_not_null metadata($metadata_id)] } {
            set response_value [string trim $metadata($metadata_id)]
        } elseif {$required_p == "t"} {
            lappend metadata_with_missing_responses $pretty_name
            continue
        } else {
            set response_to_question($question_id) ""
            set response_value ""
        }
        if {![empty_string_p $response_value]} {
            if { $data_type == "number" } {
                if { ![regexp {^(-?[0-9]+\.)?[0-9]+$} $response_value] } {

                    ad_complain "The value for \"$metadata\" must be a number. Your value was \"$response_value\"."
                    continue
                }
            } elseif { $data_type == "integer" } {
                if { ![regexp {^[0-9]+$} $response_value] } {
                    ad_complain "The value for \"$metadata\" must be an integer. Your value was \"$response_value\"."
                    continue
                }
            }
        }
        

        ns_log Notice "LOGGING: Metadata $pretty_name: $metadata($metadata_id)"
    }
    if { [llength $metadata_with_missing_responses] > 0 } {
        ad_complain "You didn't respond to all required sections. You skipped:"
        ad_complain [join $metadata_with_missing_responses "\n"]
    }
    return [array get metadata]
}

# @author jbank@arsdigita.com [jbank@arsdigita.com]
# @creation-date Fri Dec 15 16:16:41 2000
ad_proc download_insert_metadata { repository_id archive_type_id revision_id metadata_array} {
    Do metadata insertion.  Assume within transaction.
} {
    array set metadata $metadata_array
    set metadata_list [db_list_of_lists survsimp_question_info_list {
            select 
            dam.metadata_id,
            dam.data_type
            from download_archive_metadata dam
            where dam.repository_id = :repository_id and
               dam.computed_p = 'f' and
               (dam.archive_type_id = :archive_type_id or
                dam.archive_type_id is null)
            order by sort_key
    }]

    foreach metadata_info $metadata_list {
        set metadata_id [lindex $metadata_info 0] 
        set data_type [lindex $metadata_info 1] 
        set response $metadata($metadata_id)
        set answer_column [download_metadata_column $data_type]
        db_dml metadata_inserts "
         insert into download_revision_data(revision_id, metadata_id, $answer_column)
         values ( :revision_id, :metadata_id, :response )
        "
    }
}

# @author jbank@arsdigita.com [jbank@arsdigita.com]
# @creation-date Fri Dec 15 16:20:38 2000
ad_proc download_insert_revision { upload_file tmpfile repository_id archive_type_id archive_id version_name revision_id user_id creation_ip approved_p metadata_array } {
    Dummy comment.
} {
    # get the filename part of the upload file
    if ![regexp {[^//\\]+$} $upload_file filename] {
        # no match
        set filename $upload_file
    }

	# get the file_size for the postgres version
	set file_size [file size $tmpfile]

    set mime_type [download_maybe_create_new_mime_type $upload_file]
    db_exec_plsql revision_new {
        declare
          v_revision_id integer;
        begin
          v_revision_id := content_revision.new(
           item_id => :archive_id,
           title => :filename,
           description => :version_name,
           revision_id => :revision_id,
           mime_type => :mime_type,
           creation_user => :user_id,
           creation_ip => :creation_ip
          );

          insert into download_archive_revisions (revision_id,    approved_p) values
                                                 (v_revision_id, :approved_p);
        end;
    }

    db_dml content_add {
        update cr_revisions
        set    content = empty_blob()
        where  revision_id = :revision_id
        returning content into :1
    } -blob_files [list $tmpfile]

    db_exec_plsql make_live {
        begin
        content_item.set_live_revision(:revision_id);
        end;
    }

    download_insert_metadata $repository_id $archive_type_id $revision_id $metadata_array
}
