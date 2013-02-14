<h2>Setup your account</h2>
<p>We just need a few further details from you, seeing as this is the first time you are using the service.</p>
<div class="form">
<form id="signUpForm" action="/signup/doExtranet" method="post">
  <cfoutput>
    <input type="hidden" name="identifier" value="#rc.socialStatus.identifier#" />
  </cfoutput>
  <div class="formmessage"></div>
  <div class="signUp form roundCorners">
    <cfif StructKeyExists(rc.socialStatus, "email")>
      <input type="hidden" name="email" value="#rc.socialStatus.email#" />
    <cfelse>
    <div>
      <label for="email">Email Address<em>*</em></label>
      <input class="helptip" title="Your email" type="text" name="email" id="email" />
    </div>
    </cfif>
    <div>
      <label for="firstName">First Name<em>*</em></label>
      <input class="helptip" title="Your first name" type="text" name="first_name" id="first_name" />
    </div>
    <div>
      <label for="lastName">Last Name<em>*</em></label>
      <input class="helptip" title="Your last name" type="text" name="surname" id="surname" />
    </div>
    <div>
      <label for="password">Password<em>*</em></label>
      <input class="helptip" title="Confirm your password" type="password" name="password1" id="password1" />
    </div>
    <div>
      <label for="password">Password (confirm)<em>*</em></label>
      <input class="helptip" title="Confirm your password" type="password" name="password2" id="password2" />
    </div>

  </div>
  <input class="doIt" type="submit" value="confirm details &raquo;" class="submit" />
</form>
</div>