<master>
<property name="doc(title)">One @pretty_name;noquote@</property>
<property name="context">@context;noquote@</property>

<h4>@pretty_name@</h4>

<ul>
<multiple name=archives>
<li><a href="one-archive?archive_id=@archives.archive_id@">@archives.archive_name@</a> 
    (@archives.num_versions@ <%= [ad_decode @archives.num_versions@ 1 version versions] %>)
</multiple>
</ul>