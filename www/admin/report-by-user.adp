<master>
<property name="doc(title)">#download.Downloads_by_User#</property>
<property name="context">@context;noquote@</property>

<p>
<form method="post" action="spam-users">
  @user_id_list_export;noquote@
  <input type="submit" value="Spam Downloaders" />
</form>
</p>

@dimensional_html;noquote@
<listtemplate name="users_list"></listtemplate>
