<?xml version="1.0"?>
<queryset>


<fullquery name="download_repository_info.repository_info">
<querytext>

select repository_id, title, description, help_text 
from download_repository_obj 
where parent_id = :package_id

</querytext>
</fullquery>

 

<fullquery name="download_repository_info.type_info">
<querytext>

select count(*) from download_archive_types 
where repository_id = :repository_id
            
</querytext>
</fullquery>

 

<fullquery name="download_metadata_widget.download_metadata_choices">
<querytext>

select choice_id, label
from download_metadata_choices
where metadata_id = :metadata_id
order by sort_order

</querytext>
</fullquery>

<fullquery name="download_file_downloader.download_count">
<querytext>

select count(*) from download_downloads 
where download_id = :download_id

</querytext>
</fullquery>

<fullquery name="download_maybe_create_new_mime_type.mime_type_exists">
<querytext>
      
select count(*) from cr_mime_types
where  mime_type = :mime_type

</querytext>
</fullquery>


 
<fullquery name="download_maybe_create_new_mime_type.new_mime_type">      
<querytext>
      
insert into cr_mime_types
(mime_type, file_extension)
values
(:mime_type, :extension)

</querytext>
</fullquery>


 
<fullquery name="download_validate_metadata.metadata">      
<querytext>
      
select 
  dam.metadata_id,
  dam.pretty_name,
  dam.data_type,
  dam.required_p
from download_archive_metadata dam
where dam.repository_id = :repository_id and
      dam.computed_p = 'f' and
      (dam.archive_type_id = :archive_type_id or
       dam.archive_type_id is null)
order by sort_key
    
</querytext>
</fullquery>


 
<fullquery name="download_insert_metadata.survsimp_question_info_list">      
<querytext>
      
select 
  dam.metadata_id,
  dam.data_type
from download_archive_metadata dam
where dam.repository_id = :repository_id and
      dam.computed_p = 'f' and
      (dam.archive_type_id = :archive_type_id or
       dam.archive_type_id is null)
order by sort_key
    
</querytext>
</fullquery>

 

<fullquery name="download_insert_metadata.metadata_inserts">      
<querytext>
      
insert into download_revision_data
(revision_id, metadata_id, $answer_column)
values 
( :revision_id, :metadata_id, :response )
        
</querytext>
</fullquery>


 
</queryset>

