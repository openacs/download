<master>
<property name="title">Add a New Software Archive</property>
<property name="context">@context;noquote@</property>

<form enctype=multipart/form-data method=POST action="archive-version-add-2">
<%= [export_vars -form {archive_id return_url}]%>

<h3>#download.lt_Add_a_New_Archive_Rev#</h3>

<table>
 <tr>
  <th align=right>#download.Version_Number#</th>
  <td><input type=text name=version_name size=20 max_length=20></td>
 </tr>

 @extra_form_elts;noquote@

 <tr>
  <th align=right>#download.File#</th>
  <td><input type=file name=upload_file size=40></td>
 </tr>
 <tr>
 <td>&nbsp;</td>
 <td><font size=-1>#download.lt_Use_the_Browse_button# </font></td>
 </tr>

 <tr><td></td><td colspan=2><input type=submit value="Add Archive">
     </td>
 </tr>

</table>

</form>


