<?xml version="1.0"?>
<queryset>

<fullquery name="archiv_types">      
      <querytext>
      
    select pretty_name, archive_type_id from download_archive_types where repository_id = $repository_id
      </querytext>
</fullquery>

 
<fullquery name="metadata_insert">      
      <querytext>
      
            insert into download_archive_metadata (
              metadata_id,
              repository_id, 
              archive_type_id,
              sort_key,
              pretty_name,
              data_type,
              required_p,
              linked_p,
              mainpage_p,
              computed_p)
            values (
              :metadata_id,
              :repository_id, 
              :archive_type_id,
              :sort_key,
              :pretty_name,
              :data_type,
              :required_p,
              :linked_p,
              :mainpage_p,
              :computed_p)
        
      </querytext>
</fullquery>

 
<fullquery name="choice_insert">      
      <querytext>
      
                    insert into download_metadata_choices (choice_id, metadata_id, label, sort_order)
                    values (download_md_choice_id_sequence.nextval, :metadata_id, :choice, :count)
                
      </querytext>
</fullquery>

 
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
         where dam.repository_id = :repository_id 
    order by archive_type_id, sort_key

      </querytext>
</fullquery>

 
</queryset>
