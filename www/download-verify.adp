<master src="master">
<property name="title">Download @archive_name@ @version_name@</property>
<property name="context_bar">@context_bar@</property>

<h3>Download @archive_name@ @version_name@</h3>
<table>
<tr>
<td align=right>File Size:</td> 
<td><b>@file_size@k</b></td>
</tr><tr>
<form method=get action="@action@">
<%= [export_form_vars download_id revision_id] %>
<td align=right>Reason for Download:</td> 
<td>
@reason_widget@
</td>
</tr><tr>
<td align=right>If you have selected "Other"<br> please tell us why:
</td>
<td>
<input type=text name=reason_other size=31></td>
</tr><tr>
<td></td><td><input type=submit value="Submit and download">
</td></tr></table>

<p>

