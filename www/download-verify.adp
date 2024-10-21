  <master>
    <property name="doc(title)">Download @archive_name;noquote@ @version_name;noquote@</property>
    <property name="context">@context;literal@</property>

    <h3>#download.lt_Download_archive_name_1#</h3>
    <table>
      <tr>
        <td align="right">#download.File_Size#</td> 
        <td><strong>#download.file_sizek#</strong></td>
      </tr>
      <tr>
        <form method="post" action="@action@">
          <%= [export_vars -form {download_id revision_id}] %>
          <td align="right">#download.Reason_for_Download#</td> 
          <td>
            <select name="reasons">
              <option value="">#download.Other#</option>
              <multiple name="reasons">
                <option value="@reasons.download_reason_id@">@reasons.reason@</option>
              </multiple>
            </select>
          </td>
      </tr>
      <tr>
        <td align="right">#download.lt_If_you_have_selected_#<br /> #download.please_tell_us_why#</td>
        <td><input type="text" name="reason_other" size="60" /></td>
      </tr>
      <tr>
        <td>&nbsp;</td>
        <td><input type="submit" value="Submit and download" /></td>
      </tr>
    </table>

