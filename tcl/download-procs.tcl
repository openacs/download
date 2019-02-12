# /packages/download/tcl/download-procs.tcl
ad_library {
    Procs used by the download module.
    @author jbank@arsdigita.com [jbank@arsdigita.com]
    @creation-date Tue Dec 12 15:13:52 2000
    @cvs-id $Id$
}

# @author jbank@arsdigita.com [jbank@arsdigita.com]
# @creation-date Tue Dec 12 15:14:13 2000
ad_proc download_repository_info { {package_id ""} {do_redirect 1}} {
    Get information about the repository mounted for package_id.
} {
    if {$package_id eq ""} {
        set package_id [ad_conn package_id]
    }
    if { ![db_0or1row repository_info {
        select repository_id, title, description, help_text from download_repository_obj where parent_id = :package_id
    } -column_array repository ] } {
        #Package not setup
        if { $do_redirect } {
            set admin_p [permission::permission_p -object_id $package_id -privilege "admin"]
            if { $admin_p } {
                set repository_id [db_nextval acs_object_id_seq]
                set return_url "[ad_conn package_url]admin/repository-types"
                set href [export_vars -base [ad_conn package_url]admin/repository-ae {repository_id return_url}]
                ad_return_exception_page 200 "Not setup" [subst {Please <a href="[ns_quotehtml $href]">configure
                    this instance of the download module</a>.}]
            } else {
                ad_return_exception_page 200 "Not setup" "Please have an admin configure this instance of the download module."
            }
            ad_script_abort
        }
    } else {
        if { $do_redirect } {
            set repository_id $repository(repository_id)
            set count [db_string type_info {
                select count(*) from download_archive_types where repository_id = :repository_id
            }]
            if { $count == 0 } {
                set return_url "[ad_conn url]?[ad_conn query]"
                set href [export_vars -base [ad_conn package_url]admin/repository-types {repository_id return_url}]
                ad_return_exception_page 200 "Not setup" [subst {Please <a href="[ns_quotehtml $href]">add a download type</a>.}]
                ad_script_abort
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
            append html "<input type=text name=$element_name value=\"[ad_quotehtml $user_value]\" size=10>"
        }
        "integer" {
            append html "<input type=text name=$element_name value=\"[ad_quotehtml $user_value]\" size=10>"
        }
        "shorttext" {
            append html "<input type=text name=$element_name value=\"[ad_quotehtml $user_value]\" size=20>"
        }

        "text" {
            append html "<textarea name=$element_name cols=70 rows=10>$user_value</textarea>"
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
        { revision_id:naturalnum "" }
        { download_id:naturalnum "" }
        { reason_id "" }
        { reason_other ""}
    }

    ns_log Debug "download_file_downloader: downloading $revision_id"

    set user_id [ad_conn user_id]
    set download_ip [ad_conn peeraddr]
    if [catch {
        set download_hostname [ns_hostbyaddr $download_ip]
    }] {
        set download_hostname ""
    }
    set user_agent  [ns_set iget [ad_conn headers] user-agent]

    regexp "[ad_conn package_url]download/(.*)" [ad_conn url] match path

    if {$revision_id eq ""} {
        ad_script_abort
    }

    permission::require_permission -object_id $revision_id -privilege "read"

    ##Record the download for all time!!
    set double_click_p [db_string download_count "select count(*) from download_downloads where download_id = :download_id"]
    if { $double_click_p == 0 } {
        if {[catch {
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
        } errmsg]} {
            ns_log Error "Download: Unable to log download due to an error: $errmsg"
        }
    }

    cr_write_content -revision_id $revision_id

    return filter_return
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
        # date's are complex. convert them first
        if { $data_type eq "date" } {
            if [catch  { set metadata($metadata_id) [validate_ad_dateentrywidget "" metadata.$metadata_id [ns_getform]]} errmsg] {
                if {$required_p == "t"} {
                    ad_complain "$errmsg: Please make sure your dates are valid."
                } else {
                    set metadata($metadata_id) ""
                }
            }
        }
        if { ([info exists metadata($metadata_id)] && $metadata($metadata_id) ne "") } {
            set response_value [string trim $metadata($metadata_id)]
        } elseif {$required_p == "t"} {
            lappend metadata_with_missing_responses $pretty_name
            continue
        } else {
            set response_to_question($metadata_id) ""
            set response_value ""
        }
        if {$response_value ne ""} {
            if { $data_type eq "number" } {
                if { ![regexp {^(-?[0-9]+\.)?[0-9]+$} $response_value] } {

                    ad_complain "The value for \"$metadata\" must be a number. Your value was \"$response_value\"."
                    continue
                }
            } elseif { $data_type eq "integer" } {
                if { ![regexp {^[0-9]+$} $response_value] } {
                    ad_complain "The value for \"$metadata\" must be an integer. Your value was \"$response_value\"."
                    continue
                }
            }
        }


        ns_log Debug "LOGGING: Metadata $pretty_name: $metadata($metadata_id)"
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
    if {![regexp {[^//\\]+$} $upload_file filename]} {
        # no match
        set filename $upload_file
    }

    # get the file_size for the postgres version
    set file_size [file size $tmpfile]

    set mime_type [cr_filename_to_mime_type -create $upload_file]

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

#
# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
