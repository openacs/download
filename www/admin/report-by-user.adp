<master>
<property name="doc(title)">#download.Downloads_by_User#</property>
<property name="context">@context;noquote@</property>

<p>
<form method="post" action="spam-users">
<div>
  @user_id_list_export;noquote@
  <input type="submit" value="Spam Downloaders" >
</div>  
</form>


@dimensional_html;literal@
<listtemplate name="users_list"></listtemplate>
