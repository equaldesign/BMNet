<!DOCTYPE html>
<!--[if lt IE 7 ]><html class="ie ie6" lang="en"> <![endif]-->
<!--[if IE 7 ]><html class="ie ie7" lang="en"> <![endif]-->
<!--[if IE 8 ]><html class="ie ie8" lang="en"> <![endif]-->
<!--[if (gte IE 9)|!(IE)]><!--><html lang="en"> <!--<![endif]-->
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

  <link href='http://fonts.googleapis.com/css?family=Lato:100,300,400,700,900' rel='stylesheet' type='text/css'>
  <script language="javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
  <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/jquery-ui.js"></script>
<cfoutput>
  #getMyPlugin(plugin="jQuery").getDepends("bootstrap,bbq,address,form,block,cycle,easing.1.3,cookie,tp,sr,lightbox,spin,loadNicely","images,sites/13/bootshop","bootstrap,bootstrap-responsive.min,jQuery/sr/settings",false)#
</cfoutput>
  <link href="/includes/style/sites/13/style2.css" rel="stylesheet" type="text/css" media="screen" />
  <link href="http://d25ke41d0c64z1.cloudfront.net/images/iconset.css" rel="stylesheet" type="text/css" />
</head>

<body>
<div id="header">
<div class="container">
<div id="welcomeLine" class="row">
  <div class="span6">Welcome! User</div>
  <div class="span6">
    <div class="pull-right">
      <span class="btn btn-mini">&pound<cfoutput>#request.mxtra.basket.total#</cfoutput></span>
      <a href="/mxtra/basket"><span class="btn btn-mini active"><i class="icon-cart"></i> [ <cfoutput>#ArrayLen(request.mxtra.basket.items)#</cfoutput> ] Item<cfif ArrayLen(request.mxtra.basket.items) neq 1>s</cfif> in your cart </span> </a>
    </div>
  </div>
</div>
<!-- Navbar ================================================== -->
<div id="logoArea" class="navbar">
<a data-target="#topMenu" data-toggle="collapse" class="btn btn-navbar">
  <span class="icon-bar"></span>
  <span class="icon-bar"></span>
  <span class="icon-bar"></span>
</a>
  <div class="navbar-inner">
    <cfoutput><a class="brand" href="/#bsl('?h')#">#request.site.name#</a></cfoutput>
    <ul id="topMenu" class="nav pull-right">
     <li class=""><a href="special_offer.html">Specials Offer</a></li>
   <li class=""><a href="normal.html">Delivery</a></li>
   <li class=""><a href="contact.html">Contact</a></li>
   <li class="dropdown">
    <a data-toggle="dropdown" class="dropdown-toggle" href="#"><span class="btn">Login <b class="caret"></b></span></a>
    <div class="dropdown-menu">
    <form class="form-horizontal loginFrm" action="/eunify/login/doLogin">
      <div class="control-group">
      <input name="j_username" type="text" class="span2" id="inputEmail" placeholder="Email">
      </div>
      <div class="control-group">
      <input name="j_password" type="password" class="span2" id="inputPassword" placeholder="Password">
      </div>
      <div class="control-group">
      <label class="checkbox">
      <input type="checkbox"> Remember me
      </label>
      <button type="submit" class="btn pull-right">Sign in</button>
      </div>
    </form>
    </div>
  </li>
    </ul>
  <form method="post" action="/mxtra/shop/product/search" class="navbar-search">
    <input id="srchFld" type="text" placeholder="I'm looking for ..." class="search-query span5"/>
  </form>
  </div>
</div>
</div>
</div>

<div id="mainBody">
  <div class="container">
    <div class="row">
      <div id="sidebar" class="span3">
        <div class="navbar">
          <a data-target="#sideManu" data-toggle="collapse" class="btn btn-navbar">
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
          </a>
        </div>
        <cfoutput>#renderView(view="shop/catTree",cache=false,module="mxtra")#</cfoutput>
      </div>
      <div class="span9" id="mainPanel">
        <cfoutput>#renderView()#</cfoutput>
      </div>
    </div>
  </div>
</div>

<!-- Footer ================================================================== -->
  <hr class="soft">
  <div  id="footerSection">
  <div class="container">
    <div class="row">
      <div class="span3">
        <h5>ACCOUNT</h5>
        <a href="login.html">YOUR ACCOUNT</a>
        <a href="login.html">PERSONAL INFORMATION</a>
        <a href="login.html">ADDRESSES</a>
        <a href="login.html">DISCOUNT</a>
        <a href="login.html">ORDER HISTORY</a>
       </div>
      <div class="span3">
        <h5>INFORMATION</h5>
        <a href="contact.html">CONTACT</a>
        <a href="register.html">REGISTRATION</a>
        <a href="legal_notice.html">LEGAL NOTICE</a>
        <a href="tac.html">TERMS AND CONDITIONS</a>
        <a href="faq.html">FAQ</a>
       </div>
      <div class="span3">
        <h5>OUR OFFERS</h5>
        <a href="#">NEW PRODUCTS</a>
        <a href="#">TOP SELLERS</a>
        <a href="special_offer.html">SPECIAL OFFERS</a>
        <a href="#">MANUFACTURERS</a>
        <a href="#">SUPPLIERS</a>
       </div>
      <div id="socialMedia" class="span3 pull-right">
        <h5>SOCIAL MEDIA </h5>
        <a href="#"><img width="60" height="60" src="themes/images/facebook.png" title="facebook" alt="facebook"/></a>
        <a href="#"><img width="60" height="60" src="themes/images/twitter.png" title="twitter" alt="twitter"/></a>
        <a href="#"><img width="60" height="60" src="themes/images/rss.png" title="rss" alt="rss"/></a>
        <a href="#"><img width="60" height="60" src="themes/images/youtube.png" title="youtube" alt="youtube"/></a>
       </div>
     </div>
     <hr class="soft">
    <p class="pull-right">&copy; Bootshop</p>
  </div><!-- Container End -->
  </div>
<cfif isUserInRole("staff")>
  <link type="text/css" rel="stylesheet" href="/includes/javascript/jQuery/css/Aristo/jQueryUI.css"></link>
  <div id="dialog"></div>
  <cfoutput>#renderView(view="admin/menu",module="sums")#</cfoutput>
</cfif>
</body>
</html>