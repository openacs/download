<master>
<property name="doc(title)">Downloads by IP @download_ip;noquote@</property>
<property name="context">@context;literal@</property>

<p>
<form method="post" action="spam-users">
  @user_id_list_export;noquote@
  <input type="submit" value="Spam Downloaders" />
</form>
</p>

@dimensional_html;noquote@

<listtemplate name="history_list"></listtemplate>