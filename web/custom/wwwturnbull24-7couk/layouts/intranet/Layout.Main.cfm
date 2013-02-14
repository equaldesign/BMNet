<!DOCTYPE html>
<html lang="en"
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
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />

  <script language="javascript" type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
  <script language="javascript" type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.10.0/jquery-ui.min.js"></script>
  <script language="javascript" type="text/javascript" src="/includes/javascript/jQuery/jQuery.bootstrap.js"></script>
  <link href="/includes/style/bootstrap.css" rel="stylesheet">
  <link href="/includes/style/bootstrap-responsive.min.css" rel="stylesheet">
  <script src="https://www.buildingvine.com/includes/javascript/jQuery/jQuery.zoom.js" type="text/javascript" language="javascript"></script>
  <script type="text/javascript" src="/ckeditor4/ckeditor.js"></script>
  <link href="http://d25ke41d0c64z1.cloudfront.net/images/iconset.css" rel="stylesheet" type="text/css" />
  <link rel="stylesheet" href="/includes/style/intranet/select2.css" />
  <link rel="stylesheet" href="/includes/style/intranet/fullcalendar.css" />
  <link rel="stylesheet" href="/includes/style/intranet/unicorn.main.css" />
  <link rel="stylesheet" href="/includes/style/intranet/unicorn.grey.css" class="skin-color" />
<cfoutput><script language="javascript" type="text/javascript" src="/includes/javascript/jQuery/jQuery.buildLink.js"></script></cfoutput>
<cfset getMyPlugin(plugin="jQuery").getDepends("slimScroll,select,peity,fullcalendar,gcal,excanvas,uniform,livequery,dataTables.min,dataTableAjaxReload,filedrop,upload,tooltip,titleAlert,bbq,jstree,localScroll,scroll,buildLink,address,tip,tipsy,form,block,cookie,cycle,easing.1.3,select","main,menus,homeaccordion,accordion,filter,products/tree","tipsy,themes/classic/style,Aristo/jQueryUI",true,"eunify")>
<cfset getMyPlugin(plugin="jQuery").getDepends("","tablecloth,calendar/calendar,promotions/fullList","promotions,documents/documents,documents/uploadify,dashboard/overview",true,"eGroup")>
<cfset getMyPlugin(plugin="jQuery").getDepends("","","secure/products/products,secure/products/standard,secure/documents/documents",false,"bv")>
<cfset getMyPlugin(plugin="jQuery").getDepends("jstree","intranet/unicorn","",false)>
<cfset getMyPlugin(plugin="jQuery").getDepends("","","main",false,"flo")>

  <meta http-equiv="content-type" content="text/html;charset=ISO-8859-2" />

</head>

<body>
<cfoutput><input id="httpHost" type="hidden" value="http://#cgi.http_host#" />
        <input id="isSES" value="#event.isSES()#" type="hidden" />
        <input id="currentModule" value="#event.getCurrentModule()#" type="hidden" />
        <input id="alf_ticket" value="#rc.sess.buildingVine.user_ticket#" type="hidden" />

  </head>
  <body>


    <div id="header">
      <h1><a href="/">BuildersMerchant.net</a></h1>
    </div>

    <div id="search">
      <form id="siteSearch" class="form-search pull-right" action="">
        <div class="input-prepend">
          <span class="add-on"><img src="https://d25ke41d0c64z1.cloudfront.net/images/icons/magnifier.png"></span><input class="input-large" name="query" id="directorySearch" size="16" type="text">
        </div>
      </form>
    </div>
    <div id="user-nav" class="navbar navbar-inverse">
            <ul class="nav btn-group">
                <li class="btn btn-inverse">
                  <a class="dropdown-toggle" data-toggle="dropdown" title="" href="##"><i class="icon icon-cog"></i> <span class="text">Settings</span> <b class="caret"></b></a>
                  <ul class="dropdown-menu pull-right">
                    <li><a href="/login/logout"><i class="icon-cross"></i>Logout</a></li>
                    <li><a class="off" href="/eunify/contact/layoutMode?layoutmode=public"><i class="icon-lock-unlock"></i>Public website</a></li>
                    <cfif isUserInRole("admin")>
                    <li><a class="off" href="/eunify/groups/administrator"><i class="icon-users"></i>Group Administrator</a></li>
                    </cfif>
                    <li><a class="off" href="/eunify/contact/index/id/#request.bmnet.contactID#">
                      <img width="16" class="gravatar" src="http://www.gravatar.com/avatar/#lcase(Hash(lcase(getAuthUser())))#?size=16&d=http://#cgi.HTTP_HOST#/modules/eunify/includes/images/blankAvatar.jpg" />
                      Your Profile</a></li>
                    <li class="divider"></li>
                    <li><a href="/bugs/bugs/current"><i class="icon-bug"></i>Bugs &amp; Support</a></li>
                  </ul>
                </li>
            </ul>
        </div>

    <div id="sidebar">
      <a href="##" class="visible-phone"><i class="icon icon-dashboard"></i>Dashboard</a>
      <ul>
        <li class="#Iif(event.getCurrentHandler() eq 'eunify:feed','"active"','""')#"><a href="/eunify"><i class="icon-home"></i><span>Home</span></a></li>
        <li class="submenu #Iif(event.getCurrentModule() eq 'flo','"active"','""')#">
          <a class="documents" href="##"><i class="icon-calendar-task"></i><span>Workflow & tasks</span></a>
          <ul>
            <li class="submenu">
              <cfset floItemTypes = getModel("flo.TaskService").getItemTypes()>
              <a href="##"><i class="icon-reports"></i> Item Types</a>
              <ul>
                <cfloop query="floItemTypes">
                <li class="submenu">
                  <a class="fCap" href="##"><i class="icon-arrow-000-small"></i> #name#</a>
                  <ul>
                    <li><a class="fCap" href="/flo/stage/index?type=#name#&system=BMNet" rev="maincontent"><i class="icon-arrow-000-small"></i> All #name#s</a></li>
                    <li><a class="fCap" href="/flo/stage/index?type=#name#&system=BMNet&myTasks=true" rev="maincontent"><i class="icon-arrow-000-small"></i> My #name#s</a></li>
                    <li><a class="fCap" href="/flo/item/new?system=BMNet&type=#name#" rev="maincontent"><i class="icon-arrow-000-small"></i> New #name#</a></li>
                  </ul>
                </li>
                </cfloop>
              </ul>
            </li>
            <li><a href="/flo/item/myItems?system=BMNet"  rev="maincontent"><i class="icon-document-task"></i> My Items</a></li>
            <li><a href="/flo/activities/myActivities?system=BMNet" rev="maincontent"><i class="icon-calendar-blue"></i> My Reminders</a></li>
            <li><a href="/flo/item/list?system=BMNet" rev="maincontent"><i class="icon-clipboard-task"></i> All Items</a></li>
            <li><a href="/flo/feed?system=BMNet" rev="maincontent"><i class="icon-flo-log"></i> Flo log</a></li>
            <li><a href="/flo/setup" rev="maincontent"><i class="icon-flo-settings"></i> Flo set-up</a></li>
          </ul>
        </li>
        <li class="submenu #Iif(event.getCurrentHandler() eq 'eunify:sales','"active"','""')#">
          <a href="##"><i class="icon-chart-pie"></i><span>Sales</span></a>
          <ul>
            <li class="submenu"><a href="##"><i class="icon-chart"></i>Statistics</a>
              <ul>
                <li><a rev="maincontent" href="/eunify/sales/"><i class="icon-piechart"></i>Overview</a></li>
                <li><a rev="maincontent" href="/eunify/sales/thisMonthMap"><i class="icon-pushpin"></i>Recent Sales Map</a></li>
                <li><a rev="maincontent" href="/eunify/sales/ledger"><i class="icon-table-excel"></i>Full Ledger</a></li>
                <li><a rev="maincontent" href="/eunify/sales/salesfilter?filter=branch_id"><i class="icon-branch"></i>Branch Analysis</a></li>
                <li><a rev="maincontent" href="/eunify/ecommerce/list"><i class="icon-globe"></i>Online Sales</a></li>
              </ul>
            </li>
            <li class="submenu"><a href="##"><i class="icon-chart"></i>Warnings</a>
              <ul>
                <li><a rev="maincontent" href="/eunify/sales/warnings"><i class="icon-alert-user"></i>Customer Dissapearance</a></li>
                <li><a rev="maincontent" href="/eunify/sales/warningsMap"><i class="icon-alert-marker"></i>Geographic Dissapearance</a></li>
              </ul>
            </li>
            <li class="submenu"><a href="##"><i class="icon-chart"></i>Reports</a>
              <ul>
                <li><a href="/eunify/sales/report/salesman"><i class="icon-report-1"></i>Salesperson Analysis</a></li>
                <li><a href="/eunify/sales/report/category"><i class="icon-report-2"></i>Category Analysis</a></li>
                <li><a href="/eunify/sales/report/branch"><i class="icon-report-3"></i>Branch Analysis</a></li>
                <li><a href="/eunify/sales/report/customer"><i class="icon-report-4"></i>Customer Analysis</a></li>
              </ul>
            </li>
            <li class="submenu"><a href="##"><i class="icon-chart"></i>Import</a>
              <ul>
                <li><a href="/eunify/sales/import"><i class="icon-import"></i>Import Sales Ledger</a></li>
              </ul>
            </li>
          </ul>
        </li>
        <li class="submenu #Iif(event.getCurrentHandler() eq 'eunify:company','"active"','""')#">
          <a href="##"><i class="icon-user-business-boss"></i><span>Companies</span></a>
          <ul>
            <li class="submenu">
              <a href="##"><i class="icon-user-business"></i> Customers</a>
              <ul>
                <li><a href="/eunify/company/index/type_id/1"><i class="icon-user-business"></i> Customer List</a></li>
                <li class="divider"></li>
                <li><a href="/eunify/company/edit/type/1"><i class="icon-user--plus"></i> Create New Customer</a></li>
                <li><a href="/eunify/contact/edit"><i class="icon-user--plus"></i> Create New Contact</a></li>
              </ul>
            </li>
            <li class="submenu">
              <a href="##"><i class="icon-user-business-gray"></i> Suppliers</a>
              <ul>
                <li><a href="/eunify/company/index/type_id/2"><i class="icon-user-business-gray"></i> Suppliers List</a></li>
                <li class="divider"></li>
                <li><a href="/eunify/company/edit/type/2"><i class="icon-user--plus"></i> Create New Suppliers</a></li>
                <li><a href="/eunify/contact/edit"><i class="icon-user--plus"></i> Create New Contact</a></li>
              </ul>
            </li>
          </ul>
        </li>
        <li class="submenu #Iif(event.getCurrentModule() eq 'marketing','"active"','""')#">
          <a href="##"><i class="icon-color-swatches"></i><span>Marketing</span></a>
          <ul>
            <li class="submenu"><a href="##"><i class="icon-balloon-facebook"></i>Social</a>
              <ul>
                <li><a href="/marketing/social/facebook"><i class="icon-balloon-facebook"></i>Facebook</a></li>
                <li><a href="/marketing/social/twitter"><i class="icon-balloon-twitter"></i>Twitter</a></li>
              </ul>
            </li>
            <li class="submenu"><a href="##"><i class="icon-mail-send-receive"></i>Email Marketing</a>
              <ul>
                <li><a href="/marketing/email/campaign/list"><i class="icon-mail-open-table"></i>Campaigns</a></li>
                <li><a href="/marketing/email/campaign/detail"><i class="icon-mail--plus"></i>Create new Campaign</a></li>
              </ul>
            </li>
            <li class="submenu"><a href="##"><i class="icon-question"></i>Questionnaires</a>
              <ul>
                <li><a href="/poll/poll/index"><i class="icon-question-frame"></i>Questionnaires</a></li>
                <li><a href="/poll/poll/edit"><i class="icon-question-shield"></i>Create new Questionnaire</a></li>
              </ul>
            </li>
          </ul>
        </li>
        <li class="submenu #Iif(event.getCurrentHandler() eq 'eunify:products','"active"','""')#">
          <a rev="maincontent" href="/eunify/products"><i class="icon-drill"></i><span>Products</span></a>
          <ul>
            <li id="productTree" class="jstree-products"></li>
            <li class="submenu"><a href="##"><i class="icon-drill--pencil"></i>Manage</a>
              <ul>
                <li><a href="/eunify/products"><i class="icon-drill--arrow"></i>Product List</a></li>
                <li><a name="Add Product" class="noAjax modaldialog edit" href="/eunify/products/edit"><i class="icon-drill--plus"></i>Add Product</a></li>
              </ul>
            </li>
            <li class="submenu"><a href="##"><i class="icon-drill"></i>Import</a>
              <ul>
                <li><a href="/eunify/products/import"><i class="icon-products-import"></i>Import Products</a></li>
                <li><a href="/eunify/products/import?type=stock"><i class="icon-products-stock"></i>Import Stock</a></li>
              </ul>
            </li>
          </ul>
        </li>
        <li class="#Iif(event.getCurrentHandler() eq 'eunify:calendar','"active"','""')#"><a rel="maincontent" href="/eunify/calendar"><i class="icon-calendar-day"></i><span>Calendar</span></a></li>
        <li class="#Iif(event.getCurrentModule() eq 'bv','"active"','""')#"><a rel="maincontent" class="documents" href="/bv/documents/getFolder?siteID=#rc.sess.buildingVine.siteID#"><i class="icon-documents"></i><span>Documents</span></a></li>
        <cfif rc.sess.eGroup.username neq ""><li class="#Iif(event.getCurrentModule() eq 'eGroup','"active"','""')#"><a class="egroup" href="/eGroup/dashboard"><i class="icon-egroup"></i><span>#Ucase(getSetting(module="eGroup",name="siteName"))#</span></a></li></cfif>
      </ul>

    </div>

    <div id="maincontent">
      <cfoutput>#renderView()#</cfoutput>

    </div>
  <div class="Aristo" id="dialog"></div>
  </body>
</cfoutput>
</html>


<!---
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
--->