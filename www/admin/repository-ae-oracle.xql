<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="todo_insert">      
      <querytext>
      
         declare
          the_id integer;
         begin
          the_id := download_rep.new(repository_id  => :repository_id,
                             title => :title,
                             description => :description,
                             help_text => :help_text,
                             creation_user => :user_id,
                             parent_id => :package_id,
                             package_id => :package_id,
                             context_id => :package_id);
                    end;
        
      </querytext>
</fullquery>

 
<fullquery name="repository_edit">      
      <querytext>
      
             begin
                download_rep.edit(repository_id  => :repository_id,
                                         title => :title,
                                         description => :description,
                                         help_text => :help_text,
                                  modifying_user => :user_id
                );
             end;
        
      </querytext>
</fullquery>

 
</queryset>
