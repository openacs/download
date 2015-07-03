<master>
<property name="doc(title)">@pretty_noun;noquote@ @archive_name;noquote@ @version_name;noquote@</property>
<property name="context">@pretty_noun;literal@</property>

  <table>
  <form action=approve-or-reject-2.tcl>
  <%=  [export_vars -form {return_url action revision_id}] %>
  <tr><td colspan="2" align="right">
      [<a href="../one-archive?archive_id=@archive_id@">#download.Version_History#</a>]</td>
  </tr>
  <tr><th colspan="2">
      <font size=+1><a href="../one-revision?revision_id=@revision_id@">@archive_name@</a></font> 
      <if @current_version_p@ eq "t"> (current version)
      </if>
  <tr><td colspane=2></td>
  </tr>
  <tr><td align="right">#download.Created_by#</td>
      <td><a href="/shared/community-member?user_id=@creation_user@">@creation_user_name@</a> #download.on_creation_date#</td>
  </tr>
  <tr><td align="right">#download.lt_Reason_for_pretty_nou# </td>
      <td><textarea cols=40 rows=4 name=approved_comment></textarea></td>
  </tr>
  <tr><th colspan="2"><input type="submit" value="@pretty_action@"></th>
  </tr>
  </form>
</table>

