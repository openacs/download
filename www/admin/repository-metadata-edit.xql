<?xml version="1.0"?>
<queryset>

<fullquery name="metadata_select">      
      <querytext>

    select 
      dam.metadata_id,
      dam.repository_id,
      dam.archive_type_id,
      coalesce(dat.pretty_name, 'All') as archive_name,
      dam.sort_key,
      dam.pretty_name,
      dam.data_type,
      dam.required_p,      
      dam.linked_p,        
      dam.mainpage_p,
      dam.computed_p      
    from download_archive_metadata dam left join download_archive_types dat
      using archive_type_id
    where dam.repository_id = :repository_id and
          dam.metadata_id = :metadata_id 
    order by archive_type_id

      </querytext>
</fullquery>

 
<fullquery name="choices">      
      <querytext>
      
    select label from download_metadata_choices where metadata_id = :metadata_id

      </querytext>
</fullquery>

 
<fullquery name="archiv_types">      
      <querytext>
      
    select pretty_name, archive_type_id from download_archive_types where repository_id = $repository_id
      </querytext>
</fullquery>

 
<fullquery name="metadata_update">      
      <querytext>
      
            update download_archive_metadata set
                  archive_type_id = :archive_type_id,
                  sort_key = :sort_key,
                  pretty_name = :pretty_name,
                  data_type = :data_type,
                  required_p = :required_p,
                  linked_p = :linked_p,
                  mainpage_p = :mainpage_p,
                  computed_p = :computed_p
            where metadata_id = :metadata_id and
                  repository_id = :repository_id 
        
      </querytext>
</fullquery>

 
<fullquery name="choices_delete">      
      <querytext>
      
            delete from download_metadata_choices where metadata_id = :metadata_id
        
      </querytext>
</fullquery>

 
<fullquery name="choice_insert">      
      <querytext>
      
insert into download_metadata_choices (choice_id, metadata_id, label, sort_order)
values (download_md_choice_id_sequence.nextval, :metadata_id, :choice, :count)
                
      </querytext>
</fullquery>

 
</queryset>
