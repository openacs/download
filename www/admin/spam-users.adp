  <master>
    <property name="doc(title)">Spam Downloaders</property>
    <property name="context">"Spam downloaders"</property>

    <if @users:rowcount@ eq 0>
      #download.lt_After_weeding_out_use#
    </if>
    <else>

    <p>
        #download.lt_Users_who_have_reques#
        <strong>#download.NOT#</strong> #download.receive_your_email#
        <br />
        #download.no_spam_count_user#<if @no_spam_count@ ne 1>#download.s#</if> #download.lt_removed_________from_#
    </p>

    <form action="spam-users-2" method="post">
      @user_id_list_export;noquote@
      <table>
        <tr>
          <td>#download.Email_Subject#</td>
          <td><input type="text" name="subject" size="30" /></td>
        </tr>
        <tr>
          <td>#download.Message#</td>
          <td><textarea name="msgbody" cols="60" rows="12" wrap="soft"></textarea></td>
        </tr>
        <tr>
          <td></td>
          <td><input type="submit" value="Spam" /></td>
        </tr>
      </table>
    </form>

    <p>
      #download.lt_The_following_users_w#
      <ul>
        <if @users:rowcount@ lt 25>
          <multiple name="users">
            <li>@users.user_name@ (<a href="mailto:@users.email@">@users.email@</a>)</li>
          </multiple>
        </if>
        <else>
          <li>#download.lt_usersrowcount_users_w#</li>
        </else>
      </ul>
    </p>
    </else>
