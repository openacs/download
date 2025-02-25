# /packages/download/www/archive-version-add-2.tcl
ad_page_contract {
     Add a new archive and version.
     @author jbank@arsdigita.com [jbank@arsdigita.com]
     @creation-date Tue Dec 12 23:21:40 2000
     @cvs-id $Id$
} {
    upload_file:notnull,trim
    upload_file.tmpfile:tmpfile
    {return_url "[ad_conn package_url]"}
    version_name:notnull
    archive_id:naturalnum,notnull
    metadata:array,optional,multiple,html
} -validate {
    check_metadata -requires { } {
        set archive_type_id [db_string get_archive_type "select archive_type_id from download_archives where archive_id = :archive_id"]
        set repository_id [download::repository_id]
        array set metadata [download::validate_metadata $repository_id [array get metadata] $archive_type_id]
    }
}

##First, do a download_archive.new
##Then do a download_archive_revision.new
##Then insert into the download_revision_data
set repository_id [download::repository_id]
set user_id [ad_conn user_id]
set admin_p [permission::permission_p -object_id $repository_id -privilege admin]

# check for write permission on this folder
permission::require_permission -object_id $archive_id -privilege write

set approved_p [ad_decode $admin_p 0 "" "t"]
set approved_date [ad_decode $admin_p 0 "" "sysdate"]
set approved_user [ad_decode $admin_p 0 "" ":user_id"]
set approved_comment [ad_decode $admin_p 0 "" "Automatic approval, add by admin."]


# get the ip
set creation_ip [ad_conn peeraddr]
set revision_id [db_nextval acs_object_id_seq]

db_transaction {
    download::insert_revision $upload_file ${upload_file.tmpfile} $repository_id $archive_type_id $archive_id $version_name $revision_id $user_id $creation_ip $approved_p [array get metadata]
}

ad_returnredirect $return_url

# Local variables:
#    mode: tcl
#    tcl-indent-level: 4
#    indent-tabs-mode: nil
# End:
