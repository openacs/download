<master>
<property name="title">Add a New Software Archive</property>
<property name="context">@context;noquote@</property>

<form enctype=multipart/form-data method=POST action="archive-add-2">
<%= [export_form_vars archive_type_id return_url]%>

<h3>#download.lt_Add_a_New_Software_Ar#</h3>

<table>
 <tr>
  <th align=right>#download.Software_Name#</th>
  <td><input type=text name=archive_name size=40>
  </td>
 </tr>
 <tr>
  <th align=right>#download.Summary#</th>
  <td colspan=2>
     <input type=text name=summary size=60 maxlength=100></td>
 </tr>
 <tr>
  <th align=right valign=top>#download.Description#</th>
  <td><textarea name=description cols=60 rows=6 wrap=soft></textarea></td>
 </tr>
 <tr>
  <th align=right>#download.Description_is#</th>
  <td><select name=html_p>
      <option value=f>#download.Plain_Text#
      <option value=t>#download.HTML#
      </select></td>
 </tr>

 @extra_form_elts@

 <tr>
  <th align=right>#download.lt_Version_Number_option#</th>
  <td><input type=text name=version_name size=20 max_length=20></td>
 </tr>

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


