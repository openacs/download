<?xml version="1.0"?>
<queryset>

<fullquery name="user_select">      
      <querytext>
      select u.email, 
             u.user_id, 
             u.last_name || ', ' || u.first_names as user_name 
        from cc_users u, user_preferences up
        where u.user_id in ([join $user_id_list ,]) and
              u.user_id = up.user_id and
              up.dont_spam_me_p = 'f'
      </querytext>
</fullquery>

 
</queryset>
