  <master>
    <property name="title">Spam Downloaders</property>
    <property name="context">"Spam downloaders"</property>

    <form action="spam-users-2" method="post">
      @userid_list_export@
      <table>
        <tr>
          <td>Email Subject:</td>
          <td><input type="text" name="subject" size="30" /></td>
        </tr>
        <tr>
          <td>Message:</td>
          <td><textarea name="msgbody" cols="60" rows="12" wrap="soft"></textarea></td>
        </tr>
        <tr>
          <td></td>
          <td><input type="submit" value="Spam" /></td>
        </tr>
      </table>
    </form>

    <p>
      The following users will receive your spam:
      <ul>
        @userlist_str@
      </ul>
    </p>