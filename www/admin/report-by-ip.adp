<master>
<property name="doc(title)">#download.Downloads_by_IP#</property>
<property name="context">@context;literal@</property>

<p>
<form method="post" action="spam-users">
  <div>@user_id_list_export;noquote@
  <input type="submit" value="Spam Downloaders" ></div>
</form>

@dimensional_html;literal@
<listtemplate name="ips_list"></listtemplate>
    