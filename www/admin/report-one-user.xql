<?xml version="1.0"?>
<queryset>

<fullquery name="name_select">      
      <querytext>
      select u.last_name, u.first_names
        from cc_users u
        where u.user_id = :user_id 
      </querytext>
</fullquery>

</queryset>
