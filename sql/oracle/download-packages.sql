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

create or replace package download_rep as

  function new (
    repository_id	in acs_objects.object_id%TYPE,
    title               in cr_revisions.title%TYPE,
    description         in cr_revisions.description%TYPE,
    help_text           in varchar2 default null,
    creation_date	in acs_objects.creation_date%TYPE default sysdate,
    creation_user	in acs_objects.creation_user%TYPE default null,
    parent_id           in cr_items.parent_id%TYPE default null,
    context_id          in acs_objects.context_id%TYPE default null,
    creation_ip	        in acs_objects.creation_ip%TYPE default null
  ) return download_repository.repository_id%TYPE;

  procedure edit (
    repository_id	in acs_objects.object_id%TYPE,
    title               in cr_revisions.title%TYPE,
    description         in cr_revisions.description%TYPE,
    help_text           in varchar2 default null,
    last_modified    in acs_objects.last_modified%TYPE default sysdate,
    modifying_user   in acs_objects.modifying_user%TYPE default null,
    modifying_ip     in acs_objects.modifying_ip%TYPE default null
  );

  procedure del (
    repository_id      in acs_objects.object_id%TYPE
  ); 

end download_rep;
/
show errors


create or replace package body download_rep as

  function new (
    repository_id	in acs_objects.object_id%TYPE,
    title               in cr_revisions.title%TYPE,
    description         in cr_revisions.description%TYPE,
    help_text           in varchar2 default null,
    creation_date	in acs_objects.creation_date%TYPE default sysdate,
    creation_user	in acs_objects.creation_user%TYPE default null,
    parent_id           in cr_items.parent_id%TYPE default null,
    context_id          in acs_objects.context_id%TYPE default null,
    creation_ip	        in acs_objects.creation_ip%TYPE default null
  ) return download_repository.repository_id%TYPE
  is
    v_name       cr_items.name%TYPE;
    v_repository_id integer;
  begin
    v_name := 'download_repository' || repository_id;
    v_repository_id := content_item.new (
      content_type => 'cr_download_rep',
      item_id => new.repository_id,
      name => v_name,
      parent_id => new.parent_id,
      context_id => new.context_id,
      title => new.title,
      description => new.description,
      text => new.help_text,
      creation_date => new.creation_date,
      creation_user => new.creation_user,
      creation_ip => new.creation_ip,
      is_live => 't'
    );

    insert into download_repository
     (repository_id)
    values
     (new.repository_id);

    return v_repository_id;
  end new;           

  procedure edit (
    repository_id	in acs_objects.object_id%TYPE,
    title               in cr_revisions.title%TYPE,
    description         in cr_revisions.description%TYPE,
    help_text           in varchar2 default null,
    last_modified    in acs_objects.last_modified%TYPE default sysdate,
    modifying_user   in acs_objects.modifying_user%TYPE default null,
    modifying_ip     in acs_objects.modifying_ip%TYPE default null
  )
  is
    v_revision_id integer;
  begin
      v_revision_id := content_revision.new (
          item_id => edit.repository_id,
          title => edit.title,
          description => edit.description,
          text => edit.help_text,
          creation_date => edit.last_modified,
          creation_user => edit.modifying_user,
          creation_ip => edit.modifying_ip
    );
    content_item.set_live_revision(v_revision_id);


      update acs_objects set 
        last_modified = edit.last_modified,
        modifying_user = edit.modifying_user,
	modifying_ip = edit.modifying_ip
        where object_id = edit.repository_id;

  end edit;


  procedure del (
    repository_id      in acs_objects.object_id%TYPE
  ) 
  is
  begin
    update acs_objects set context_id = null where context_id = download_rep.del.repository_id;

    delete from download_repository
    where repository_id = download_rep.del.repository_id;

    acs_object.del(repository_id);
  end;

end download_rep;
/
show errors
