--
-- Drop the data model and the PL/SQL packages.
--

/* Drop all content items */

create function inline_0 ()
returns integer as '
declare
	archive_rec			cr_items%ROWTYPE;
begin
	for archive_rec in select item_id from cr_items 
                         where content_type in ( ''cr_download_archive_desc'', 
											     ''cr_download_archive'', 
												 ''cr_download_rep'' ) loop
		PERFORM content_item__delete( archive_rec.item_id );
	end loop;

    return 0;
end;' language 'plpgsql';

select inline_0 ();

drop function inline_0 ();

--begin
--    for archive_rec in (select item_id from cr_items where content_type = 'cr_download_archive_desc')
--    loop
--        content_item.delete(archive_rec.item_id);
--    end loop;
--end;
--/
--
--begin
--    for archive_rec in (select item_id from cr_items where content_type = 'cr_download_archive')
--    loop
--        content_item.delete(archive_rec.item_id);
--    end loop;
--end;
--/
--
--begin
--    for archive_rec in (select item_id from cr_items where content_type = 'cr_download_rep')
--    loop
--        content_item.delete(archive_rec.item_id);
--    end loop;
--end;
--/

/* Sequences */
drop sequence download_archive_type_seq;
drop sequence download_reasons_seq;
drop sequence download_md_choice_id_sequence;
drop sequence download_downloads_seq;

/* Views */
drop view download_repository_obj;
drop view download_archives_obj;
drop view download_arch_revisions_obj;
drop view download_downloads_repository;
--drop view download_archive_descsi;
--drop view download_archive_descsx;

/* Tables */
drop table download_downloads;
drop table download_revision_data;
drop table download_archive_revisions;
--drop table download_archives;
drop table download_metadata_choices;
drop table download_archive_metadata;
drop table download_reasons;
drop table download_archive_types;
--drop table download_repository;
--drop table download_archive_descs;

/* acs_object_type */

create function inline_1 ()
returns integer as '
begin
	PERFORM content_type__unregister_child_type (
      ''cr_download_rep'',
      ''cr_download_archive'',
      ''generic''		
	);

	PERFORM content_type__unregister_child_type (
      ''cr_download_rep'',
      ''cr_download_archive_desc'',
      ''generic''		
	);

	PERFORM content_type__drop_type (
	  ''cr_download_archive_desc'',
	  ''t'',
	  ''t''
	);

	PERFORM content_type__drop_type (
	  ''cr_download_archive'',
	  ''t'',
	  ''f''
	);

	PERFORM content_type__drop_type (
	  ''cr_download_rep'',
	  ''t'',
	  ''f''
	);

    return 0;
end;' language 'plpgsql';

select inline_1 ();

drop function inline_1 ();

--begin
--  content_type.unregister_child_type(
--      parent_type => 'cr_download_rep',
--      child_type => 'cr_download_archive',
--      relation_tag => 'generic'
--  );
--
--  content_type.unregister_child_type(
--      parent_type => 'cr_download_rep',
--      child_type => 'cr_download_archive_desc',
--      relation_tag => 'generic'
--  );
--end;
--/
--
--begin
--    acs_object_type.drop_type(
--        object_type => 'cr_download_archive_desc',
--        cascade_p => 't'
--    );
--end;
--/
--show errors
--
--begin
--    acs_object_type.drop_type(
--        object_type => 'cr_download_rep',
--        cascade_p => 't'
--    );
--end;
--/
--show errors
--
--begin
--    acs_object_type.drop_type(
--        object_type => 'cr_download_archive',
--        cascade_p => 't'
--    );
--
--end;
--/
--show errors
--

drop function download_rep__new (integer,varchar,varchar,varchar,timestamp,integer,integer,integer,varchar);
drop function download_rep__edit (integer,varchar,varchar,varchar,timestamp,integer,varchar);
drop function download_rep__delete (integer);

--drop package download_rep;
