# /packages/download/www/archive-add-2.tcl
ad_page_contract {
     Add a new archive and version.
     @author jbank@arsdigita.com [jbank@arsdigita.com]
     @creation-date Tue Dec 12 23:21:40 2000
     @cvs-id $Id$
} {
    upload_file:notnull,trim
    upload_file.tmpfile:tmpfile
    {return_url "[ad_conn package_url]"}
    archive_type_id:integer,notnull
    archive_name:notnull
    {version_name ""}
    summary:notnull
    description:notnull,html
    html_p
    metadata:array,optional,html
} -validate {
    check_metadata -requires { archive_type_id } {
        set repository_id [download_repository_id]
        array set metadata [download_validate_metadata $repository_id [array get metadata] $archive_type_id]
    }
}

##First, do a download_archive.new
##Then do a download_archive_revision.new
##Then insert into the download_revision_data
set user_id [ad_conn user_id]
set package_id [ad_conn package_id]
set admin_p [ad_permission_p $repository_id admin]

# check for write permission on this repository
ad_require_permission $repository_id write

set approved_p [ad_decode $admin_p 0 [db_null] "t"]
set approved_date [ad_decode $admin_p 0 [db_null] "sysdate"]
set approved_user [ad_decode $admin_p 0 [db_null] ":user_id"]
set approved_comment [ad_decode $admin_p 0 [db_null] "Automatic approval, add by admin."]

# get the ip
set creation_ip [ad_conn peeraddr]

set archive_id [db_nextval acs_object_id_seq]
set archive_desc_id [db_nextval acs_object_id_seq]
set revision_id [db_nextval acs_object_id_seq]

if { $html_p == "f" } {
    set description_format "text/plain"
} else {
    set description_format "text/html"
}

db_transaction {
    db_exec_plsql archive_new {
        declare
          v_archive_id integer;
          v_archive_desc_id integer;
          v_name       cr_items.name%TYPE;
        begin
          v_name := 'Download Archive Desc for ' || :archive_id;

          v_archive_desc_id := content_item.new (
           content_type => 'cr_download_archive_desc',
           item_id => :archive_desc_id,
           name => v_name,
           title => :summary,
           description => :description,
           mime_type => :description_format,
           parent_id => :repository_id,
           context_id => :repository_id,
           creation_user => :user_id,
           creation_ip => :creation_ip,
           is_live => 't'
          );
          insert into download_archive_descs (archive_desc_id) values (content_item.get_live_revision(v_archive_desc_id));

          v_archive_id := content_item.new(
           content_type => 'cr_download_archive',
           item_id => :archive_id,
           name => :archive_name,
           parent_id => :repository_id,
           context_id => :repository_id,
           creation_user => :user_id,
           creation_ip => :creation_ip
          );

          insert into download_archives (archive_id, archive_type_id, archive_desc_id) values (v_archive_id, :archive_type_id, content_item.get_live_revision(v_archive_desc_id));
        end;
    }

    download_insert_revision $upload_file ${upload_file.tmpfile} $repository_id $archive_type_id $archive_id $version_name $revision_id $user_id $creation_ip $approved_p [array get metadata]

}

ad_returnredirect $return_url
