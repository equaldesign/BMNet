<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="apple-touch-icon-precomposed" sizes="144x144" href="/includes/images/apple-touch-icon-144-precomposed.png">
  <link rel="apple-touch-icon-precomposed" sizes="114x114" href="/includes/images/apple-touch-icon-11-precomposed.png">
  <link rel="apple-touch-icon-precomposed" sizes="72x72" href="/includes/images/apple-touch-icon-72-precomposed.png">
  <meta name="google-site-verification" content="Oq2H0oj1cZ5ObulpwZvVlujECpPN006ED_J8mVpf4Nk" />
  <link rel="apple-touch-icon-precomposed" href="/includes/images/apple-touch-icon-57-precomposed.png">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<cfoutput>

  <meta name="description" content="#paramValue("rc.requestData.page.attributes.customProperties.description","")#" />
  <meta name="keywords" content="#paramValue("rc.requestData.page.attributes.customProperties.keywords","")#" />

</cfoutput>
<link href="http://d25ke41d0c64z1.cloudfront.net/images/iconset.css" rel="stylesheet" type="text/css" />
<link href='http://fonts.googleapis.com/css?family=Lato:100,300,400,700,900' rel='stylesheet' type='text/css'>
  <script language="javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
  <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/jquery-ui.js"></script>
    <script language="javascript" src="/includes/javascript/sites/0/main.js"></script>
<cfoutput>
  #getMyPlugin(plugin="jQuery").getDepends("bootstrap,bbq,address,form,block,cycle,easing.1.3,cookie,tp,sr","sites/3/modernizre","bootstrap,bootstrap-responsive.min,jQuery/sr/settings",false)#
</cfoutput>
  <link href="/includes/style/sites/3/styles.css" rel="stylesheet" type="text/css" media="screen" />
</head>

<body>
  <div class="visible-desktop">
    <img src="/includes/images/sites/0/background.jpg" class="background" />
  </div>
  <div class="container" id="headerbar">
    <div class="row">
      <div class="span12">
        <div id="logo"><img src="/includes/images/sites/0/logo.png"></div>
        <div id="nav">
          <ul>
            <li><a href="/"><i class="visible-phone icon-chevron-right"></i>overview</a></li>
            <li><a href="/html/pricing.html"><i class="visible-phone icon-chevron-right"></i>pricing</a></li>
            <li><a class="login" href="/signup"><i class="visible-phone icon-chevron-right"></i>free trial</a></li>
            <li><a href="/html/help-and-support.html"><i class="visible-phone icon-chevron-right"></i>help and support</a></li>
            <li><a href="/login"><i class="visible-phone icon-chevron-right"></i>login</a></li>
          </ul>
        </div>
      </div>
    </div>
  </div>
  <cfif paramValue("rc.requestData.page.name","") eq "homepage.html">
    <cfoutput>#renderView()#</cfoutput>
  <cfelse>
  <div class="container">

    <div class="row" id="main">
      <cfif paramValue("rc.requestData.page.showLinks",false) AND ArrayLen(paramValue("rc.requestData.page.links",[]))>
        <div class="span3">
          <cfoutput>#renderView(view="modules/sums/templates/links")#</cfoutput>
        </div>
        <div class="span9">
          <cfoutput>#renderView()#</cfoutput>
        </div>
      <cfelse>
        <div class="span12">
          <cfoutput>#renderView()#</cfoutput>
        </div>
      </cfif>
    </div>
  </div>
  </cfif>
  <div class="container" id="footer">
      Copyright &copy; <cfoutput>#Year(now())#. Building Vine Limited. All rights reserved.</cfoutput>
  </div>
<cfif isUserInRole("staff")>
  <link type="text/css" rel="stylesheet" href="/includes/javascript/jQuery/css/Aristo/jQueryUI.css"></link>
  <div id="dialog"></div>
  <cfoutput>#renderView(view="admin/menu",module="sums")#</cfoutput>
</cfif>
</body>
</html>
