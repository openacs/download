<master>
<property name="doc(title)">One Archive: @archive_name;noquote@</property>
<property name="context">@context;literal@</property>

<if @master_admin_p@ eq 1>
<table align="right"><tr><td><a href="admin/">#download.Administration#</a></td></tr></table>
</if>
<table align="right"><tr><td><a href="help">#download.Help#</a></td></tr></table>

<table align="center">
 <tr><th colspan="2"><big>@archive_name@</big></th></tr>
 <tr>
     <td align="right">#download.Created_by#</td>
     <td><a href="/shared/community-member?user_id=@creation_user@">@creation_user_name@</a> #download.on_creation_date#</td>
 </tr>
 <tr>
     <td align="right" valign="top">#download.Summary#</td>
     <td>@summary@</td>
 </tr>
 <tr>
     <td align="right" valign="top">#download.Description#</td>
     <td>@description;noquote@</td>
 </tr>

 <if @admin_p@ eq 1>
 <tr>
     <td align="right" valign="top"><a href="admin/report-version-downloads?archive_id=@archive_id@&versions=current">#download.lt_View_Download_History#</a>
 </tr>
 <tr>
     <td align="right" valign="top"><p><a href="/permissions/one?object_id=@archive_id@"><strong>#download.lt_Edit_Permissions_on_t#</strong></a> 
     <td> <font size=-1>(<a href="help#permissions">#download.lt_permission_descriptio#</a>)</font>
 </tr>
</if>

<tr>
<td align="right" valign="top">#download.Versions#
<td>
<multiple name=revisions>
    <a href="one-revision?revision_id=@revisions.revision_id@">@archive_name@ @revisions.version_name@</a>
    <a href="download-verify?revision_id=@revisions.revision_id@">#download.download#</a> <br />
    #download.Created_by_1# <a href="/shared/community-member?user_id=@revisions.creation_user@">@revisions.creation_user_name@</a> #download.on# <nobr>@revisions.creation_date@</nobr>
    <br /><br />
</multiple>
<if @pending_count@ gt 0>
  #download.lt_pending_count_pending#
</if>
<if @write_p@ eq 1>
<p><li><a href="archive-version-add?archive_id=@archive_id@">#download.add_a_version#</a>
</if>
</tr>
</table>

<p>
<center>
@gc_link;noquote@
<p>
@gc_comments;noquote@
</center>

