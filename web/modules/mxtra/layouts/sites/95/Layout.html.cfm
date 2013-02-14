<cfif NOT isDefined("rc.pageID")>
  <cfset rc.pageID = 0>
</cfif>
<cfsetting showdebugoutput="no">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:fb="http://www.facebook.com/2008/fbml">
<head>
<meta name="robots" content="ALL"/>
<meta name="revisit-after" content="30 days"/>

<meta content="Turnbull Building Supplies.  Timber, Landscaping, Bathrooms &amp; Showers. Kitchens. Buy Online for UK Delivery" name="description"/>
 <cfif isDefined('rc.pageID') AND rc.pageID neq 0>
  <cfif rc.pageID neq rc.sess.homeRedirect>
     <link rel="canonical" href="http://#rc.sess.realHost#/html/#rc.page.quickLink#.html" />
    <cfelse>
  <link rel="canonical" href="http://#rc.sess.realHost#/" />
  </cfif>
</cfif>

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
  <cfset showLinks = false>
<script type="text/javascript" src="/includes/javascript/jQuery/jQuery.js"></script>
<script type="text/javascript" src="/includes/javascript/jQuery/jQueryUI.js"></script>
<link type="text/css" rel="stylesheet" href="/includes/javascript/jQuery/css/Aristo/jQueryUI.css" />
<script src="https://www.buildingvine.com/includes/javascript/zoom.js" type="text/javascript" language="javascript"></script>
<script src="https://www.buildingvine.com/includes/javascript/jQuery/jqzoom.pack.1.0.1.js" type="text/javascript" language="javascript"></script>
<script src="https://www.buildingvine.com/includes/javascript/dataAPI.js" type="text/javascript" language="javascript"></script>
<link rel="stylesheet" href="/includes/styles/sites/95/style.css" type="text/css" media="screen" />
<link href="https://www.buildingvine.com/includes/styles/jQuery/jqzoom.css" rel="stylesheet">


<title>Tucker French Bathrooms</title>
<link rel="shortcut icon" type="image/x-icon" href="/includes/images/95/favicon.ico" />
<link rel="icon" type="image/x-icon" href="/includes/images/95/favicon.ico" />
<cffunction name="breadcrumb" returntype="string" access="public" output="true">
  <cfargument name="pageid" required="yes">
  <cfargument name="tree" required="true" default="">
  <cfquery name="parentPage" datasource="sums">
    select parentid from Page where id = '#arguments.pageid#';
  </cfquery>
  <cfif parentPage.parentid is 0 or parentPage.recordCOunt eq 0>
    <!--- we've reached the root --->
    <cfset tree = "<a href='/' class='breadcrumb'>Home</a>&nbsp;&raquo;&nbsp; " & arguments.tree>
    <cfreturn tree>
  <cfelse>
    <cfquery name="pagename" datasource="sums">
      select name, quickLink from Page where id = '#arguments.pageid#';
    </cfquery>
    <cfif pageid eq rc.pageID>
      <cfset tree = "#pagename.name#">
    <cfelse>
      <cfset tree = "<a href='/html/#pagename.quickLink#.html' class='breadcrumb'>#pagename.name#</a>&nbsp;&raquo;&nbsp;" & arguments.tree>
    </cfif>
    <cfreturn breadcrumb(parentPage.parentid, tree)>

  </cfif>
</cffunction>
<cfsavecontent variable="menuCode">
<ul>
  <!-- begin links -->
  <!-- begin link body -->
  <li><!-- link --></li>
  <!-- end link body -->
  <!-- end links -->
  <li><a href="/" class="red">Special Offers</a></li>
</ul>
</cfsavecontent>

<cfset linkData = getMyPlugin("sumsnavigation").createLinks(classname="navigation", disableChildren=true,id="#rc.pageID#",displaySublinks=false,templateCode="#menuCode#")>

</head>
<body>
<div id="page">
  <div id="pageheader">
    <div id="logo"></div>
    <div id="header">
      <cfif getAuthUser() neq "">
        <div id="loggedin">
        <cfoutput>
          <h4>You are logged in as #getModel(module="merchantXtra",name="invoicing.account").getCustomer(getAuthUser()).name#</h4>
          <h5><a href="/mxtra/account/main/logout">Not you?</a></h5>
        </cfoutput>
        </div>
      </cfif>
    </div>
    <div id="cemcoLogo"></div>
  </div>
  <div id="topnav">
    <div id="buttons">
    <ul>
      <li class="first"><a class="home" href="/">home</a></li>
      <li><a class="careers" href="/?page=4954">careers</a></li>
      <li><a class="branches" href="/?page=4953">store finder</a></li>
      <li><a class="account" href="/mxtra/account">your account</a></li>
      <li><a class="specials" href="/mxtra/shop/product/specials">special offers</a></li>
      <li class="last"><a class="contact" href="/html/contact-us">contact us</a></li>
    </ul>
  </div>
  </div>
  <div id="pagebody">
    <div id="basket_overview">
     <cfoutput>#renderView("shop/basket_overview")#</cfoutput>
    </div>
    <cfif showLinks AND isNumeric(rc.pageID) AND rc.pageID neq rc.sess.homeRedirect>
      <div id="tree">
        <cfoutput><div style="font-family: tahoma; font-size: 11px; padding: 0px;">#breadcrumb(rc.pageid)#</div>  </cfoutput>
      </div>
      <cfelseif NOT showLinks>
      <div id="tree">
        <cfif isDefined('rc.categoryID') AND isDefined('rc.productID')><cfoutput>You are here: #getMyPlugin("mxtra/shop/category").breadcrumb(categoryID=rc.categoryID,productID=rc.productID,tree="")#</cfoutput></cfif>
      </div>
    </cfif>
    <div id="accordion">
        <cfoutput>#renderView("shop/sites/#rc.sess.siteID#/categoryTree","false",180)#</cfoutput>
    </div>
    <cfoutput><div id="#Iif(showLinks,"'mainpLinks'","'mainp'")#"></cfoutput>
      <!-- fresh get -->
      <cfoutput>#renderView()#</cfoutput>
      <div class="clearer"></div>
    </div>
    <cfif showLinks>
    <div class="homelinks">
    <cfoutput>#linkData#</cfoutput>
    </div>

    </cfif>
    <div class="clearer"></div>
  </div>
  <div class="clearer"></div>

  <div id="footer">
    <cfoutput>
    <div id="systemInfo">
    </div>
    <div id="footerlinks" align="center">
      <p>Copyright &copy; 2001-#DateFormat(now(),"YYYY")# Turnbulls</p>
    </div>
    <div id="ebizPower"><a href="http://www.ebiz.co.uk" target="_blank"><img src="/includes/images/sites/111/eBizLogo.png" border="0"></a></div>
    </cfoutput>
    <div class="clearer"></div>
  </div>
</div>
<p id='screenshot' class='loading' align='center'></p>

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
