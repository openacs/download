<master>
<property name="title">@archive_name@ Download History</property>
<property name="context">@context@</property>

<p>
<form method="post" action="spam-users">
  @user_id_list_export@
  <input type="submit" value="Spam Downloaders" />
</form>
</p>

@dimensional_html@
<center><strong>Total downloads listed: @current_count@; Overall Total for @archive_name@: @total_count@</strong>
</center>
@table@