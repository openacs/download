<master src="master">
<property name="title">@archive_name@ Download History</property>
<property name="context_bar">@context_bar@</property>


<ul>
<li><a href=spam-users?@export_sql_query@>Spam Downloaders</a>
<li><a href=export-csv?@export_sql_query@>Export CSV File</a>
</ul>

@dimensional@
<center><b>Total downloads listed: @count@; Overall Total for @archive_name@: @total_count@</b>
</center>
@table@