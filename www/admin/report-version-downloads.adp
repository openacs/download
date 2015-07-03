<master>
<property name="doc(title)">@archive_name;noquote@ Download History</property>
<property name="context">@context;literal@</property>

<p>
<form method="post" action="spam-users">
  @user_id_list_export;noquote@
  <input type="submit" value="Spam Downloaders" />
</form>
</p>

@dimensional_html;noquote@
<center><strong>#download.lt_Total_downloads_liste#</strong>
</center>
<listtemplate name="download_list"></listtemplate>
