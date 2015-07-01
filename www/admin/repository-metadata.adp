<master>
<property name="doc(title)">@title;noquote@</property>
<property name="context">@context;noquote@</property>

<formtemplate id="add_metadata"></formtemplate>

<if @metadata:rowcount;literal@ gt 0>
<h3>#download.Current_Metadata#</h3>
<ul>
<multiple name=metadata>
  <li>#download.lt_Name_metadatapretty_n# <br>
      #download.lt_Archive_Type_metadata# <br>
      #download.lt_Sort_key_metadatasort# <br>
      #download.lt_Data_Type_metadatadat# <br>
      #download.lt_Required_metadatarequ# <br>
      #download.lt_Linked_metadatalinked# <br>
      #download.lt_Mainpage_metadatamain# <br>
      #download.lt_Computed_metadatacomp# <br>

      <a href="repository-metadata-delete?metadata_id=@metadata.metadata_id@">#download.Delete#</a> |
      <a href="repository-metadata-edit?metadata_id=@metadata.metadata_id@">#download.Edit#</a>
</multiple>
</ul>
</if>
