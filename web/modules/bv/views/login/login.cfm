<html>
  <head>
    <title>Welcome to Building Vine</title>
    <link href="/includes/style/login.css" rel="stylesheet" type="text/css" />
    <link href="/includes/style/secure/form.css" rel="stylesheet" type="text/css" />
  </head>
  <body>
    <div class="distance"></div>
    <div class="form loginDiv">
      <form method="post" action="/login/doLogin">
        <div>
          <label>username:</label>
          <input size="30" type="text" name="username">
        </div>
        <div>
          <label>password:</label>
          <input size="30" name="password" type="password">
        </div>
        <input class="button" type="submit" value="login">
      </form>
    </div>
  </body>
</html>