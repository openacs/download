<master>
<property name="doc(title)">@title;noquote@</property>
<property name="context">@context;noquote@</property>

<h3>#download.lt_Add_a_new_Download_Re#</h3>

<formtemplate id="add_reason"></formtemplate>


<if @reasons:rowcount;literal@ gt 0>
<h3>#download.Current_Reasons#</h3>
<ul>
<multiple name=reasons>
  <li>@reasons.reason@ <br>
      <a href="repository-reasons-delete?download_reason_id=@reasons.download_reason_id@">#download.Delete#</a> |
      <a href="repository-reasons-edit?download_reason_id=@reasons.download_reason_id@">#download.Edit#</a>
</multiple>
</ul>
</if>

