<!DOCTYPE html>
<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head>
  <cfoutput>

<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<meta name="google-site-verification" content="Oq2H0oj1cZ5ObulpwZvVlujECpPN006ED_J8mVpf4Nk" />
<link href='http://fonts.googleapis.com/css?family=Lato:100,300,400,700,900' rel='stylesheet' type='text/css' />
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/jquery-ui.js"></script>
<script type="text/javascript" src="/includes/javascript/jQuery/jQuery.bootstrap.js"></script>
<link href="/includes/style/bootstrap.old.css" rel="stylesheet" type="text/css" />
<link href="/includes/style/icons.css" rel="stylesheet" type="text/css" />
<link href="/includes/style/bootstrap-responsive.min.css" rel="stylesheet" type="text/css" />
<meta name="google-site-verification" content="NXYs1wejlMS_-2KyRA6QsgnEGiklt_hDDDkgbzt0K2w" />
<meta name="resource-type" content="document"/>
<meta name="generator" content="Aptana Studio"/>
<meta http-equiv="pragma" content="no-cache"/>
<meta name="classification" content="Building Suppliers"/>
<meta name="distribution" content="Global"/>
<meta name="rating" content="GENERAL"/>
<meta name="copyright" content="Turnbull"/>
<meta name="author" content="eBiz UK"/>
<meta name="language" content="en-GB"/>
<meta name="googlebot" content="NOODP" />

<cfset showLinks = true>
<cfif event.getCurrentModule() eq "mxtra">
  <cfset showLinks = false>
</cfif>
<link type="text/css" rel="stylesheet" href="/includes/javascript/jQuery/css/Aristo/jQueryUI.css"></link>
<script src="/includes/javascript/sites/1/shop.js"></script>
<link href="/includes/style/sites/1/styles.css" rel="stylesheet" type="text/css" media="screen" />
#getMyPlugin(plugin="jQuery").getDepends("validate,bindWithDelay,dataTables,bootstrap,bbq,address,form,block,cycle,easing.1.3,cookie","","sites/1/mobile",false)#
</cfoutput>


<link rel="shortcut icon" type="image/x-icon" href="/includes/images/turnbull/favicon.ico" />
<link rel="icon" type="image/x-icon" href="/includes/images/turnbull/favicon.ico" />

<cfset linkData = "">


</head>
<body class="body">

  <div class="wrapper" id="main">
    <div class="navbar navbar-fixed-top">
      <div class="navbar-inner">
        <div class="container">
          <a class="btn btn-navbar btn-inverse" data-toggle="collapse" data-target="#topnav">
            menu
          </a>
          <a class="brand" href="#"><img src="/includes/images/sites/1/logo.png" border="0" alt="Turnbull 24-7" /></a>
          <cfif getAuthUser() neq "">
            <cfset currentUser = getModel("modules.eunify.model.ContactService").getContact(request.BMNet.contactID,3,request.siteID)>
            <div id="loggedin">
            <cfoutput>
              <p><i class="icon-loggedin"></i>Logged in as #currentUser.first_name# #currentUser.surname# | <a href="/login/logout">Not you?</a></p>
            </cfoutput>
            </div>
          </cfif>
          <cfoutput>#renderView(view="modules/mxtra/shop/basket_overview",cache=false)#</cfoutput>
          <div class="nav-collapse" id="topnav">
            <div>
            <ul class="nav">
              <li><a href="/">home</a></li>
              <li><a href="/html/branch-locator.html">branch locations</a></li>
              <li><a href="/mxtra/account">your account</a></li>
              <li><a href="/mxtra/shop/category/great-special-offers">great offers</a></li>
              <li><a href="/mxtra/shop/category/clearance-items">clearance items</a></li>
            </ul>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div id="mainB" class="container">
        <cfoutput>
           #renderView()#
        </cfoutput>
    </div>
		<div class="push"><!--//--></div>
  </div>
	<cfset branches = getModel("templates.branchlocator").getBranches(18,"eGroup_cemco")>
  <footer>
    <div class="container">
      <img class="hidden-phone" src="/includes/images/sites/1/cemco.png" alt="CEMCO member" style="float: left;" />
			<div class="hidden-phone pull-right" style="text-align:right">
        <a href="http://ebizuk.net" target="_blank"><img src="/includes/images/eBizLogo.png" border="0"></a>
				<br />
        <a style="font-size: 10px; color:#222" href="http://www.buildingvine.com"> Building Products by Building Vine</a>
      </div>
			<p style="text-align:center"><a href="/html/about-us.html">About Us</a>&nbsp;|
        &nbsp;<a href="/html/contact-us.html">Contact Us</a>&nbsp;|
        &nbsp;<a href="/html/terms-and-conditions.html">Terms &amp; Conditions</a>&nbsp;|
        &nbsp;<a href="/html/privacy.html">Privacy</a>.</p>
		  <p style="text-align:center">Copyright &copy; <cfoutput>#year(now())# Turnbull &amp; Co Ltd.</cfoutput></p>

			<div class="page-header dark">

			</div>
			<div class="row">
	    	<cfoutput query="branches">
				 <div class="span2">
				 	<h4>#name#</h4>
					<address>
						<cfif address1 neq "">#address1#<br /></cfif>
						<cfif address2 neq "">#address2#<br /></cfif>
						<cfif address3 neq "">#address3#<br /></cfif>
						<cfif town neq "">#town#<br /></cfif>
						<cfif county neq "">#county#<br /></cfif>
						<cfif postcode neq "">#postcode#<br /></cfif>
						<cfif tel neq "">#tel#</cfif>
					</address>
				 </div>
			  </cfoutput>
	    </div>
		</div>
  </footer>
<cfif isUserInRole("staff")>
  <cfoutput>#renderView(view="admin/menu",module="sums")#</cfoutput>
</cfif>
<div id="dialog"></div>
<script type="text/javascript">

  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-866816-32']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();

</script>
</body>
</html>
