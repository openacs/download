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

create function download_rep__new (integer,varchar,varchar,varchar,timestamp,integer,integer,integer,varchar)
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
	new__creation_ip			alias for $9;  -- default null
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
		''text''				-- storage_type (vk - not sure about this)
	);

    insert into download_repository
     (repository_id)
    values
     (new__repository_id);

	 -- get the latest revision
	 select content_item__get_latest_revision ( v_repository_id ) 
			into v_revision_id;

	 -- make it live
	 select content_item__set_live_revision ( v_revision_id );

    return v_repository_id;

end;' language 'plpgsql';

create function download_rep__edit (integer,varchar,varchar,varchar,timestamp,integer,varchar)
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

--create or replace package download_rep as
--
--  function new (
--    repository_id	in acs_objects.object_id%TYPE,
--    title               in cr_revisions.title%TYPE,
--    description         in cr_revisions.description%TYPE,
--    help_text           in varchar2 default null,
--    creation_date	in acs_objects.creation_date%TYPE default sysdate,
--    creation_user	in acs_objects.creation_user%TYPE default null,
--    parent_id           in cr_items.parent_id%TYPE default null,
--    context_id          in acs_objects.context_id%TYPE default null,
--    creation_ip	        in acs_objects.creation_ip%TYPE default null
--  ) return download_repository.repository_id%TYPE;
--
--  procedure edit (
--    repository_id	in acs_objects.object_id%TYPE,
--    title               in cr_revisions.title%TYPE,
--    description         in cr_revisions.description%TYPE,
--    help_text           in varchar2 default null,
--    last_modified    in acs_objects.last_modified%TYPE default sysdate,
--    modifying_user   in acs_objects.modifying_user%TYPE default null,
--    modifying_ip     in acs_objects.modifying_ip%TYPE default null
--  );
--
--  procedure delete (
--    repository_id      in acs_objects.object_id%TYPE
--  ); 
--
--end download_rep;
--/
--show errors
--
--
--create or replace package body download_rep as
--
--  function new (
--    repository_id	in acs_objects.object_id%TYPE,
--    title               in cr_revisions.title%TYPE,
--    description         in cr_revisions.description%TYPE,
--    help_text           in varchar2 default null,
--    creation_date	in acs_objects.creation_date%TYPE default sysdate,
--    creation_user	in acs_objects.creation_user%TYPE default null,
--    parent_id           in cr_items.parent_id%TYPE default null,
--    context_id          in acs_objects.context_id%TYPE default null,
--    creation_ip	        in acs_objects.creation_ip%TYPE default null
--  ) return download_repository.repository_id%TYPE
--  is
--    v_name       cr_items.name%TYPE;
--    v_repository_id integer;
--  begin
--    v_name := 'download_repository' || repository_id;
--    v_repository_id := content_item.new (
--      content_type => 'cr_download_rep',
--      item_id => new.repository_id,
--      name => v_name,
--      parent_id => new.parent_id,
--      context_id => new.context_id,
--      title => new.title,
--      description => new.description,
--      text => new.help_text,
--      creation_date => new.creation_date,
--      creation_user => new.creation_user,
--      creation_ip => new.creation_ip,
--      is_live => 't'
--    );
--
--    insert into download_repository
--     (repository_id)
--    values
--     (new.repository_id);
--
--    return v_repository_id;
--  end new;           
--
--  procedure edit (
--    repository_id	in acs_objects.object_id%TYPE,
--    title               in cr_revisions.title%TYPE,
--    description         in cr_revisions.description%TYPE,
--    help_text           in varchar2 default null,
--    last_modified    in acs_objects.last_modified%TYPE default sysdate,
--    modifying_user   in acs_objects.modifying_user%TYPE default null,
--    modifying_ip     in acs_objects.modifying_ip%TYPE default null
--  )
--  is
--    v_revision_id integer;
--  begin
--      v_revision_id := content_revision.new (
--          item_id => edit.repository_id,
--          title => edit.title,
--          description => edit.description,
--          text => edit.help_text,
--          creation_date => edit.last_modified,
--          creation_user => edit.modifying_user,
--          creation_ip => edit.modifying_ip
--    );
--    content_item.set_live_revision(v_revision_id);
--
--
--      update acs_objects set 
--        last_modified = edit.last_modified,
--        modifying_user = edit.modifying_user,
--	modifying_ip = edit.modifying_ip
--        where object_id = edit.repository_id;
--
--  end edit;
--
--
--  procedure delete (
--    repository_id      in acs_objects.object_id%TYPE
--  ) 
--  is
--  begin
--    update acs_objects set context_id = null where context_id = download_rep.delete.repository_id;
--
--    delete from download_repository
--    where repository_id = download_rep.delete.repository_id;
--
--    acs_object.delete(repository_id);
--  end;
--
--end download_rep;
--/
--show errors
