<master src="master">
<property name="title">@title@</property>
<property name="context_bar">@context_bar@</property>

<formtemplate id="add_type"></formtemplate>

<h3>Current Archive Types</h3>
<ul>
<multiple name=types>
  <li>@types.pretty_name@ <br>
      @types.description@ <br>
      <a href="repository-types-delete?archive_type_id=@types.archive_type_id@">Delete</a> |
      <a href="repository-types-edit?archive_type_id=@types.archive_type_id@">Edit</a>
</multiple>
</ul>
