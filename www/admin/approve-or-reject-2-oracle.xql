<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="version_approve">      
      <querytext>
      
       update download_archive_revisions
         set approved_p = :approved_p,
             approved_comment = :approved_comment,
             approved_user = :user_id,
             approved_date = sysdate
       where revision_id = :revision_id
    
      </querytext>
</fullquery>

 
<fullquery name="sendmail">      
      <querytext>
      
        begin
           :1 := acs_mail_nt.post_request(
                party_from => :user_id,
                party_to => :creation_user,
                expand_group => 'f',
                subject => :subject,
                message => :body);
        end;
    
      </querytext>
</fullquery>

 
</queryset>
