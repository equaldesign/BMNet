<!DOCTYPE html>
<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head>
  <cfoutput>
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<meta name="google-site-verification" content="Oq2H0oj1cZ5ObulpwZvVlujECpPN006ED_J8mVpf4Nk" />
<link href='http://fonts.googleapis.com/css?family=Lato:100,300,400,700,900' rel='stylesheet' type='text/css' />
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/jquery-ui.js"></script>
<script type="text/javascript" src="https://www.buildingvine.com/includes/javascript/api/js.js"></script>
<link href="/includes/style/bootstrap.css" rel="stylesheet" type="text/css" />
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
<link href='http://fonts.googleapis.com/css?family=Droid+Sans:400,700' rel='stylesheet' type='text/css'>
<cfset showLinks = true>
<cfif event.getCurrentModule() eq "mxtra">
  <cfset showLinks = false>
</cfif>
<link type="text/css" rel="stylesheet" href="/includes/javascript/jQuery/css/Aristo/jQueryUI.css"></link>
#getMyPlugin(plugin="jQuery").getDepends("bootstrap,bbq,address,form,block,cycle,easing.1.3,cookie","sites/9/rp","sites/9/style",false)#
</cfoutput>


<cfset linkData = "">

</head>
<body class="body">

  <div class="wrapper" id="main">
    <div class="navbar navbar-fixed-top">
      <div class="navbar-inner">
        <div class="container rel">
          <a class="btn btn-navbar btn-inverse" data-toggle="collapse" data-target="#topnav">
            menu
          </a>
          <a class="brand" href="#"><img class="img-rounded" src="/includes/images/sites/9/logo.jpg" border="0"></a>
          <cfif getAuthUser() neq "">
            <cfset currentUser = getModel("modules.eunify.model.ContactService").getContact(request.BMNet.contactID,3,request.siteID)>
            <div id="loggedin" class="pull-right learfix">
            <cfoutput>
              <p><i class="icon-loggedin"></i>Logged in as #currentUser.first_name# #currentUser.surname# | <a href="/login/logout">Not you?</a></p>
            </cfoutput>
            </div>
            <br class="clear" clear="all" />
          </cfif>
          <div class="nav-collapse pull-right" id="topnav">
            <div>
            <ul class="nav">
              <li><a href="/">Home</a></li>
              <li><a href="/html/branch-locator.html">Branch Locations</a></li>
              <li><a href="/mxtra/account">Your Account</a></li>
              <li><a href="/html/contact-us">Contact Us</a></li>
            </ul>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div id="sn" class="navbar subnav container <cfif getAuthUser() neq ''>pm</cfif>">
      <div class="span7 navbar-inner">
        <ul class="nav nav-pills">
          <li><a href="/html/products.html">Products</a></li>
          <!-- <li class="divider-vertical"></li> -->
          <li><a href="/html/self-build.html">Self Build</a></li>
          <!-- <li class="divider-vertical"></li> -->
          <li><a href="/html/public-sector.html">Public Sector</a></li>
          <!-- <li class="divider-vertical"></li> -->
          <li><a href="/html/promotions.html">Promotions</a></li>
          <!-- <li class="divider-vertical"></li> -->
          <li><a href="/html/whats-on.html">What's On</a></li>
          <!-- <li class="divider-vertical"></li> -->
          <li><a href="/html/news.html">News</a></li>
          <!-- <li class="divider-vertical"></li> -->
          <li><a href="/html/jobs.html">Jobs</a></li>
        </ul>
      </div>
    </div>
    <div id="mainB" class="container">
      <div class="row">
        <cfoutput>
        <div class="span3 hidden-phone">
            <cfif getAuthUser() neq "" AND (ListFirst(event.getCurrentEvent(),".") eq "mxtra:account")>
              #renderView(view="account/accountMenu",module="mxtra")#
            <cfelse>
              <div>
              #renderView(view="modules/sums/templates/links",cache=false)#
              </div>
              <div id="twitter">
                <a class="twitter-timeline" href="https://twitter.com/RobertPriceBM" data-widget-id="247466132221607938">Tweets by @RobertPriceBM</a>
                <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="//platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>
              </div>

            </cfif>
        </div>
        <div class="span9 mainPanel">
          <div id="mainPanel" class="">
            #renderView()#
          </div>
        </div>
        <div class="span3 visible-phone">
            <cfif getAuthUser() neq "" AND (ListFirst(event.getCurrentEvent(),".") eq "mxtra:account")>
              #renderView(view="account/accountMenu",module="mxtra")#
            <cfelse>
              <div>
              #renderView(view="modules/sums/templates/links",cache=false)#
              </div>
              <div id="twitter">
                <a class="twitter-timeline" href="https://twitter.com/RobertPriceBM" data-widget-id="247466132221607938">Tweets by @RobertPriceBM</a>
                <script>!function(d,s,id){var js,fjs=d.getElementsByTagName(s)[0];if(!d.getElementById(id)){js=d.createElement(s);js.id=id;js.src="//platform.twitter.com/widgets.js";fjs.parentNode.insertBefore(js,fjs);}}(document,"script","twitter-wjs");</script>
              </div>
              <div class="hidden-phone" id="leftPanelAdvert">

              </div>
            </cfif>
        </div>
        </cfoutput>
      </div>
    </div>
		<div class="push"><!--//--></div>
  </div>
	<cfset branches = getModel("templates.branchlocator").getBranches(925,"eGroup_cbagroup")>
  <footer>
    <div class="hidden-phone container">

			<div class="hidden-phone pull-right" style="text-align:right">
        <a href="http://ebizuk.net" target="_blank"><img src="/includes/images/eBizLogo.png" border="0"></a>
				<br />
        <a style="font-size: 10px; color:#222" href="http://www.buildingvine.com"> Building Products by Building Vine</a>
      </div>
			<p style="text-align:center"><a href="/html/about-us.html">About Us</a>&nbsp;|
        &nbsp;<a href="/html/contact-us.html">Contact Us</a>&nbsp;|
        &nbsp;<a href="/html/terms-and-conditions.html">Terms &amp; Conditions</a>&nbsp;|
        &nbsp;<a href="/html/privacy.html">Privacy</a>.</p>
		  <p style="text-align:center">Copyright &copy; <cfoutput>#year(now())# Robert Price BM &amp; Co Ltd.</cfoutput></p>

			<div class="page-header dark">

			</div>
			<div class="row">

				 <div class="span4">
          <cfoutput query="branches">
		  		 	<h4><a href="##" class="showbranch" rel="#id#">#name#</a></h4>
	 			  </cfoutput>
         </div>
         <div class="span8">
           <cfoutput query="branches">
           <div class="hidden" id="branch_#id#">
             <div class="row">
               <div class="span3">
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
               <div class="span5">
                 <img class="thumbnail" src="http://maps.googleapis.com/maps/api/staticmap?center=<cfif address1 neq "">#URLEncodedFormat(address1)#,</cfif><cfif address2 neq "">#URLEncodedFormat(address2)#,</cfif><cfif address3 neq "">#URLEncodedFormat(address3)#,</cfif><cfif town neq "">#URLEncodedFormat(town)#,</cfif><cfif county neq "">#URLEncodedFormat(county)#,</cfif>#URLEncodedFormat(postcode)#&zoom=13&size=250x250&markers=color:red%7C<cfif address1 neq "">#URLEncodedFormat(address1)#,</cfif><cfif address2 neq "">#URLEncodedFormat(address2)#,</cfif><cfif address3 neq "">#URLEncodedFormat(address3)#,</cfif><cfif town neq "">#URLEncodedFormat(town)#,</cfif><cfif county neq "">#URLEncodedFormat(county)#,</cfif>#URLEncodedFormat(postcode)#&sensor=false">
               </div>
             </div>
           </div>
           </cfoutput>
         </div>
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
