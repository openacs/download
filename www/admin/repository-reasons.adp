<master>
<property name="title">@title;noquote@</property>
<property name="context">@context;noquote@</property>

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
