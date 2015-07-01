
<master>
<property name="doc(title)">@title;noquote@</property>
<property name="context"></property>

<if @master_admin_p@ eq 1>
<div style='float:right; padding:5px;'><a href="admin/">#download.Administration#</a></div>
</if>
<div style='float:right; padding:5px;'><a href="help">#download.Help#</a></div>
<br>

@description@
<if 0>
    <if @user_id@ eq 0>
      <p>#download.You_must# <strong><a href="@register_url;noi18n@">register</a></strong>
         #download.lt_before_you_can_downlo#
      </p>
    </if>
</if>
@dimensional_html;noquote@
<br><br>

<listtemplate name="download_list"></listtemplate>

<if @write_p@ eq 1>
<h3 style="margin-top: 1em">#download.lt_Upload_a_New_Version_#</h3>
<ul>
<multiple name=types>
  <li><a href="@archive_add_url;noi18n@">@types.pretty_name@</a></li>
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

