<master>
<property name="doc(title)">@title;literal@</property>
<property name="context">@context;literal@</property>

<formtemplate id="add_type"></formtemplate>

<h3>#download.lt_Current_Archive_Types#</h3>
<ul>
<multiple name=types>
  <li>@types.pretty_name@ <br >
      @types.description@ <br >
      <a href="repository-types-delete?archive_type_id=@types.archive_type_id@">#download.Delete#</a> |
      <a href="repository-types-edit?archive_type_id=@types.archive_type_id@">#download.Edit#</a></li>
</multiple>
</ul>

