<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="version_approve">      
      <querytext>
      
       update download_archive_revisions
         set approved_p = :approved_p,
             approved_comment = :approved_comment,
             approved_user = :user_id,
             approved_date = current_timestamp
       where revision_id = :revision_id
    
      </querytext>
</fullquery>

 
<fullquery name="sendmail">      
      <querytext>
      FIX ME PLSQL

        begin
           :1 := nt__post_request(
                party_from => :user_id,
                party_to => :creation_user,
                expand_group => 'f',
                subject => :subject,
                message => :body);
        end;
    
      </querytext>
</fullquery>

 
</queryset>
