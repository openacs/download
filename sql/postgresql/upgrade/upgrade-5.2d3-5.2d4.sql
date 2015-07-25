create or replace view download_repository_obj as
select repository_id, 
                 o.object_id, o.object_type, o.title as obj_title, o.package_id as obj_package_id, o.context_id,
                 o.security_inherit_p, o.creation_user, o.creation_date, o.creation_ip, o.last_modified, o.modifying_user,
                 o.modifying_ip, 
                  i.parent_id, 
                          r.title, 
                          r.description, 
                          r.content as help_text
       from download_repository dr, acs_objects o, cr_items i, cr_revisions r
           where dr.repository_id = o.object_id
	   and i.item_id = o.object_id
	   and r.revision_id = i.live_revision;

create or replace view download_arch_revisions_obj as
select dar.*, 
                          o.object_id, o.object_type, o.title as obj_title, o.package_id as obj_package_id, o.context_id,
                          o.security_inherit_p, o.creation_user, o.creation_date, o.creation_ip, o.last_modified, o.modifying_user,
                          o.modifying_ip, 
                          r.item_id as archive_id, 
                          r.title as file_name, 
                          r.description as version_name, 
                          r.publish_date, 
                          r.mime_type, 
                          r.content
       from download_archive_revisions dar, acs_objects o, cr_revisions r
           where dar.revision_id = o.object_id
	   and   dar.revision_id = r.revision_id;
