<master>
<property name="title">Downloads by User</property>
<property name="context">@context;noquote@</property>

<p>
<form method="post" action="spam-users">
  @user_id_list_export;noquote@
  <input type="submit" value="Spam Downloaders" />
</form>
</p>

@dimensional_html;noquote@
@table;noquote@