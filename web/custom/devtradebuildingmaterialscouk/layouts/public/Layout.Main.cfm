<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<script type="text/javascript">
    (function() {
        if (typeof window.janrain !== 'object') window.janrain = {};
        if (typeof window.janrain.settings !== 'object') window.janrain.settings = {};


        janrain.settings.tokenUrl = 'http://<cfoutput>#cgi.http_host#</cfoutput>/social/signin';

        function isReady() { janrain.ready = true; };
    if (document.addEventListener) {
      document.addEventListener("DOMContentLoaded", isReady, false);
    } else {
      window.attachEvent('onload', isReady);
    }

    var e = document.createElement('script');
    e.type = 'text/javascript';
    e.id = 'janrainAuthWidget';

    if (document.location.protocol === 'https:') {
      e.src = 'https://rpxnow.com/js/lib/tradebuild/engage.js';
    } else {
      e.src = 'http://widget-cdn.rpxnow.com/js/lib/tradebuild/engage.js';
    }

    var s = document.getElementsByTagName('script')[0];
    s.parentNode.insertBefore(e, s);
    })();
    </script>
<cfoutput>
  <title>#paramValue("rc.requestData.page.title","BuildersMerchant.net")#</title>
  <meta name="description" content="#paramValue("rc.requestData.page.attributes.customProperties.description","")#" />
  <meta name="keywords" content="#paramValue("rc.requestData.page.attributes.customProperties.keywords","")#" />

<link href='http://fonts.googleapis.com/css?family=Lato:100,300,400,700,900' rel='stylesheet' type='text/css'>
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
<script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/jquery-ui.js"></script>
#getMyPlugin(plugin="jQuery").getDepends("bootstrap,bbq,address,form,validate,block,cycle,easing.1.3,cookie,dataTables,bindWithDelay,dataTables","sites/4/main","bootstrap,bootstrap-responsive.min,sites/4/landing,sites/4/theme",false)#
</cfoutput> 
<cfset getMyPlugin(plugin="jQuery").getDepends("","","tables",false,"eunify")>
<link type="text/css" rel="stylesheet" href="/includes/javascript/jQuery/css/Aristo/jQueryUI.css"></link>
<script src="https://www.buildingvine.com/includes/javascript/api/js.js" type="text/javascript" language="javascript"></script>
</head>

<body>

	<div class="wrapper" id="main">
		<div class="navbar navbar-fixed-top">
		  <div class="navbar-inner">
		    <div class="container">
		      <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
		        <span class="icon-bar"></span>
		        <span class="icon-bar"></span>
		        <span class="icon-bar"></span>
		      </a>
		      <a class="brand" href="/">
            <img src="/includes/images/sites/4/logo.png" border="0" />
		      </a>

						<cfif getAuthUser() neq "">
	            <cfset currentUser = getModel("eunify.ContactService").getContact(request.BMNet.contactID,3,request.siteID)> 
	            <cfoutput>
	            <ul class="loggedIn nav pull-right">
			          <li class="dropdown">
			            <a data-toggle="dropdown" class="dropdown-toggle " href="##">
			              #currentUser.first_name# #currentUser.surname# <b class="caret"></b>
			            </a>
			            <ul class="dropdown-menu">
										<li><a href="/quote/home"><i class="icon-account"></i> Your Account</a></li>
			              <li>
			                <a href="/eunify/contact/edit?id=#request.BMNet.contactID#"><i class="icon-lock"></i> Change Password</a>
			              </li>
			              <li class="divider"></li>
			              <li>
			                <a href="/login/logout"><i class="icon-off"></i> Logout</a>
			              </li>
			            </ul>
			          </li>
								<li><img class="thumbnail" width="25" alt="Profile Picture" src="https://secure.gravatar.com/avatar/#lcase(Hash(lcase(getAuthUser())))#?size=25&amp;d=https://www.buildingvine.com/includes/images/secure/blankAvatar.jpg" /></li>
			        </ul>
				      </cfoutput>
	          <cfelse>
			  	    <form id="loginForm" class="hidden-phone pull-right form-horizontal" action="/eunify/login/doLogin" method="post">
						    <div>
						      <div class="input-prepend">
						        <span class="add-on">@</span><input placeholder="email address" type="text" class="input" name="j_username">
						      </div>
						      <input placeholder="password" type="password" class="input" name="j_password">
						      <input type="submit" class="btn btn-success" value="LOGIN &raquo;">
						    </div>
						    <div class="pull-right" id="socialSignIn">
						      Or use our social signin: <a href="#" class="janrainEngage"><img src="https://www.buildingvine.com/includes/images/socialIcons.png" border="0"></a>
						    </div>
						    <div class="">
						      <label class="checkbox inline">
						        <input type="checkbox" id="rememberme" value="true"> Remember Me?
						      </label>
						    </div>
						  </form>
	          </cfif>
		       <div class="nav-collapse">
                   <ul class="mainNav nav pull-right">
		          <li class="active"><a href="/">Home</a></li>
		          <li><a href="/html/trade-professionals.html">Trade Professionals</a></li>
							<li><a href="/html/merchants.html">Merchants</a></li>
		          <li><a href="/html/faq.html">FAQ</a></li>
		          <li><a href="/html/contact-us.html">Contact Us</a></li>
		        </ul>
		      </div><!--/.nav-collapse -->
		    </div> <!-- /container -->
		  </div> <!-- /navbar-inner -->
	  </div>
		<cfif isDefined("rc.requestdata.page.name") AND rc.requestdata.page.name eq "homepage.html">
		<div id="landing">
		  <div class="inner">
		    <div class="container">
		      <div class="row">
		        <div class="span6 landing-text">
		          <h1>It's <strong>our</strong> job to get <strong>you</strong> the best price for <strong>your</strong> job</h1>
		          <p>We search over 300 independent builders, plumbers and timber merchants to get you the best price possible. You can then pick the quotes you like the most.  It couldn't be simpler, and it's <strong>completely free</strong>.</p>
		          <h2>Reduce your costs now!</h2>
							<p class="landing-actions">
		            <a href="/quote/do/new" class="btn btn-large btn-success">Get started now for <strong>free</strong></a>
		            &nbsp;&nbsp;<a href="/html/faq.html" class="btn btn-info btn-large">Find out more</a>
		          </p>
							<p><a class="white" href="/html/about-us.html">Seen others offering a similar service? Find out how we are different...</a></p>
		        </div> <!-- /landing-text -->
		        <div class="span6">
              <div id="list" class="alert alert-success hidden-phone">
                <ol class="faq-list">
                  <li id="faq-1">
                    <div class="faq-icon">
                      <div class="circle-icon faq-circle-icon">
                        <div>1</div>
                      </div>
                    </div>
                    <div class="faq-text">
                       <h3>Manage your own estimates</h3>
                       <p>Create your own estimates for your customers, and manage them through our website</p>
                    </div>
                  </li>
                  <li id="faq-2">
                    <div class="faq-icon">
                      <div class="circle-icon faq-circle-icon">
                        <div>2</div>
                      </div>
                    </div>
                    <div class="faq-text">
                      <h3>Get the best price possible</h3>
                      <p>Forward your requirements onto local Merchants, to get the best price possible.</p>
                    </div>
                  </li>
                  <li id="faq-3">
                    <div class="faq-icon">
                      <div class="circle-icon faq-circle-icon">
                        <div>3</div>
                      </div>
                    </div>
                    <div class="faq-text">
                      <h4>You choose the deal that suits</h4>
                      <p>You get your quotes delivered via email, which you can act upon and complete direct with the merchants</p>
                    </div>
                  </li>
                </ol>
              </div>

		        </div>
		      </div> <!-- .row -->
		    </div> <!-- /container -->
		  </div> <!-- /inner -->
		</div>
		<cfelseif paramValue("rc.requestData.page.attributes.customProperties.pagetitle","") neq "">
    <div id="landing">
      <div class="inner">
        <div class="container">
          <div class="row">
            <div class="span12">
              <h1><cfoutput>#paramValue("rc.requestData.page.attributes.customProperties.pagetitle","")#</cfoutput></h1>
            </div>
          </div>
        </div>
			</div>
		</div>
		</cfif>
		<div class="container m10top">
			 <cfif getAuthUser() neq "" AND rc.showMenu>
				 <br />
				 <div class="row">
				   <div class="span3">
				   	  <cfoutput>#renderView(view="modules/quote/account/#request.BMnet.company_type#/accountMenu")#</cfoutput>
				   </div>
					 <div class="span9">
					 	<cfoutput>#renderView()#</cfoutput>
					 </div>
				 </div>
			 <cfelse>
         <div class="row">
           <div class="span12">
             <cfoutput>#renderView()#</cfoutput>
           </div>
         </div>
			 </cfif>
	    </div>
			<div class="push"><!--//--></div>
	  </div>
		<cfif isDefined("rc.requestdata.page.name") AND rc.requestdata.page.name eq "homepage.html">
			<div id="screenshots">
			  <div class="inner">
			    <div class="container">
			      <div class="row">
			        <div class="span4">
								<h3><div class="faq-icon"><div class="circle-icon faq-circle-icon"><div>1</div></div></div>You detail your requirments</h3>
			          <p>All you need to do is create a quotation request by entering some details (where you are, what products you need, when you need them).</p>
								<p>All in all, it takes less than 10 minutes from your phone, laptop or desktop PC.</p>
			        </div> <!-- /span4 -->
			        <div class="span4">
			          <h3><div class="faq-icon"><div class="circle-icon faq-circle-icon"><div>2</div></div></div>We submit it to local merchants</h3>
			          <p>We put your requirements out to tender (you remain annoymous <strong>at all times during this process</strong>), and submit them to independent merchants close to your location, from our network of over 300 merchants.</p>
			        </div> <!-- /span4 -->
			        <div class="span4">
			          <h3><div class="faq-icon"><div class="circle-icon faq-circle-icon"><div>3</div></div></div>Quotations arrive in your inbox</h3>
			          <p>Within 24 hours you should get your quotations delivered directly to your inbox; on your phone, laptop or desktop - wherever you are.</p>
			        </div> <!-- /span4 -->
			      </div> <!-- /row -->
			    </div> <!-- /container -->
			  </div> <!-- /inner -->
			</div>
		</cfif>
	</div>
	<div id="extra">
    <div class="inner">
      <div class="container">
        <div class="row">
          <div class="span4">
            <h3>Quick Links</h3>
            <ul class="footer-links clearfix">
              <li><a href="/">Home</a></li>
              <li><a href="/html/about-us.html">Trade Professionals</a></li>
              <li><a href="/html/merchants.html">Merchants</a></li>
              <li><a href="/html/faq.html">FAQ</a></li>
            </ul>
            <ul class="footer-links clearfix">
              <li><a href="/html/about-us.html">About Us</a></li>
              <li><a href="/html/contact-us.html">Contact Us</a></li>
              <li><a href="/html/terms-of-use.html">Terms of Use</a></li>
              <li><a href="/html/privacy-policy.html">Privacy Policy</a></li>
            </ul>
          </div> <!-- /span4 -->
          <div class="span4">
            <h3>Stay In Touch</h3>
            <p>There are real people behind TradeBuild, so if you have a question or suggestion (no matter how small) please get in touch with us:</p>
            <ul class="social-icons-container">
              <li>
                <a href="javascript:;" class="social-icon social-icon-twitter">
                  Twitter
                </a>
              </li>
              <li>
                <a href="javascript:;" class="social-icon social-icon-googleplus">
                  Google +
                </a>
              </li>
              <li>
                <a href="javascript:;" class="social-icon social-icon-facebook">
                  Facebook
                </a>
              </li>
            </ul> <!-- /extra-social -->
          </div> <!-- /span4 -->
          <div class="span4">
            <h3>Subscribe and get updates</h3>
            <p>Subscribe to our newsletter and get exclusive deals you wont find anywhere else straight to your inbox!</p>
            <form>
              <input type="text" name="subscribe_email" placeholder="Your Email">
              <br>
              <button class="btn ">Subscribe</button>
            </form>
          </div> <!-- /span4 -->
        </div> <!-- /row -->
      </div> <!-- /container -->
    </div> <!-- /inner -->
  </div>
	<footer class="hidden-phone" id="footer">
		  <div class="inner">
		    <div class="container">
		      <div class="row">
		        <div id="footer-copyright" class="span4">
		          &copy; <cfoutput>#Year(now())#</cfoutput> Building Vine Limited.
		        </div> <!-- /span4 -->
		        <div id="footer-terms" class="span8">
		        	By using this site you agree to our terms of use and privacy policy.
		        </div> <!-- /span8 -->
		      </div> <!-- /row -->
		    </div> <!-- /container -->
		  </div> <!-- /inner -->
		</footer>
<cfif isUserInRole("admin")>
  <cfoutput>#renderView(view="admin/menu",module="sums")#</cfoutput>
</cfif>
<div id="dialog"></div>
<script type="text/javascript" src="https://maps.google.com/maps/api/js?sensor=false"></script>

</body>
</html>
