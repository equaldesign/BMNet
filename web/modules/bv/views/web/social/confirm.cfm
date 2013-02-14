<h2>Confirm your account</h2>
<p>You already have a Building Vine account. We need you to confirm your password, so we can link your existing account with your Third party account (You only need to do this one time).</p>
<div class="form">
<form id="signUpForm" action="/social/signin/confirmPass" method="post">
  <cfoutput>
    <input type="hidden" name="identifier" value="#rc.socialStatus.identifier#" />
    <input type="hidden" name="email" value="#rc.socialStatus.email#" />
  </cfoutput>
  <div class="formmessage"></div>
  <div class="signUp form roundCorners">
    <div>
      <label for="password">Password<em>*</em></label>
      <input class="helptip" title="Confirm your password" type="password" name="password" id="password">
    </div>
  </div>
  <input type="submit" value="confirm details &raquo;" class="submit" />
</form>
</div>