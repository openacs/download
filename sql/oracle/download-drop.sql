--
-- Drop the data model and the PL/SQL packages.
--

/* Drop all content items */
begin
    for archive_rec in (select item_id from cr_items where content_type = 'cr_download_archive_desc')
    loop
        content_item.delete(archive_rec.item_id);
    end loop;
end;
/

begin
    for archive_rec in (select item_id from cr_items where content_type = 'cr_download_archive')
    loop
        content_item.delete(archive_rec.item_id);
    end loop;
end;
/

begin
    for archive_rec in (select item_id from cr_items where content_type = 'cr_download_rep')
    loop
        content_item.delete(archive_rec.item_id);
    end loop;
end;
/

/* Sequences */
drop sequence download_archive_type_seq;
drop sequence download_reasons_seq;
drop sequence download_md_choice_id_sequence;
drop sequence download_downloads_seq;

/* Views */
drop view download_archives_obj;
drop view download_arch_revisions_obj;
drop view download_downloads_repository;

/* Tables */
drop table download_downloads;
drop table download_revision_data;
drop table download_archive_revisions;
drop table download_archives;
drop table download_metadata_choices;
drop table download_archive_metadata;
drop table download_reasons;
drop table download_archive_types;
drop table download_repository;
drop table download_archive_descs;
/* acs_object_type */
begin
  content_type.unregister_child_type(
      parent_type => 'cr_download_rep',
      child_type => 'cr_download_archive',
      relation_tag => 'generic'
  );

  content_type.unregister_child_type(
      parent_type => 'cr_download_rep',
      child_type => 'cr_download_archive_desc',
      relation_tag => 'generic'
  );
end;
/

begin
    acs_object_type.drop_type(
        object_type => 'cr_download_archive_desc',
        cascade_p => 't'
    );
end;
/
show errors

begin
    acs_object_type.drop_type(
        object_type => 'cr_download_rep',
        cascade_p => 't'
    );
end;
/
show errors

begin
    acs_object_type.drop_type(
        object_type => 'cr_download_archive',
        cascade_p => 't'
    );

end;
/
show errors


drop package download_rep;