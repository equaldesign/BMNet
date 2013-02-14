<!DOCTYPE html>
<html lang="en" xmlns="http://www.w3.org/1999/xhtml">
<head>
<cfoutput>
  <script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
  <script type="text/javascript" src="https://www.google.com/jsapi"></script>
  <meta name="description" content="#paramValue("rc.requestData.page.attributes.customProperties.description","Tucker French Bathrooms.  Bathrooms &amp; Showers. Kitchens. Buy Online for UK Delivery")#" />
        <meta name="keywords" content="#paramValue("rc.requestData.page.attributes.customProperties.keywords","Building, Products, Supplies")#" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <meta name="google-site-verification" content="Oq2H0oj1cZ5ObulpwZvVlujECpPN006ED_J8mVpf4Nk" />
  <link href='http://fonts.googleapis.com/css?family=Oswald:400,700,300' rel='stylesheet' type='text/css'>
  <link href='http://fonts.googleapis.com/css?family=Cabin+Condensed' rel='stylesheet' type='text/css'>
  <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
  <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/jquery-ui.js"></script>
  <script type="text/javascript" src="/includes/javascript/jQuery/jQuery.bootstrap.js"></script>
  <link href="/includes/style/bootstrap.new.css" rel="stylesheet" type="text/css" />
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
<cfset rc.homeLinks = getModel("PageService").proxy(
    proxyurl="sums/page/homepage?alf_ticket=#request.buildingVine.admin_ticket#&siteID=#rc.siteID#",
    formCollection=form,
    method="get",
    JSONRequest="false",
    siteID = rc.siteID,
    jsonData = "",
    alf_ticket=request.buildingVine.admin_ticket
  )>
  <cfset showLinks = true>
  <cfif event.getCurrentModule() eq "mxtra">
    <cfset showLinks = false>
  </cfif>
    <link type="text/css" rel="stylesheet" href="/includes/javascript/jQuery/css/Aristo/jQueryUI.css"></link>
    <script src="/includes/javascript/sites/1/shop.js"></script>
    <link href="/includes/style/sites/2/styles.css" rel="stylesheet" type="text/css" media="screen" />
  #getMyPlugin(plugin="jQuery").getDepends("bbq,address,form,block,cycle,easing.1.3,cookie,validate,bindWithDelay,dataTables,tp,sr","","icons,jQuery/sr/settings",false)#
</cfoutput>

<cfset linkData = "">
<!--[if IE]>
  <link rel="stylesheet" type="text/css" href="/includes/style/sites/2/ie.css" />
<![endif]-->
</head>
<body class="body">
<cfoutput>
<input type="hidden" id="bvsiteID" value="tuckerfrench">
</cfoutput>
<div id="wrap">
  <div id="main">
    <div id="topblue"></div>
    <div class="container">
      <!--- logo and opening hours --->
      <div class="row hidden-phone">
        <div class="pull-left span4">
          <img src="/includes/images/sites/2/logo.png" alt="Tucker French" />
        </div>
        <div class="pull-right hidden-phone" id="openingHours">
          <h2>Plumbing & Heating <span class="tuckerr">merchants</span></h2>
          <div class="media">
            <div class="pull-left">
              <img src="/includes/images/sites/2/clock.png" alt="Opening Hours" />
            </div>
            <div class="media-body">
              <h4 class="media-heading">Opening Hours</h4>
              <p>Monday - Friday: 7am - 5pm</p>
              <p>Saturday: 8am - 12pm</p>
            </div>
          </div>
        </div>
        <!--- end opening hours --->
      </div>
      <div id="topnav" class="navbar">
        <div class="navbar-inner">
          <img class="visible-phone pull-left" height="35" src="/includes/images/sites/2/logo_mobile.png" alt="Tucker French" />
          <a class="btn btn-navbar btn-inverse pull-right"><i class="icon-nav-expand"></i> MENU</a>
          <div class="nav-collapse collapse">
            <ul class="nav">
              <cfset currentPage = paramValue("rc.requestData.page.name","homepage.html")>
              <cfoutput>
              <cfloop array="#rc.homeLinks.page.links#" index="lnk">
                <li class="#IIf(currentPage eq lnk.linkURL,'"active"','""')#"><a href="#lnk.linkURL#">#lnk.name#</a></li>
              </cfloop>
              </cfoutput>
            </ul>
            <cfif isUserLoggedIn()>
              <!-- <span class="pull-right">Logged in as Bob Skeng | <a href="/login/logout">logout</a></span> -->
            <cfelse>
              <a href="/login" class="btn btn-danger pull-right">Login</a>
            </cfif>

          </div>
        </div>
      </div>
      <div id="maincontent">
        <cfif (isDefined("rc.requestData.page.links") AND arrayLen(rc.requestData.page.links) neq 0) AND paramValue("rc.requestData.page.showLinks",false)>        
          <div class="row">
            <div class="span3">
              <cfoutput>#renderView(view="modules/sums/templates/links",cache=false)#</cfoutput>
            </div>
            <div class="span9">
              <cfoutput>#renderView()#</cfoutput>
            </div>
          </div>
        <cfelse>
          <cfoutput>#renderView()#</cfoutput>
        </cfif>
      </div>
    </div>
  </div>
</div>
<cfset branches = getModel("templates.branchlocator").getBranches(24,"eGroup_cemco")>
<div id="footer">
  <div class="container">
    <div id="footerMain">
      <div class="row-fluid">
        <div class="span2">
          <h3>Sitemap</h3>
          <ul class="nav nav-stacked">

            <li><a href="/">Home</a></li>
            <li><a href="/">About</a></li>
            <li><a href="/">Special offers</a></li>
            <li><a href="/">Services</a></li>
            <li><a href="/html/products.html">Products</a></li>
            <li><a href="/html/branch-locations.html">Branches</a></li>
            <li><a href="/">Contact</a></li>
          </ul>
        </div>
        <div class="span2">
          <h3>Product Categories</h3>
        </div>
        <div class="span2"></div>
        <div class="span3">
          <h3>Key Brands</h3>
          <h3>Useful Links</h3>
          <ul class="nav nav-stacked">
            <li><a target="_blank" href="http://www.phg.uk.com">PHG Group</a></li>
            <li><a target="_blank" href="http://www.nmbs.co.uk">NMBS</a></li>
            <li><a target="_blank" href="http://www.unimer.co.uk">Unimer</a></li>
            <li><a target="_blank" href="http://www.ebiz.co.uk">eBiz | web solutions for the construction industry</a></li>
            <li><a target="_blank" href="http://www.buildermerchant.net">BuildersMerchant.net</a></li>
          </ul>
        </div>
        <div class="span3">
          <h3>Newsletter Signup</h3>
          <p>Sign up to receive special offers and the latest style news.</p>
          <form action="/" class="form form-inline">
            <div class="input-append">

              <input placeholder="name@domain.com" type="text" class="input-medium pull-left" />
              <button type="submit" class="btn btn-danger">SIGNUP</button>
            </div>
          </form>
        </div>
      </div>
    </div>
    <div id="footerSub">
      <div id="subInner">
      &copy; <cfoutput>#Year(now())#</cfoutput> <strong>TUCKER FRENCH.</strong> All Rights Reserved.&nbsp;&nbsp;/&nbsp;&nbsp;<a href="/html/privacy-policy.html">Privacy Policy</a>&nbsp;&nbsp;/&nbsp;&nbsp;<a href="/html/terms-of-use.html">Terms of Use</a>
      <div class="pull-right">
      
      </div>
      </div>
    </div>
  </div>
</div>


<cfif isUserInRole("staff")>
  <cfoutput>#renderView(view="admin/menu",module="sums")#</cfoutput>
</cfif>
<div id="dialog"></div>
</body>
</html>
