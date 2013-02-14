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
<cfset getMyPlugin(plugin="jQuery").getDepends("dataTables,filedrop","main,homeaccordion,accordion,filter","sites/3/main,sites/3/nav,tabs,shortcuts,divtables,tables",true,"eunify")>
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
<div class="navbar navbar-fixed-top">
  <div class="navbar-inner">

      <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </a>
      <a class="brand" href="/eunify/feed" title="return to homepage"><img src="/includes/images/sites/3/logo_smll.png" border="0" alt="eGroup" /></a>
      <div class="nav-collapse">
        <ul class="nav">
          <li class="#Iif(event.getCurrentHandler() eq 'eunify:feed','"active"','""')#"><a href="/eunify"><i class="icon-feed"></i>Home</a></li>
          <li class="dropdown #Iif(event.getCurrentHandler() eq 'eunify:sales','"active"','""')#">
            <a class="dropdown-toggle" data-toggle="dropdown" href="##"><i class="icon-sales"></i>Sales <b class="caret"></b></a>
            <ul class="dropdown-menu">
              <li class="nav-header">Statistics</li>
              <li><a href="/eunify/sales/"><i class="icon-piechart"></i>Overview</a></li>
              <li><a href="/eunify/sales/thisMonthMap"><i class="icon-pushpin"></i>Recent Sales Map</a></li>
              <li><a href="/flow/sales"><i class="icon-pushpin"></i>Pipeline</a></li>
              <li><a href="/eunify/sales/ledger"><i class="icon-table-excel"></i>Full Ledger</a></li>
              <li><a href="/eunify/sales/salesfilter?filter=branch_id"><i class="icon-branch"></i>Branch Analysis</a></li>
              <li><a href="/eunify/ecommerce/list"><i class="icon-globe"></i>Online Sales</a></li>
              <li class="divider"></li>
              <li class="nav-header">Warnings</li>
              <li><a href="/eunify/sales/warnings"><i class="icon-alert"></i>Customer Dissapearance</a></li>
              <li><a href="/eunify/sales/warningsMap"><i class="icon-alert"></i>Geographic Dissapearance</a></li>
              <li class="divider"></li>
              <li class="nav-header">Sales People</li>
              <li><a href="/eunify/sales/salesman"><i class="icon-contact"></i>Salesperson Analysis</a></li>
              <li class="divider"></li>
              <li class="nav-header">Branches</li>
              <li><a href="/eunify/sales/salesman"><i class="icon-branch"></i>Salesperson Analysis</a></li>
            </ul>
          </li>
          <li class="dropdown #Iif(event.getCurrentHandler() eq 'eunify:company' AND rc.type_id eq 1,'"active"','""')#">
            <a class="dropdown-toggle" data-toggle="dropdown" href="##"><i class="icon-customers"></i>Customers <b class="caret"></b></a>
            <ul class="dropdown-menu">
              <li><a href="/eunify/company/index/type_id/1"><i class="icon-customers"></i> Customer List</a></li>
               <li class="divider"></li>
              <li><a href="/eunify/company/edit/type/1"><i class="icon-customers"></i> Create New Customer</a></li>
            </ul>
          </li>
          <li class="#Iif(event.getCurrentHandler() eq 'eunify:company' AND rc.type_id eq 2,'"active"','""')#"><a class="suppliers" href="/eunify/company/index/type_id/2"><i class="icon-suppliers"></i>Suppliers</a></li>
          <li class="#Iif(event.getCurrentHandler() eq 'eunify:products','"active"','""')#"><a class="products" href="/eunify/products"><i class="icon-products"></i>Products</a></li>
          <li class="#Iif(event.getCurrentModule() eq 'bv','"active"','""')#"><a rel="maincontent" class="documents" href="/bv/documents/getFolder?siteID=#rc.sess.buildingVine.siteID#"><i class="icon-documents"></i>Documents</a></li>
          <li class="#Iif(event.getCurrentModule() eq 'flo','"active"','""')#"><a rel="maincontent" class="documents" href="/flo/general/index"><i class="icon-flo"></i>Flo</a></li>
          <cfif rc.sess.eGroup.username neq ""><li class="#Iif(event.getCurrentModule() eq 'eGroup','"active"','""')#"><a class="egroup" href="/eGroup/dashboard"><i class="icon-egroup"></i>#Ucase(rc.moduleSettings.eGroup.settings.siteName)#</a></li></cfif>
        </ul>
        <ul class="nav pull-right">
          <li><a href="##">Link</a></li>
          <li class="divider-vertical"></li>
          <li class="dropdown">
            <a href="##" class="dropdown-toggle" data-toggle="dropdown">Dropdown <b class="caret"></b></a>
            <ul class="dropdown-menu">
              <li><a id="publicmode" class="off" href="##">Public website</a></li>
              <li class="divider"></li>
              <li>
                <cfif rc.sess.eGroup.editMode>
                  <a id="editmode" class="on" href="##">turn off edit mode</a>
                <cfelse>
                  <a id="editmode" class="off" href="##">turn on edit mode</a>
                </cfif>
              </li>
            </ul>
          </li>
        </ul>
        <form class="form-search pull-right" action="">
          <div class="input-prepend">
            <span class="add-on"><img src="https://d25ke41d0c64z1.cloudfront.net/images/icons/magnifier.png"></span><input class="input-large" name="query" id="directorySearch" size="16" type="text">
          </div>
        </form>
      </div><!-- /.nav-collapse -->
  </div><!-- /navbar-inner -->
</div>
<div class="container-fluid">
  <div class="row-fluid">
  <cfif event.getCurrentModule() eq "eGroup">
    <div class="span3">
      <div id="shortCuts" class="rightMenu">
      <cftry>
        <cfset theHandler = "admin">
        <cfset theModule = "eGroup">
        #renderView(view="admin/rightMenu",module="#theModule#")#
      <cfcatch type="any"></cfcatch>
      </cftry>
      </div>
    </div>
  </cfif>
  <cfif event.getCurrentModule() eq "eGroup">
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
