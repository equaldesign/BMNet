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
  #getMyPlugin(plugin="jQuery").getDepends("bootstrap,bbq,address,form,block,cycle,easing.1.3,cookie,tp,sr","","bootstrap,bootstrap-responsive.min,jQuery/sr/settings",false)#
</cfoutput>
  <link href="/includes/style/sites/13/style.css" rel="stylesheet" type="text/css" media="screen" />
  <link href="/includes/style/sites/13/prettyPhoto.css" rel="stylesheet" type="text/css" media="screen" />
  <link href="http://d25ke41d0c64z1.cloudfront.net/images/icon.css" rel="stylesheet" type="text/css" />
</head>

<body>
<cfif paramValue("rc.requestData.page.name","") eq "homepage.html">
<section class="message-top">
    <div>
    <button type="button" class="close" data-dismiss="alert">&times;</button>
            <div class="notification container">

            <strong>Hey!</strong> This may be your important marketing notification ;-).
        </div>
    </div>
</section>
</cfif>
<header id="header">
    <div class="container">
        <div class="row">
            <div class="span5 logo">
                <a href="/"><cfoutput>#request.site.name#</cfoutput></a>
            </div>

                <nav id="menu" class="pull-right">
                    <ul>
                        <li class="current"><a href="/">Home</a></li>
                        <li><a href="/mxtra/shop/category">Shop</a></li>
                        <li><a href="/mxtra/account">Your Account</a></li>
                    </ul>
                </nav>

        </div>

    </div>
</header>
<cfif paramValue("rc.requestData.page.name","") neq "homepage.html">
  <div class="container">
    <div class="row">
      <div class="span3" id="leftMenu">
        <cfoutput>#renderView(view="shop/catTree",cache=false,module="mxtra")#</cfoutput>
      </div>
      <div class="span9">
        <cfoutput>#renderView()#</cfoutput>
      </div>
    </div>
  </div>
<cfelse>
  <cfoutput>#renderView()#</cfoutput>
</cfif>



<!--footer-->
<footer id="footer">
    <div class="container">
    <div class="row">
        <div class="span3">
            <h3>Text Widget</h3>
            <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut in lacus rhoncus elit egestas luctus. Nullam at lectus augue.</p>
            <p>Ut tristique consectetur elit, sed tincidunt elit iaculis in. In hac habitasse platea dictumst. Curabitur condimentum justo sed urna porttitor aliquam.</p>
        </div>
        <div class="span3">
            <h3>Flickr Photos</h3>
            <ul class="flickr clearfix"></ul>
        </div>
        <div class="span3">
            <h3>Contact Form</h3>
            <form id="contact" class="form-horizontal" method="post">
                <div class="control-group">
                    <label class="control-label" for="inputName">Name</label>
                    <div class="controls">
                        <input type="text" id="inputName" placeholder="Name" name="inputName">
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label" for="inputEmail">Email</label>
                    <div class="controls">
                        <input type="text" id="inputEmail" placeholder="Email" name="inputEmail">
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label" for="inputMessage"></label>
                    <div class="controls">
                        <textarea rows="3" id="inputMessage" name="inputMessage"></textarea>
                    </div>
                </div>
                <div class="submit-div">
                    <input type="submit" class="btn pull-right " value="SUBMIT!">
                </div>
            </form>
        </div>
        <div class="span3">
            <h3>Address</h3>
            <address>
                Companyname inc.<br>
                London,  Baker Street, 90210<br>
                <i class="myicon-phone"></i>(123) 456-7890<br>
                <i class="myicon-mail"></i>info@dxthemes.com
            </address>
            Ut eu nulla eget massa blandit eleifend vel sedis lacus. Sed at viverra nulla. Fusce vel adipisci odio. Phasellus commodo, mauris eget pharetra scelerisque, est justo lacinia tortor.
        </div>
    </div>
    </div>
</footer>

<!--footer menu-->
<section id="footer-menu">
    <div class="container">
        <div class="row">
            <div class="span8 hidden-phone">
                <ul>
                    <li><a href="#">Home</a></li>
                    <li><a href="#">About</a></li>
                    <li><a href="#">Portfolio</a></li>
                    <li><a href="#">Blog</a></li>
                    <li><a href="#">Service</a></li>
                    <li><a href="#">Contact</a></li>
                </ul>
            </div>
            <p class="span4"><span class="pull-right">Copyright 2012 - All Rights Reserved</span></p>
        </div>
    </div>
</section>
</body>
<cfif isUserInRole("staff")>
  <link type="text/css" rel="stylesheet" href="/includes/javascript/jQuery/css/Aristo/jQueryUI.css"></link>
  <div id="dialog"></div>
  <cfoutput>#renderView(view="admin/menu",module="sums")#</cfoutput>
</cfif>
<!-- Mirrored from wbpreview.com/previews/WB0JP1087/ by HTTrack Website Copier/3.x [XR&CO'2010], Thu, 06 Dec 2012 18:51:22 GMT -->
</html>