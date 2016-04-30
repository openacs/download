--
-- packages/sdm/sql/download/download-drop.sql
--
-- 
-- @author Vinod Kurup (vinod@kurup.com)
-- 
-- @cvs-id $Id$
--

--
-- Drop the data model and the PL/SQL packages.
--

delete from download_archives;

-- Views --
drop view download_repository_obj;
drop view download_archives_obj;
drop view download_arch_revisions_obj;
drop view download_downloads_repository;

-- Sequences --

drop sequence download_reasons_sequence;
drop sequence download_md_choice_id_seq;
drop view download_md_choice_id_sequence;
drop sequence download_downloads_seq;
drop view download_downloads_sequence;

-- Functions --
drop function download_rep__new (integer,varchar,varchar,varchar,timestamptz,integer,integer,integer,varchar);
drop function download_rep__edit (integer,varchar,varchar,varchar,timestamptz,integer,varchar);
drop function download_rep__delete (integer);

-- Tables --
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

/* Drop all content items */

create function inline_0 ()
returns integer as '
declare
	archive_rec			record;
begin
	for archive_rec in select item_id from cr_items 
                         where content_type in ( ''cr_download_archive'', 
											     ''cr_download_archive_desc'', 
												 ''cr_download_rep'' )  order by item_id desc  loop
		PERFORM content_item__delete( archive_rec.item_id );
	end loop;

    return 0;
end;' language 'plpgsql';

select inline_0 ();

drop function inline_0 ();

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
	  ''t''
	);

	PERFORM content_type__drop_type (
	  ''cr_download_rep'',
	  ''t'',
	  ''t''
	);

    return 0;
end;' language 'plpgsql';

select inline_1 ();

drop function inline_1 ();

