  <master>
    <property name="title">Spam Downloaders</property>
    <property name="context">"Spam downloaders"</property>

    <if @users:rowcount@ eq 0>
      After weeding out users who don't want to be spammed, there was no one
      left on your list. Sorry!
    </if>
    <else>

    <p>
        Users who have requested not to be spammed will
        <strong>NOT</strong> receive your email.
        <br />
        (@no_spam_count@ user<if @no_spam_count@ ne 1>s</if> removed 
        from the list for this reason)
    </p>

    <form action="spam-users-2" method="post">
      @user_id_list_export;noquote@
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
        <if @users:rowcount@ lt 25>
          <multiple name="users">
            <li>@users.user_name@ (<a href="mailto:@users.email@">@users.email@</a>)</li>
          </multiple>
        </if>
        <else>
          <li>@users:rowcount@ users will receive your message.</li>
        </else>
      </ul>
    </p>
    </else>