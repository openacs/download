<?xml version="1.0"?>

<queryset>
   <rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="sendmail">      
      <querytext>
      
        begin
           :1 := nt.post_request(
                party_from => :user_id,
                party_to => :to_user_id,
                expand_group => 'f',
                subject => :subject,
                message => :msgbody);
        end;
    
      </querytext>
</fullquery>

 
</queryset>
