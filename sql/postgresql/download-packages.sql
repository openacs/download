--
-- packages/sdm/sql/download/download-packages.sql
--
-- 
-- @author Vinod Kurup (vinod@kurup.com)
-- 
-- @cvs-id $Id$
--

--Defines the following packages:
--
-- Download Repository
--   -new
--   -delete
--   -edit
--   -new_archive_type (no need for proc)
--   -delete_archive_type (no need for proc)
--   -edit_archive_type (no need for proc)
--   -new_reason (no need for proc)
--   -delete_reason (no need for proc)
--   -edit_reason (no need for proc)
--   -new_metadata (no need for proc)
--   -delete_metadata (no need for proc)
--   -edit_metadata (no need for proc)
--   -new_metadata_choice (no need for proc)
--   -delete_metadata_choice (no need for proc)
--   -edit_metadata_choice (no need for proc)
--
--
-- Download Archive
--   -new
--   -delete
--   -edit
--   -new_revision
--   -approve_revision
--   -set_metadata_value
--   -downloaded_by

create function download_rep__new (integer,varchar,varchar,varchar,timestamptz,integer,integer,integer,integer,varchar)
returns integer as '
declare
	new__repository_id			alias for $1;
	new__title					alias for $2;
	new__description			alias for $3;
	new__help_text				alias for $4;  -- default null
	new__creation_date			alias for $5;  -- default now()
	new__creation_user			alias for $6;  -- default null
	new__parent_id				alias for $7;  -- default null
	new__context_id				alias for $8;  -- default null
        new__package_id                         alias for $9;  -- default null
	new__creation_ip			alias for $10;  -- default null
    v_name						cr_items.name%TYPE;
    v_repository_id				integer;
	v_revision_id				integer;
begin
    v_name := ''download_repository'' || new__repository_id;
    select into v_repository_id content_item__new (
		v_name,
		new__parent_id,
		new__repository_id,
		null,					-- locale
		new__creation_date,
		new__creation_user,
		new__context_id,
		new__creation_ip,
		''content_item'',		-- item_subtype
		''cr_download_rep'',
		new__title,
		new__description,
		''text/plain'',			-- mime_type
		null,					-- nls_language
		new__help_text,
		''text'',				-- storage_type (vk - not sure about this)
                new__package_id
	);

    insert into download_repository
     (repository_id)
    values
     (new__repository_id);

	 -- get the latest revision
	 select into v_revision_id content_item__get_latest_revision (v_repository_id);

	 -- make it live
	 select into v_revision_id content_item__set_live_revision ( v_revision_id );

    return v_repository_id;

end;' language 'plpgsql';

create function download_rep__edit (integer,varchar,varchar,varchar,timestamptz,integer,varchar)
returns integer as '
declare
    edit__repository_id			alias for $1;
    edit__title					alias for $2;
	edit__description			alias for $3;
	edit__help_text				alias for $4;
    edit__last_modified			alias for $5;
    edit__modifying_user		alias for $6;
    edit__modifying_ip			alias for $7;
    v_revision_id				integer;
begin
	select into v_revision_id content_revision__new (
		edit__title,
		edit__description,
		now(),					-- publish_date
		''text/plain'',			-- mime_type
		null,					-- nls_language
		edit__help_text,
		edit__repository_id,
		null,					-- revision_id
		edit__last_modified,
		edit__modifying_user,
		edit__modifying_ip
    );

	PERFORM content_item__set_live_revision(v_revision_id);

	update acs_objects set 
        last_modified = edit__last_modified,
        modifying_user = edit__modifying_user,
		modifying_ip = edit__modifying_ip
	where object_id = edit__repository_id;

	return 0;
end;' language 'plpgsql';


	  -- removed from below function, cuz it doesn;t work FIXME
		--    update acs_objects 
		--	  set context_id = null 
		--	  where context_id = delete__repository_id;


create function download_rep__delete (integer)
returns integer as '
declare
	delete__repository_id		alias for $1;
begin
	delete from acs_objects where context_id = delete__repository_id;

    delete from download_repository
    where repository_id = delete__repository_id;

    PERFORM acs_object__delete( delete__repository_id );

	return 0;
end;' language 'plpgsql';

