<master src="master">
<property name="title">Add a New Software Archive</property>
<property name="context_bar">@context_bar@</property>

<form enctype=multipart/form-data method=POST action="archive-add-2">
<%= [export_form_vars archive_type_id return_url]%>

<h3>Add a New Software Archive</h3>

<table>
 <tr>
  <th align=right>Software Name:</th>
  <td><input type=text name=archive_name size=40>
  </td>
 </tr>
 <tr>
  <th align=right>Summary:</th>
  <td colspan=2>
     <input type=text name=summary size=60 maxlength=100></td>
 </tr>
 <tr>
  <th align=right valign=top>Description:</th>
  <td><textarea name=description cols=60 rows=6 wrap=soft></textarea></td>
 </tr>
 <tr>
  <th align=right>Description is:</th>
  <td><select name=html_p>
      <option value=f>Plain Text
      <option value=t>HTML
      </select></td>
 </tr>

 @extra_form_elts@

 <tr>
  <th align=right>Version Number (optional):</th>
  <td><input type=text name=version_name size=20 max_length=20></td>
 </tr>

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

