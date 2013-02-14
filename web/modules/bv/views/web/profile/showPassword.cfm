<div class="alert alert-info">
  <h4 class="alert-heading">Password reset</h4>
  <p>Your password has been reset. You login credentials are now as follows:</p>
  <ul>
    <cfoutput>
      <li>Username: <span class="label">#rc.j_username#</span></li>
      <li>Password: <span class="label label-error">#rc.j_password#</label></li>
    </cfoutput>
  </ul>
  <p>You should <strong>make a note of your new password</strong>, or <a href="/bv/profile/password">change your password</a>.</p>
</div>