<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="todo_insert">      
      <querytext>
      FIX ME PLSQL

         declare
          the_id integer;
         begin
          the_id := download_rep__new(repository_id  => :repository_id,
                             title => :title,
                             description => :description,
                             help_text => :help_text,
                             creation_user => :user_id,
                             parent_id => :package_id,
                             context_id => :package_id);
                    end;
        
      </querytext>
</fullquery>

 
<fullquery name="repository_edit">      
      <querytext>
      
             begin
                download_rep__edit(repository_id  => :repository_id,
                                         title => :title,
                                         description => :description,
                                         help_text => :help_text,
                                  modifying_user => :user_id
                );
             end;
        
      </querytext>
</fullquery>

 
</queryset>
