<master>
<property name="title">@title@</property>
<property name="context"></property>

<if @master_admin_p@ eq 1>
<table align="right"><tr><td><a href="admin/">Administration</a></td></tr></table>
</if>
<table align="right"><tr><td><a href="help">Help</a></td></tr></table>

@description@

    <if @user_id@ eq 0>
      <p>You must <strong><a href="/register/index?<%= [export_url_vars return_url] %>">register</a></strong>
         before you can download any files.
      </p>
    </if>

<h3>Available Software:</h3> 

@dimensional_html@
<br /><br />
@table@

<if @write_p@ eq 1>
<h3>Upload a New Version of Software:</h3>
<ul>
<multiple name=types>
  <li><a href="archive-add?repository_id=@repository_id@&archive_type_id=@types.archive_type_id@">@types.pretty_name@</a></li>
</multiple>
</ul>
</if>

<if @user_id@ ne 0>
<if @my_revisions:rowcount@ ne 0>
<h3>My Unapparoved Revisions:</h3>
<ul>
<multiple name=my_revisions>
  <li><a href="one-revision?revision_id=@my_revisions.revision_id@">@my_revisions.archive_name@ @my_revisions.version_name@</a></li>
  <if @my_revisions.approved_p@ eq f>
  Disapproved: @my_revisions.approved_comment@
  </if>
  <if @my_revisions.approved_p@ eq "">
  Approval Pending.
  </if>
</multiple>
</ul>
</if>
</if>
