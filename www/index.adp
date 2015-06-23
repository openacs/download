
<master>
<property name="doc(title)">@title;noquote@</property>
<property name="context"></property>

<if @master_admin_p@ eq 1>
<table align="right"><tr><td><a href="admin/">#download.Administration#</a></td></tr></table>
</if>
<table align="right"><tr><td><a href="help">#download.Help#</a></td></tr></table>

@description@
<if 0>
    <if @user_id@ eq 0>
      <p>#download.You_must# <strong><a href="/register/index?<%= [export_vars -url {return_url}] %>">register</a></strong>
         #download.lt_before_you_can_downlo#
      </p>
    </if>
</if>
@dimensional_html;noquote@
<br /><br />

<listtemplate name="download_list"></listtemplate>

<if @write_p@ eq 1>
<h3 style="margin-top: 1em">#download.lt_Upload_a_New_Version_#</h3>
<ul>
<multiple name=types>
  <li><a href="archive-add?repository_id=@repository_id@&amp;archive_type_id=@types.archive_type_id@">@types.pretty_name@</a></li>
</multiple>
</ul>
</if>

<if @user_id@ ne 0>
<if @my_revisions:rowcount@ ne 0>
<h3>#download.lt_My_Unapproved_Revisio#</h3>
<ul>
<multiple name=my_revisions>
  <li><a href="one-revision?revision_id=@my_revisions.revision_id@">@my_revisions.archive_name@ @my_revisions.version_name@</a></li>
  <if @my_revisions.approved_p@ eq f>
  #download.lt_Disapproved_my_revisi#
  </if>
  <if @my_revisions.approved_p@ eq "">
  #download.Approval_Pending#
  </if>
</multiple>
</ul>
</if>
</if>

