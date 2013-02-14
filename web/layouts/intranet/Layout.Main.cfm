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
  <link href='http://fonts.googleapis.com/css?family=Lato:100,300,400,700,900' rel='stylesheet' type='text/css'>
  <title>BuildersMerchant.net</title>


  <script language="javascript" type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
  <script language="javascript" type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.18/jquery-ui.min.js"></script>
  <script language="javascript" type="text/javascript" src="/includes/javascript/jQuery/jQuery.bootstrap.js"></script>
  <link href="/includes/style/bootstrap.new.css" rel="stylesheet">
  <link href="/modules/eunify/includes/style/print.css" rel="stylesheet" type="text/css" media="print" />
  <link href="/includes/style/icons.css" rel="stylesheet">
  <link href="/includes/style/bootstrap-responsive.min.css" rel="stylesheet">
  <script src="https://www.buildingvine.com/includes/javascript/jQuery/jQuery.zoom.js" type="text/javascript" language="javascript"></script>
  <link href="https://www.buildingvine.com/includes/style/icons.css" type="text/css" rel="stylesheet" />
  <script type="text/javascript" src="/ckeditor4/ckeditor.js"></script>

<cfoutput><script language="javascript" type="text/javascript" src="/includes/javascript/jQuery/jQuery.buildLink.js"></script></cfoutput>
<cfset getMyPlugin(plugin="jQuery").getDepends("livequery,dataTables,filedrop","main,homeaccordion,accordion,filter","sites/3/main,sites/3/nav,tabs,shortcuts,divtables,tables",true,"eunify")>
<cfset getMyPlugin(plugin="jQuery").getDepends("upload,tooltip,titleAlert,bbq,jstree,localScroll,scroll,buildLink,address,tip,tipsy,form,block,cookie,cycle,easing.1.3","menus,tablecloth,calendar/calendar,promotions/fullList","promotions,documents/documents,documents/uploadify,dashboard/overview",true,"eGroup")>
<cfset getMyPlugin(plugin="jQuery",module="bv").getDepends("","","secure/products/products,secure/products/standard,secure/documents/documents")>
<cfset getMyPlugin(plugin="jQuery").getDepends("","","main",false,"flo")>
<cfoutput>#renderView(view="stylesheets",cache="false",module="eunify")#

</cfoutput>

  <meta http-equiv="content-type" content="text/html;charset=ISO-8859-2" />

</head>

<body>
<cfoutput><input id="httpHost" type="hidden" value="http://#cgi.http_host#" />
        <input id="isSES" value="#event.isSES()#" type="hidden" />
        <input id="currentModule" value="#event.getCurrentModule()#" type="hidden" />
        <input id="alf_ticket" value="#rc.sess.buildingVine.user_ticket#" type="hidden" />
        <input id="bvsiteID" value="#rc.sess.buildingVine.siteID#" type="hidden" />
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
          <li class="dropdown #Iif(event.getCurrentHandler() eq 'eunify:sales' OR event.getCurrentModule() eq 'flo','"active"','""')#">
            <a class="dropdown-toggle" data-toggle="dropdown" href="##"><i class="icon-sales"></i>Sales <b class="caret"></b></a>
            <ul class="dropdown-menu">
              <li class="nav-header">Sales Workflow</li>
              <li class="dropdown-submenu">
                <a class="dropdown-toggle" rel="maincontent" class="documents" href="##"><i class="icon-flo"></i>Flo</a>
                <ul class="dropdown-menu">
                  <li class="dropdown-submenu">
                    <cfset floItemTypes = getModel("flo.TaskService").getItemTypes()>
                    <a class="dropdown-toggle" data-toggle="dropdown" href="##"><i class="icon-reports"></i> Item Types</a>
                    <ul class="dropdown-menu">
                      <cfloop query="floItemTypes">
                      <li class="dropdown-submenu">
                        <a class="fCap dropdown-toggle" data-toggle="dropdown" href="##"><i class="icon-navigation"></i> #name#</a>
                        <ul class="dropdown-menu">
                          <li><a class="fCap" href="/flo/stage/index?type=#name#&system=BMNet" rev="flo"><i class="icon-flo-funnel"></i> #name#s</a></li>
                          <li><a class="fCap" href="/flo/stage/index?type=#name#&system=BMNet&myTasks=true" rev="flo"><i class="icon-flo-funnel"></i> My #name#s</a></li>
                          <li><a class="fCap" href="/flo/item/new?system=BMNet&type=#name#"><i class="icon-flo-sales-new"></i> New #name#</a></li>
                        </ul>
                      </li>
                      </cfloop>
                    </ul>
                  </li>
                  <li><a href="/flo/item/myItems?system=BMNet" rev="flo"><i class="icon-flo-tasks"></i> My Items</a></li>
                  <li><a href="/flo/activities/myActivities?system=BMNet" rev="flo"><i class="icon-flo-alarm"></i> My Reminders</a></li>
                  <li><a href="/flo/item/list?system=BMNet" rev="flo"><i class="icon-flo-tasks"></i> All Items</a></li>
                  <li><a href="/flo/feed?system=BMNet" rev="flo"><i class="icon-flo-log"></i> Flo log</a></li>
                  <li><a href="/flo/setup" rev="flo"><i class="icon-flo-settings"></i> Flo set-up</a></li>
                </ul>
              </li>
              <li class="nav-header">Statistics</li>
              <li><a href="/eunify/sales/"><i class="icon-piechart"></i>Overview</a></li>
              <li><a href="/eunify/sales/thisMonthMap"><i class="icon-pushpin"></i>Recent Sales Map</a></li>
              <li><a href="/eunify/sales/ledger"><i class="icon-table-excel"></i>Full Ledger</a></li>
              <li><a href="/eunify/sales/salesfilter?filter=branch_id"><i class="icon-branch"></i>Branch Analysis</a></li>
              <li><a href="/eunify/ecommerce/list"><i class="icon-globe"></i>Online Sales</a></li>
              <li class="divider"></li>
              <li class="nav-header">Warnings</li>
              <li><a href="/eunify/sales/warnings"><i class="icon-alert-user"></i>Customer Dissapearance</a></li>
              <li><a href="/eunify/sales/warningsMap"><i class="icon-alert-marker"></i>Geographic Dissapearance</a></li>
              <li class="divider"></li>
              <li class="nav-header">Reports</li>
              <li><a href="/eunify/sales/report/salesman"><i class="icon-report-1"></i>Salesperson Analysis</a></li>
              <li><a href="/eunify/sales/report/category"><i class="icon-report-2"></i>Category Analysis</a></li>
              <li><a href="/eunify/sales/report/branch"><i class="icon-report-3"></i>Branch Analysis</a></li>
              <li><a href="/eunify/sales/report/customer"><i class="icon-report-4"></i>Customer Analysis</a></li>
              <li class="divider"></li>
              <li class="nav-header">Import</li>
              <li><a href="/eunify/sales/import"><i class="icon-import"></i>Import Sales Ledger</a></li>
            </ul>
          </li>
          <li class="dropdown #Iif(event.getCurrentHandler() eq 'eunify:company','"active"','""')#">
            <a class="dropdown-toggle" data-toggle="dropdown" href="##"><i class="icon-customers"></i>Companies <b class="caret"></b></a>
            <ul class="dropdown-menu">
              <li class="dropdown-submenu">
                <a href="##"><i class="icon-customers"></i> Customers</a>
                <ul class="dropdown-menu">
                  <li><a href="/eunify/company/index/type_id/1"><i class="icon-customers"></i> Customer List</a></li>
                  <li class="divider"></li>
                  <li><a href="/eunify/company/edit/type/1"><i class="icon-customers"></i> Create New Customer</a></li>
                  <li><a href="/eunify/contact/edit"><i class="icon-contact-new"></i> Create New Contact</a></li>
                </ul>
              </li>
              <li class="dropdown-submenu">
                <a href="##"><i class="icon-suppliers"></i> Suppliers</a>
                <ul class="dropdown-menu">
                  <li><a href="/eunify/company/index/type_id/2"><i class="icon-suppliers"></i> Suppliers List</a></li>
                  <li class="divider"></li>
                  <li><a href="/eunify/company/edit/type/2"><i class="icon-suppliers"></i> Create New Suppliers</a></li>
                  <li><a href="/eunify/contact/edit"><i class="icon-contact-new"></i> Create New Contact</a></li>
                </ul>
              </li>
            </ul>
          </li>
          <li class="dropdown #Iif(event.getCurrentModule() eq 'marketing','"active"','""')#">
            <a class="dropdown-toggle" data-toggle="dropdown" href="##"><i class="icon-marketing"></i>Marketing <b class="caret"></b></a>
            <ul class="dropdown-menu">
              <li class="nav-header">Social</li>
              <li><a href="/marketing/social/facebook"><i class="icon-facebook"></i>Facebook</a></li>
              <li><a href="/marketing/social/twitter"><i class="icon-twitter"></i>Twitter</a></li>
              <li class="divider"></li>
              <li class="nav-header">Email Marketing</li>
              <li><a href="/marketing/email/campaign/list"><i class="icon-email-list"></i>Campaigns</a></li>
              <li><a href="/marketing/email/campaign/detail"><i class="icon-email-new"></i>Create new Campaign</a></li>
              <li class="nav-header">Questionnaires</li>
              <li><a href="/poll/poll/index"><i class="icon-question-frame"></i>Questionnaires</a></li>
              <li><a href="/poll/poll/edit"><i class="icon-question-shield"></i>Create new Questionnaire</a></li>
            </ul>
          </li>
          <li class="dropdown #Iif(event.getCurrentHandler() eq 'eunify:products','"active"','""')#">
            <a class="dropdown-toggle" data-toggle="dropdown" href="##"><i class="icon-products"></i>Products <b class="caret"></b></a>
            <ul class="dropdown-menu">
              <li class="nav-header">Manage</li>
              <li><a href="/eunify/products"><i class="icon-products"></i>Product List</a></li>
              <li><a name="Add Product" class="noAjax modaldialog edit" href="/eunify/products/edit"><i class="icon-product-add"></i>Add Product</a></li>
              <li class="divider"></li>
              <li class="nav-header">Import</li>
              <li><a href="/eunify/products/import"><i class="icon-products-import"></i>Import Products</a></li>
              <li><a href="/eunify/products/import?type=stock"><i class="icon-products-stock"></i>Import Stock</a></li>
            </ul>
          </li>
          <li class="#Iif(event.getCurrentModule() eq 'bv','"active"','""')#"><a rel="maincontent" class="documents" href="/bv/documents/getFolder?siteID=#rc.sess.buildingVine.siteID#"><i class="icon-documents"></i>Documents</a></li>
          <cfif rc.sess.eGroup.username neq ""><li class="#Iif(event.getCurrentModule() eq 'eGroup','"active"','""')#"><a class="egroup" href="/eGroup/dashboard"><i class="icon-egroup"></i>#Ucase(getSetting(module="eGroup",name="siteName"))#</a></li></cfif>
        </ul>
        <ul class="nav pull-right">
          <li class="dropdown">
            <a href="##" class="dropdown-toggle" data-toggle="dropdown"><i class="icon-tools"></i>Tools <b class="caret"></b></a>
            <ul class="dropdown-menu">
              <li><a href="/login/logout"><i class="icon-logout"></i>Logout</a></li>
              <li><a class="off" href="/eunify/contact/layoutMode?layoutmode=public"><i class="icon-unlock"></i>Public website</a></li>
              <cfif isUserInRole("admin")>
              <li><a class="off" href="/eunify/groups/administrator"><i class="icon-usergroups"></i>Group Administrator</a></li>
              </cfif>
              <li><a class="off" href="/eunify/contact/index/id/#request.bmnet.contactID#">
                <img width="16" class="gravatar" src="http://www.gravatar.com/avatar/#lcase(Hash(lcase(getAuthUser())))#?size=16&d=http://#cgi.HTTP_HOST#/modules/eunify/includes/images/blankAvatar.jpg" />
                Your Profile</a></li>
              <li class="divider"></li>
              <li><a href="/bugs/bugs/current"><i class="icon-bugs"></i>Bugs &amp; Support</a></li>
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
        <form id="siteSearch" class="form-search pull-right" action="">
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
