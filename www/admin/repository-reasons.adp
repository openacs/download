<master src="master">
<property name="title">@title@</property>
<property name="context_bar">@context_bar@</property>

<h3>Add a new Download Reason</h3>

<formtemplate id="add_reason"></formtemplate>

<h3>Current Reasons</h3>
<ul>
<multiple name=reasons>
  <li>@reasons.reason@ <br>
      <a href="repository-reasons-delete?download_reason_id=@reasons.download_reason_id@">Delete</a> |
      <a href="repository-reasons-edit?download_reason_id=@reasons.download_reason_id@">Edit</a>
</multiple>
</ul>
