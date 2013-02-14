<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>BuildersMerchant.net Login</title>
<script src="/includes/javascript/jQuery/jQuery.js" type="text/javascript"></script>
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<cfset getMyPlugin(plugin="jQuery").getDepends("","","fonts,main,form,medium,login,Aristo/jQueryUI")>
<link href='http://fonts.googleapis.com/css?family=Droid+Sans:400,700' rel='stylesheet' type='text/css'>
</head>

<body>
<div id="distance"></div>
<div id="content">
  <cfoutput>
	<div id="loginBox">
		<img align="left" src="/includes/images/logo_50.png" />
		<div class="form-signUp">
			#renderView(view="login/login",module="eunify")#
		</div>
	</div>
  </cfoutput>
	<div id="copyRight">
		<p>Copyright 2011 <a target="_blank" href="http://ebizuk.net">eBiz</a></p>
		<p>Version <a target="_blank" href="http://acme.egroup.ebiz.co.uk/page/other/page/releasenotes"><cfoutput>1</cfoutput></a>. Licensed under the GNU General Public Licence Version 3 (<a target="_blank" href="http://www.gnu.org/licenses/quick-guide-gplv3.html">GPLv3</a>).</p>
	</div>
	<br clear="all" />
</div>

</body>
</html>