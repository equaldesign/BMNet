<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
  <script type="text/javascript" src="https://www.google.com/jsapi"></script>
  <cfheader name="Cache-Control" value="max-age=0, no-cache, no-store">
  <cfheader name="Accept-Ranges" value="bytes">
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8"/>
<link rel="shortcut icon" href="/favicon.ico" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<LINK rel="shortcut icon" type=image/x-icon href="/favicon.ico">
<LINK rel=icon type=image/ico href="/favicon.ico">
<link href='http://fonts.googleapis.com/css?family=Droid+Sans:400,700' rel='stylesheet' type='text/css'>

<title>BuildersMerchant.net</title>

<script language="javascript" type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
<script language="javascript" type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.18/jquery-ui.min.js"></script>
<script language="javascript" type="text/javascript" src="/includes/javascript/jQuery/jQuery.bootstrap.js"></script>
<link href="/includes/style/bootstrap.css" rel="stylesheet">
<link href="/includes/style/bootstrap-responsive.min.css" rel="stylesheet">
<script src="https://www.buildingvine.com/includes/javascript/jQuery/jQuery.zoom.js" type="text/javascript" language="javascript"></script>
<script type="text/javascript" src="/ckeditor/ckeditor.js"></script>
<script type="text/javascript" src="/ckeditor/adapters/jquery.js"></script>
<cfoutput><script language="javascript" type="text/javascript" src="/includes/javascript/jQuery/jQuery.buildLink.js"></script></cfoutput>
<cfset getMyPlugin(plugin="jQuery").getDepends("dataTables","main,homeaccordion,accordion,filter","sites/2/main,sites/2/nav,tabs,shortcuts,divtables,tables",true,"eunify")>
<cfset getMyPlugin(plugin="jQuery").getDepends("upload,tooltip,titleAlert,bbq,jstree,localScroll,scroll,buildLink,address,tip,tipsy,form,block,cookie,cycle,easing.1.3","tablecloth,calendar/calendar,promotions/fullList","promotions,documents/documents,documents/uploadify,dashboard/overview",true,"eGroup")>
<cfset getMyPlugin(plugin="jQuery",module="bv").getDepends("","","secure/products/products,secure/products/standard,secure/documents/documents")>
<cfoutput>#renderView(view="stylesheets",cache="false",module="eunify")#

</cfoutput>

<meta http-equiv="content-type" content="text/html;charset=ISO-8859-2" />

</head>

<body>
  <cfoutput><input id="httpHost" type="hidden" value="http://#cgi.http_host#" />
  <input id="isSES" value="#event.isSES()#" type="hidden" />
  <input id="currentModule" value="#event.getCurrentModule()#" type="hidden" />
  <input id="alf_ticket" value="#rc.sess.buildingVine.user_ticket#" type="hidden" />

  <div  class="navbar navbar-fixed-top">
    <div class="navbar-inner">
      <div class="container-fluid">
        <div id="logo_acme">
	        <a href="/eunify/feed" title="return to homepage"><img src="/includes/images/sites/2/logo2.png" border="0" alt="eGroup" /></a>
	      </div>
	      <div class="siteSearch">
	      	<form class="form-inline">
					<div class="input-prepend">
            <span class="add-on"><img src="https://d25ke41d0c64z1.cloudfront.net/images/icons/magnifier.png"></span><input class="input-large" name="query" id="directorySearch" size="16" type="text">
          </div>
					</form>
	      </div>
	      <br class="clear" />

	      <div id="grey">
	        <div id="greyinner">
	          <div id="loginInfo">
	            <p>logged in as <a href="/user/index/id/#rc.sess.BMNet.contactID#">#rc.sess.BMNet.name#</a> (<a href="#bl('login.logout')#">logout</a>)</p>
	          </div>
	          <div id="topnav">

							<ul>
	              <li><a class="#Iif(event.getCurrentHandler() eq 'eunify:feed','"active"','""')# feed" href="/eunify">Home</a></li>
	              <li><a class="#Iif(event.getCurrentHandler() eq 'eunify:sales','"active"','""')# sales" href="/eunify/sales">Sales</a></li>
	              <li><a class="#Iif(event.getCurrentHandler() eq 'eunify:company' AND rc.type_id eq 1,'"active"','""')# customers" href="/eunify/company/index/type_id/1">Customers</a></li>
	              <li><a class="#Iif(event.getCurrentHandler() eq 'eunify:company' AND rc.type_id eq 2,'"active"','""')# suppliers" href="/eunify/company/index/type_id/2">Suppliers</a></li>
	              <li><a class="#Iif(event.getCurrentHandler() eq 'eunify:products','"active"','""')# products" href="/eunify/products">Products</a></li>
	              <li><a rel="maincontent" class="#Iif(event.getCurrentModule() eq 'bv','"active"','""')# documents" href="/bv/documents/getFolder?siteID=#rc.sess.buildingVine.siteID#">Documents</a></li>
	              <cfif rc.sess.eGroup.username neq ""><li><a class="#Iif(event.getCurrentModule() eq 'eGroup','"active"','""')#egroup" href="/eGroup/dashboard">#Ucase(rc.moduleSettings.eGroup.settings.siteName)#</a></li></cfif>
	            </ul>
	          </div>
	          <div id="editMode">
	            <a id="publicmode" class="off" href="##">Public website</a>
	            <cfif isUserInARole("edit,admin")>
	              <cfif rc.sess.eGroup.editMode>
	                <a id="editmode" class="on" href="##">turn off edit mode</a>
	              <cfelse>
	                <a id="editmode" class="off" href="##">turn on edit mode</a>
	              </cfif>
	            </cfif>
	          </div>
	        </div>
				</div>
      </div>
    </div>
  </div>
  <div class="container-fluid">
  	<div class="row-fluid">
      <cfif paramValue("rc.showMenu",true)>
      <div class="span3">
				<div id="shortCuts" class="rightMenu">
          <cftry>
				  <cfset handler = ListToArray(event.getCurrentHandler(),":")>
				  <cfif ArrayLen(handler) gte 2>
				    <cfif handler[1] eq "eGroup">
				      <cfset theHandler = "admin">
				      <cfset theModule = "eGroup">
				      #renderView(view="admin/rightMenu",module="#theModule#")#
				    <cfelseif handler[1] eq "bv">
            <cfelse>
				      <cfset theHandler = handler[2]>
				      <cfset theModule = handler[1]>
				      #renderView(view="shortcuts/#theHandler#",module="#theModule#")#
				    </cfif>
				  <cfelse>
				    <cfset theHandler = handler[1]>
				    <cfset theModule = "eunify">
				    #renderView(view="shortcuts/#theHandler#",module="#theModule#")#
				  </cfif>

          <cfcatch type="any"></cfcatch>
          </cftry>
				</div>
	    </div>
      </cfif>
      <cfif paramValue("rc.showMenu",true)>
	      <div class="span9" id="maincontent"><cfoutput>#renderView()#</cfoutput></div>
      <cfelse>
        <div class="span12" id="maincontent"><cfoutput>#renderView()#</cfoutput></div>
      </cfif>
		</div>
	</div>
	</cfoutput>
<div class="Aristo" id="dialog"></div>
</body>
</html>
