<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="sendmail">      
<querytext>

select acs_mail_nt__post_request (
    :user_id,    -- p_party_from
    :to_user_id, -- p_party_to
    :subject,    -- p_subject
    :msgbody     -- p_message
);
    
</querytext>
</fullquery>

 
</queryset>
