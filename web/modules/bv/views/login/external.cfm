<html>
  <head>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.4.4/jquery.min.js" language="javascript"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.8/jquery-ui.min.js" language="javascript"></script>
    <link href="/includes/styles/fonts.css" rel="stylesheet" type="text/css"></link>
    <link href="/includes/styles/public/external.css" rel="stylesheet" type="text/css"></link>
  </head>
  <body>
<img src="/includes/images/logo.jpg" alt="Building Vine"><br class="clear" />
<cfset getMyPlugin(plugin="jQuery").getDepends("","api/facebook","")>
<cfoutput>
  <div id="facebook">
  #renderView("facebook/login")#
  </div>
  <div class="bvLogin">
    <div class=" form-signUp">
    <form action="/login" method="post">
      <input type="hidden" name="target" id="target" value="#rc.target#">
      <fieldset>
        <legend>Login to Building Vine</legend>
        <div>
          <label class="s">Username <em>*</em></label>
          <input size="13" type="text" name="username" />
        </div>
        <div>
          <label class="s">Password <em>*</em></label>
          <input size="13" type="password" name="password" />
        </div>
        <div class="rightControlSet">
          <div>
          <input class="doIt" type="submit" value="Login &raquo;" />
          </div>
        </div>
      </fieldset>
    </form>
    <div id="bvintro">
      <h4>About Building Vine&trade;</h4>
      <p>Building Vine&trade; is a universal product repository. It holds data on
      more than 100,000 products lines within the construction industry. Registration
      is <strong>completely free</strong>.</p>
    </div>
  </div>
  </div>
  <div class="bvSignup">
  <div class=" form-signUp">
    <form action="/signup" method="post">
      <fieldset>
        <legend>Register with Building Vine</legend>
        <div>
          <label class="s">Email <em>*</em></label>
          <input size="20" type="text" name="username" />
        </div>
        <div>
          <label class="s">First Name <em>*</em></label>
          <input size="20" type="text" name="firstname" />
        </div>
        <div>
          <label class="s">Surname <em>*</em></label>
          <input size="20" type="text" name="surname" />
        </div>
        <div>
          <label class="s">Password <em>*</em></label>
          <input size="20" type="password" name="password" />
        </div>
        <div>
          <label class="s">Password <em>*</em></label>
          <input size="20" type="password" name="password" />
        </div>
        <div class="rightControlSet">
          <div>
          <input class="doIt" type="submit" value="Register &raquo;" />
          </div>
        </div>
      </fieldset>
    </form>
    </div>
  </div>
  <br class="clear" />
</cfoutput>
  </body>
</html>