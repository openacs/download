<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="sendmail">      
      <querytext>
      FIX ME PLSQL - need acs_notification

        begin
           :1 := nt__post_request(
                party_from => :user_id,
                party_to => :to_user_id,
                expand_group => 'f',
                subject => :subject,
                message => :msgbody);
        end;
    
      </querytext>
</fullquery>

 
</queryset>
