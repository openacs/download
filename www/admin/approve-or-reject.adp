<master src="master">
<property name="title">@pretty_noun@ @archive_name@ @version_name@</property>

  <table>
  <form action=approve-or-reject-2.tcl>
  <%=  [export_form_vars return_url action revision_id] %>
  <tr><td colspan=2 align=right>
      [<a href=revision-audit?revision_id=@revision_id@>Version History</a>]</td>
  </tr>
  <tr><th colspan=2>
      <font size=+1><a href=../download-verify?revision_id=@revision_id@>@archive_name@</a></font> 
      <if @current_version_p@ eq "t"> (current version)
      </if>
  <tr><td colspane=2></td>
  </tr>
  <tr><td align=right>Created by:</td>
      <td><a href=/shared/community-member?user_id=@creation_user@>@creation_user_name@</a> on @creation_date@</td>
  </tr>
  <tr><td align=right>Reason for @pretty_noun@: </td>
      <td><textarea cols=40 rows=4 name=approved_comment></textarea></td>
  </tr>
  <tr><th colspan=2><input type=submit value=@pretty_action@></th>
  </tr>
  </form>
</table>
