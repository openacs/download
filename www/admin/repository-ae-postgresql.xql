<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="todo_insert">      
      <querytext>
          select download_rep__new(
			:repository_id,
			:title,
			:description,
			:help_text,
			now(),
			:user_id,
			:package_id,
			:package_id,
			null
		  );
      </querytext>
</fullquery>

 
<fullquery name="repository_edit">      
      <querytext>
                select download_rep__edit(
				  :repository_id,
                  :title,
                  :description,
                  :help_text,
                  now(),
				  :user_id,
				  null
                );
      </querytext>
</fullquery>

 
</queryset>
