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

		declare
			v_id   integer;
        begin
          v_id := acs_mail_nt__post_request(
                :user_id,           -- p_party_from
                :creation_user,     -- p_party_to
                'f',                -- p_expand_group
                :subject,           -- p_subject
                :message,           -- p_message
                0                   -- p_max_retries
          );

		  return v_id;
        end;
    
      </querytext>
</fullquery>

 
</queryset>
