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
  <cfset title = paramValue("rc.requestData.page.attributes.customProperties.pagetitle","Building Vine")>
  <cfif title eq "">
    <cfset title = "Building Vine">
  </cfif>
  <title>#title#</title>
  <meta name="description" content="#paramValue("rc.requestData.page.attributes.customProperties.description","")#" />
  <meta name="keywords" content="#paramValue("rc.requestData.page.attributes.customProperties.keywords","")#" />

</cfoutput>

<link href='http://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700,800' rel='stylesheet' type='text/css'>
  <script language="javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
  <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/jquery-ui.js"></script>    
  <link type="text/css" rel="stylesheet" href="/includes/javascript/jQuery/css/Aristo/jQueryUI.css"></link>
<cfoutput>
  #getMyPlugin(plugin="jQuery").getDepends("bootstrap,bbq,address,form,block,cycle,easing.1.3,cookie,tp,sr,tipsy,livequery,scroll","","tipsy,bootstrap,bootstrap-responsive.min,jQuery/sr/settings,sites/14/connect",false)#
</cfoutput>   
<link href="http://d25ke41d0c64z1.cloudfront.net/images/iconset.css" rel="stylesheet" type="text/css" />
</head>

<body>
  

<cfoutput>#renderView()#</cfoutput>
  
  <script type="text/javascript">
var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
</script>
<script type="text/javascript">
try {
var pageTracker = _gat._getTracker("UA-866816-27");
pageTracker._trackPageview();

} catch(err) {}</script>
</body>
</html>
