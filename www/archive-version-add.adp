<master src="master">
<property name="title">Add a New Software Archive</property>
<property name="context_bar">@context_bar@</property>

<form enctype=multipart/form-data method=POST action="archive-version-add-2">
<%= [export_form_vars archive_id return_url]%>

<h3>Add a New Archive Revision to @archive_name@</h3>

<table>
 <tr>
  <th align=right>Version Number:</th>
  <td><input type=text name=version_name size=20 max_length=20></td>
 </tr>

 @extra_form_elts@

 <tr>
  <th align=right>File:</th>
  <td><input type=file name=upload_file size=40></td>
 </tr>
 <tr>
 <td>&nbsp;</td>
 <td><font size=-1>Use the "Browse..." button to locate your file, 
    then click "Open". </font></td>
 </tr>

 <tr><td></td><td colspan=2><input type=submit value="Add Archive">
     </td>
 </tr>

</table>

</form>

