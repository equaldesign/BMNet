<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>eBiz Help System</title>
<script src="/includes/javascript/jQuery/jQuery.js" type="text/javascript"></script>

<style type="text/css">
@import url("/includes/style/login.css");
@import url("/includes/style/bootstrap.css");


</style>
</head>

<body>
<div id="distance"></div>
<div id="content">
  <cfoutput>
	<div id="loginBox">
        <div id="login-header">
            <h3>Login</h3>
        </div>
		#renderView()#
	</div>
  </cfoutput>
	<div id="copyRight">
		<p>Copyright 2010 <a target="_blank" href="http://ebizuk.net">eBiz</a></p>
		<p>Licensed under the GNU General Public Licence Version 3 (<a target="_blank" href="http://www.gnu.org/licenses/quick-guide-gplv3.html">GPLv3</a>).</p>
	</div>
	<br clear="all" />
</div>

</body>
</html>