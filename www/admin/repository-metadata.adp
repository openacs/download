<master>
<property name="title">@title@</property>
<property name="context">@context@</property>

<formtemplate id="add_metadata"></formtemplate>

<h3>Current Metadata</h3>
<ul>
<multiple name=metadata>
  <li>Name: @metadata.pretty_name@ <br>
      Archive Type: @metadata.archive_name@ <br>
      Sort key: @metadata.sort_key@ <br>
      Data Type: @metadata.data_type@ <br>
      Required: @metadata.required_p@ <br>
      Linked: @metadata.linked_p@ <br>
      Mainpage: @metadata.mainpage_p@ <br>
      Computed: @metadata.computed_p@ <br>

      <a href="repository-metadata-delete?metadata_id=@metadata.metadata_id@">Delete</a> |
      <a href="repository-metadata-edit?metadata_id=@metadata.metadata_id@">Edit</a>
</multiple>
</ul>
