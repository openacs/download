<master src="master">
<property name="title">One Archive: @archive_name@</property>
<property name="context_bar">@context_bar@</property>

<table align=center>
 <tr><th colspan=2><font size=+1>@archive_name@</font></th>
 <tr><td align=right>Created by:</td>
     <td><a href=/shared/community-member?user_id=@creation_user@>@creation_user_name@</a> on @creation_date@</td>
 </tr>
 <tr><td align=right valign=top>Summary:</td>
     <td>@summary@</td>
 </tr>
 <tr><td align=right valign=top>Description:</td>
     <td>@description@</td>
 </tr>

<if @admin_p@ eq 1>
 <tr><td align=right valign=top><a href=admin/report-version-downloads?archive_id=@archive_id@&versions=current>View Download History</a>
 </tr>
 <tr><td align=right valign=top><p><a href=/permissions/one?object_id=@archive_id@><b>Edit Permissions on this Archive</b></a> 
     <td> <font size=-1>(<a href=help#permissions>permission descriptions</a>)</font>
 </tr>
</if>

<tr>
<td align=right valign=top><h4>Versions:</h4>
<td>
<if @pending_count@ gt 0>
  <li>@pending_count@ pending approval.
</if>
<multiple name=revisions>
  <li><a href=one-revision?revision_id=@revisions.revision_id@>@archive_name@ @revisions.version_name@</a>
    <a href=download-verify?revision_id=@revisions.revision_id@>(download)</a> <br>
    Created by <a href=/shared/community-member?user_id=@revisions.creation_user@>@revisions.creation_user_name@</a> on @revisions.creation_date@

</multiple>

<if @write_p@ eq 1>
<p><li><a href=archive-version-add?archive_id=@archive_id@>add a version</a>
</if>
</tr>
</table>

<p>
<center>
@gc_link@
<p>
@gc_comments@
</center>
