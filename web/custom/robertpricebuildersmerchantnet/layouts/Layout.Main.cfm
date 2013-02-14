<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>
  <script type="text/javascript" src="https://www.google.com/jsapi"></script>
<Cfheader name="Cache-Control" value="max-age=0, no-cache, no-store">
<Cfheader name="Accept-Ranges" value="bytes">
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8"/>
<link rel="shortcut icon" href="/favicon.ico" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
<LINK rel="shortcut icon" type=image/x-icon href="/favicon.ico">
<LINK rel=icon type=image/ico href="/favicon.ico">
<link href='http://fonts.googleapis.com/css?family=Droid+Sans:400,700' rel='stylesheet' type='text/css'>

<title>Turnbull.net</title>
<script language="javascript" type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.min.js"></script>
<script language="javascript" type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.16/jquery-ui.js"></script>
<script src="https://www.buildingvine.com/includes/javascript/jQuery/jQuery.zoom.js" type="text/javascript" language="javascript"></script>
<cfoutput><script language="javascript" type="text/javascript" src="/includes/javascript/jQuery/jQuery.buildLink.js"></script></cfoutput>
<cfset getMyPlugin(plugin="jQuery").getDepends("","main,homeaccordion,accordion,filter","main,nav,tabs,shortcuts,divtables",false)>
<cfset getMyPlugin(plugin="jQuery").getDepends("tooltip,titleAlert,bbq,jstree,localScroll,scroll,buildLink,address,tip,tipsy,form,block,cookie,cycle,easing.1.3","tablecloth,calendar/calendar,promotions/fullList","promotions,documents/documents,documents/uploadify,dashboard/overview",true,"eGroup")>
<cfset getMyPlugin(plugin="jQuery",module="bv").getDepends("","","public/signup,secure/main,secure/menu,secure/products/products,secure/products/standard,secure/documents/documents")>
<cfoutput>#renderView(view="stylesheets",cache="true",module="eGroup")#

</cfoutput>

<meta http-equiv="content-type" content="text/html;charset=ISO-8859-2" />

</head>

<body>
  <cfoutput><input id="httpHost" type="hidden" value="http://#cgi.http_host#" /></cfoutput>
  <cfoutput><input id="isSES" value="#event.isSES()#" type="hidden" /></cfoutput>
  <cfoutput><input id="alf_ticket" value="#rc.sess.buildingVine.user_ticket#" type="hidden" /></cfoutput>
  <cfoutput>  <input type="hidden" id="urltoken" value="#session.URLToken#" /><input type="hidden" id="cfid" value="#cfid#" /><input type="hidden" id="cftoken" value="#cftoken#" /><input type="hidden" id="jsessionid" value="#jsessionid#" /></cfoutput>
<div id="wrap" class="glow">
  <div id="container">
    <div id="topwhite">
      <cfoutput>
      <div id="logo_acme">
        <a href="/" title="return to homepage"><img src="/includes/images/logo_60.png" border="0" alt="eGroup" /></a>
      </div>

      <div class="siteSearch form-signUp">
        <cfif isUserInRole("member")>
        <label class="s" for="contactSearch">Search:</label>
        <input class="Aristo" size="25" id="directorySearch" type="text" name="query" />

        </cfif>
      </div>
      <br class="clear" />

      <div id="grey">
        <div id="greyinner">
          <div id="loginInfo">
            <p>logged in as <a href="/user/index/id/#rc.sess.BMNet.contactID#">#rc.sess.BMNet.name#</a> (<a href="#bl('login.logout')#">logout</a>)</p>
          </div>
          <div id="topnav">
            <ul>
              <li><a class="#Iif(event.getCurrentHandler() eq 'feed','"active"','""')# feed" href="/">Home</a></li>
              <li><a class="#Iif(event.getCurrentHandler() eq 'sales','"active"','""')# sales" href="/sales">Sales</a></li>
              <li><a class="#Iif(event.getCurrentHandler() eq 'company' AND rc.type_id eq 1,'"active"','""')# customers" href="/company/index/type_id/1">Customers</a></li>
              <li><a class="#Iif(event.getCurrentHandler() eq 'company' AND rc.type_id eq 2,'"active"','""')# suppliers" href="/company/index/type_id/2">Suppliers</a></li>
              <li><a class="#Iif(event.getCurrentHandler() eq 'products','"active"','""')# products" href="/products">Products</a></li>
              <li><a rel="maincontent" class="#Iif(event.getCurrentModule() eq 'bv','"active"','""')# documents" href="/bv/documents/getFolder?siteID=#rc.sess.buildingVine.siteID#">Documents</a></li>
              <cfif rc.sess.eGroup.username neq ""><li><a class="#Iif(event.getCurrentModule() eq 'eGroup','"active"','""')#egroup" href="/eGroup/dashboard">#Ucase(rc.moduleSettings.eGroup.settings.siteName)#</a></li></cfif>
            </ul>
          </div>
          <div id="editMode">
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
    </cfoutput>
    <div id="content">
      <div id="maincontent" class="leftCol">
        <cfoutput>#renderView()#</cfoutput>
      </div>
    </div>
    <div id="leftmenu" class="leftMenu">
      <div id="shortCuts">
      <cftry>
        <cfoutput>#renderView("shortcuts/#event.getCurrentHandler()#")#</cfoutput>
        <cfcatch type="any"></cfcatch>
      </cftry>
      </div>
    </div>
    <div style="clear:both;"></div>
  </div>
</div>

<div class="Aristo" id="dialog"></div>
<div id="defaultDiag">
<div class="form-container">
  <form>
    <cfoutput>
    <fieldset>
      <legend>Filter Chart</legend>
      <div>
        <cfset accVal = "">
        <cfset acc = ListFind(rc.filterColumn,"account_number")>
        <cfif acc neq 0>
          <cfset accVal = ListGetAt(rc.filterValue,acc)>
        </cfif>
        <label for="account_number">Acc/No</label>
        <input class="filter" type="text" value="#accVal#" id="account_number" />
      </div>
      <div>
        <cfset prodVal = "">
        <cfset prod = ListFind(rc.filterColumn,"product_code")>
        <cfif prod neq 0>
          <cfset prodVal = ListGetAt(rc.filterValue,prod)>
        </cfif>
        <label for="product_code">Product Code</label>
        <input class="filter" type="text" value="#prodVal#" id="product_code" />
      </div>
      <div>
        <cfset salesVal = "">
        <cfset smn = ListFind(rc.filterColumn,"salesman")>
        <cfif smn neq 0>
          <cfset salesVal = ListGetAt(rc.filterValue,smn)>
        </cfif>
        <label for="salesman">Salesman</label>
        <input class="filter" type="text" value="#salesVal#" id="salesman" />
      </div>
      <div>
        <cfset branchVal = "">
        <cfset bnc = ListFind(rc.filterColumn,"branch_id")>
        <cfif bnc neq 0>
          <cfset branchVal = ListGetAt(rc.filterValue,bnc)>
        </cfif>
        <label for="branch_id">Branch ID</label>
        <input class="filter" type="text" value="#branchVal#" id="branch_id" />
      </div>
      <input type="button" class="doIt" value="redo chart &raquo;" id="doChart" />
    </fieldset>
    </cfoutput>
  </form>
</div>
</div>



<script type="text/javascript">

  var _gaq = _gaq || [];
  _gaq.push(['_setAccount', 'UA-866816-33']);
  _gaq.push(['_trackPageview']);

  (function() {
    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
  })();

</script>
</body>
</html>
