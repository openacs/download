<master>
<property name="doc(title)">One Revision: @archive_name;noquote@ ver. @version_name;noquote@</property>
<property name="context">@context;noquote@</property>

<if @master_admin_p@ eq 1>
<table align="right"><tr><td><a href="admin/">#download.Administration#</a></td></tr></table>
</if>
<table align="right"><tr><td><a href="help">#download.Help#</a></td></tr></table>
<table align="center">
 <tr><th colspan="2"><big>@archive_name@</big></th></tr>
<if @version_name@ ne "">
 <tr><td colspan="2" align="center"><strong>#download.version_version_name#</strong></td></tr>
</if>
 <tr><td colspan="2" align="center">
                   [<a href="download-verify?revision_id=@revision_id@">#download.Download_Now#</a>]
                   [<a href="one-archive?<%= [export_vars -url {archive_id }]%>">#download.See_All_Versions#</a>]<br>&nbsp;</td>
 </tr>
 <tr><td align="right" valign="top"><p>#download.Summary#</td>
     <td>@summary@</td>
 </tr>
 <tr><td align="right" valign="top">#download.Description#</td>
     <td>@description;noquote@</td>
 </tr>
<if @admin_p@ eq 1>
 <tr><td align="right" valign="top"><p><a href="/permissions/one?object_id=@revision_id@"><b>#download.lt_Edit_Permissions_on_T#</b></a> 
     <td> <font size=-1>(<a href="help#permissions">#download.lt_permission_descriptio#</a>)</font>
 </tr>
</if>

<tr>
 <td align="right">#download.Created_by#</td>
 <td><a href="/shared/community-member?user_id=@creation_user@">@creation_user_name@</a> #download.on_creation_date#</td>
</tr>
<tr>
 <td align="right">#download.Downloads#</td>
 <td>@downloads@
     <if @admin_p@ eq 1>
     (<a href="admin/report-version-downloads?archive_id=@archive_id@&versions=all">#download.download_history#</a>)
     </if>

 </td>
</tr>

<multiple name=metadata>
<tr>
 <td align="right">@metadata.pretty_name@:</td>
 <td><%= [set @metadata.select_var@]%>
 </td>
</tr>

</multiple>

</table>

<p>
<center>
@gc_link;noquote@
<p>
@gc_comments;noquote@
</center>

