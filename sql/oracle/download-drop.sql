--
-- Drop the data model and the PL/SQL packages.
--

-- delete the archives
delete from download_archives;
delete from download_archive_types;

/* Drop all content items */
begin
    for archive_rec in (select item_id from cr_items where content_type = 'cr_download_archive_desc')
    loop
        content_item.delete(archive_rec.item_id);
    end loop;
end;
/
show errors

begin
    for archive_rec in (select item_id from cr_items where content_type = 'cr_download_archive')
    loop
        content_item.delete(archive_rec.item_id);
    end loop;
end;
/
show errors

begin
    for archive_rec in (select item_id from cr_items where content_type = 'cr_download_rep')
    loop
        content_item.delete(archive_rec.item_id);
    end loop;
end;
/
show errors

/* Sequences */
drop sequence download_archive_type_sequence;
drop sequence download_reasons_sequence;
drop sequence download_md_choice_id_sequence;
drop sequence download_downloads_sequence;

/* Views */
drop view download_archives_obj;
drop view download_arch_revisions_obj;
drop view download_downloads_repository;

/* Tables */
drop table download_downloads;
drop table download_revision_data;
drop table download_archive_revisions;
drop table download_metadata_choices;
drop table download_archive_metadata;
drop table download_reasons;

-- shouldn't drop these tables.
-- they're dropped when we drop the content types below

--drop table download_repository;
--drop table download_archive_descs;
--drop table download_archives;

--unregister the content_types
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
show errors

begin
	content_type.drop_type (
		content_type => 'cr_download_archive_desc',
		drop_children_p => 't',
		drop_table_p => 't'
	);

	content_type.drop_type (
		content_type => 'cr_download_archive',
		drop_children_p => 't',
		drop_table_p => 't'
	);
end;
/
show errors

-- need to drop this table here
drop table download_archive_types;

begin
	content_type.drop_type (
		content_type => 'cr_download_rep',
		drop_children_p => 't',
		drop_table_p => 't'
	);
end;
/
show errors

drop package download_rep;
