<master>
<property name="title">One Revision: @archive_name;noquote@ ver. @version_name;noquote@</property>
<property name="context">@context;noquote@</property>

<if @master_admin_p@ eq 1>
<table align="right"><tr><td><a href="admin/">Administration</a></td></tr></table>
</if>
<table align="right"><tr><td><a href="help">Help</a></td></tr></table>
<table align=center>
 <tr><th colspan="2"><big>@archive_name@</big></th></tr>
<if @version_name@ ne "">
 <tr><td colspan=2 align=center><strong>version @version_name@</strong></td></tr>
</if>
 <tr><td colspan=2 align=center>
                   [<a href=download-verify?revision_id=@revision_id@>Download Now</a>]
                   [<a href=one-archive?<%= [export_url_vars archive_id ]%>>See All Versions</a>]<br>&nbsp;</td>
 </tr>
 <tr><td align=right valign=top><p>Summary:</td>
     <td>@summary@</td>
 </tr>
 <tr><td align=right valign=top>Description:</td>
     <td>@description@</td>
 </tr>
<if @admin_p@ eq 1>
 <tr><td align=right valign=top><p><a href=/permissions/one?object_id=@revision_id@><b>Edit Permissions on This Revision</b></a> 
     <td> <font size=-1>(<a href=help#permissions>permission descriptions</a>)</font>
 </tr>
</if>

<tr>
 <td align=right>Created by:</td>
 <td><a href=/shared/community-member?user_id=@creation_user@>@creation_user_name@</a> on @creation_date@</td>
</tr>
<tr>
 <td align=right>Downloads:</td>
 <td>@downloads@
     <if @admin_p@ eq 1>
     (<a href=admin/report-version-downloads?archive_id=@archive_id@&versions=all>download history</a>)
     </if>

 </td>
</tr>

<multiple name=metadata>
<tr>
 <td align=right>@metadata.pretty_name@:</td>
 <td><%= [set @metadata.select_var@]%>
 </td>
</tr>

</multiple>

</table>

<p>
<center>
@gc_link@
<p>
@gc_comments@
</center>
