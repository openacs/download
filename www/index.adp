<master>
<property name="title">@title@</property>

<blockquote>
<h3>@title@</h3>
<p>
@description@

<if @user_id@ eq 0 and @registration_required_p@ ne 0>
    <p>You must<b>  
    <a href="/register/index?<%= [export_url_vars return_url] %>">register</a>
    </b>before you can download any files.
    </p>
</if>

<h3>Available Software:</h3> 

@dimensional_html@
@table@

<if @write_p@ eq 1>
<h4>Upload a New Software Package:</h4>
<ul>
<multiple name=types>
  <li><a href="archive-add?repository_id=@repository_id@&archive_type_id=@types.archive_type_id@">@types.pretty_name@</a>
</multiple>
</ul>
</if>

<if @user_id@ ne 0>
<if @my_revisions:rowcount@ ne 0>
<h4>My Unapparoved Revisions:</h4>
<ul>
<multiple name=my_revisions>
  <li><a href="one-revision?revision_id=@my_revisions.revision_id@">@my_revisions.archive_name@ @my_revisions.version_name@</a> 
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

</blockquote>

<br clear=all>

