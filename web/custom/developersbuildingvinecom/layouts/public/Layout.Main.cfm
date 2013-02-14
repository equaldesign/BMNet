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
  <title>#paramValue("rc.requestData.page.title","BuildersMerchant.net")#</title>
  <meta name="description" content="#paramValue("rc.requestData.page.attributes.customProperties.description","")#" />
  <meta name="keywords" content="#paramValue("rc.requestData.page.attributes.customProperties.keywords","")#" />

</cfoutput>

<link href='http://fonts.googleapis.com/css?family=Lato:100,300,400,700,900' rel='stylesheet' type='text/css'>
  <script language="javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
  <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/jquery-ui.js"></script>
    <script language="javascript" src="/includes/javascript/sites/0/main.js"></script>
<cfoutput>
  #getMyPlugin(plugin="jQuery").getDepends("prettify,bootstrap,bbq,address,form,block,cycle,easing.1.3,cookie","","jQuery/prettify,bootstrap,bootstrap-responsive.min",false)#
</cfoutput>
  <link href="/includes/style/sites/10/styles.css" rel="stylesheet" type="text/css" media="screen" />
</head>

<body>

  <div class="navbar navbar-inverse navbar-fixed-top">
    <div class="navbar-inner">
      <div class="container">
        <button type="button" class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
        </button>
        <a class="brand" href="./index.html"><cfif paramValue("rc.requestData.page.name","") neq "homepage.html"><img src="/includes/images/sites/10/logo.png" /></cfif></a>
        <div class="nav-collapse collapse">
          <ul class="nav">
            <li class="active">
              <a href="/">Home</a>
            </li>
            <li class="">
              <a href="/html/integration-guides.html">Get started</a>
            </li>
            <li class="">
              <a href="/html/integration-guides.html">Integration Guides</a>
            </li>
          </ul>
        </div>
      </div>
    </div>
  </div>
  <div <cfif paramValue("rc.requestData.page.name","") neq "homepage.html"> class="shiftLogo"<cfelse> class="tinyShift"</cfif>>
    <cfoutput>#renderView()#</cfoutput>
  </div>
  <div id="footer">
    <div class="container">
      Copyright &copy; <cfoutput>#Year(now())#. Building Vine Limited. All rights reserved.</cfoutput>
    </div>
  </div>
<cfif isUserInAnyRole("staff,ebiz")>
  <link type="text/css" rel="stylesheet" href="/includes/javascript/jQuery/css/Aristo/jQueryUI.css"></link>
  <div id="dialog"></div>
  <cfoutput>#renderView(view="admin/menu",module="sums")#</cfoutput>

</cfif>
</body>
</html>
