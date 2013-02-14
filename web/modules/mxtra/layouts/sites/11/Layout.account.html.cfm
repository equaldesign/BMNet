<cfsetting showdebugoutput="no">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>


<!---<script src="http://www.buildingvine.com/includes/javascript/dataAPI.js" type="text/javascript" language="javascript"></script>--->
<link href="/includes/styles/sites/11/style.css" rel="stylesheet">
<link href="/includes/styles/sites/11/invoicing.css" rel="stylesheet">
<link type="text/css" rel="stylesheet" href="/includes/javascript/jQuery/css/Aristo/jQueryUI.css" />
<script type="text/javascript" src="/includes/javascript/jQuery/jQuery.js"></script>
<script type="text/javascript" src="/includes/javascript/jQuery/jQueryUI.js"></script>
<title>Turnbull building Supplies </title>
<link rel="shortcut icon" type="image/x-icon" href="/includes/images/turnbull/favicon.ico" />
<link rel="icon" type="image/x-icon" href="/includes/images/turnbull/favicon.ico" />

</head>
<body>
<div id="page">
    <div id="pageheader">
    <div id="logo"></div>
    <div id="basket_overview">
	<cfif getAuthUser() neq "">
	   <cfoutput>#renderView(view="shop/quote/overview",module="merchantXtra")#</cfoutput>
	<cfelse>
    	<cfoutput>#renderView(view="shop/basket_overview",module="merchantXtra")#</cfoutput>
	</cfif>
     
    </div>
    <div id="header">
      <cfif getAuthUser() neq "">
        <div id="loggedin">
        <cfoutput>
          <h4>You are logged in as #getModel(module="merchantXtra",name="invoicing.account").getCustomer(getAuthUser()).name#. <a href="/mxtra/access/main/logout">Log out &raquo;</a></h4>
        </cfoutput>
        </div>
      </cfif>
    </div>
  </div>
  <div id="topnav">
    <div id="buttons">
    <ul>
      <li class="first"><a class="home" href="/">home</a></li>
      <li><a class="branches" href="/?page=4953">store finder</a></li>
      <li><a class="account" href="/mxtra/account">your account</a></li>
      <li><a class="specials" href="/mxtra/shop/product/specials">special offers</a></li>
      <li class="last"><a class="contact" href="/html/contact-us">contact us</a></li>
    </ul>
  </div>
  </div>
  <div id="pagebody">
    <cfoutput>#renderView("account/accountMenu")#</cfoutput>
    <cfoutput><div id="mainp">
    </cfoutput>

      <!-- fresh get -->
      <cfoutput>#renderView()#</cfoutput>
      <div class="clearer"></div>
    </div>
    <div class="clearer"></div>
  </div>
  <div class="clearer"></div>

  <div id="footer">
    <cfoutput>
    <div id="systemInfo">
            <div id="cemcoLogo"></div>
    </div>
    <div id="footerlinks" align="center">
      <p>Copyright &copy; 2001-#DateFormat(now(),"YYYY")# Turnbulls</p>
    </div>
    <div id="ebizPower"><a href="http://www.ebiz.co.uk" target="_blank"><img src="http://www.ebiz.co.uk/images/eBizLogo.png" border="0"></a></div>
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
