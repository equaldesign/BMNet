<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
		<meta http-equiv="Content-Type" content="text/html;charset=utf-8"/>
<link rel="shortcut icon" href="/favicon.ico" />
<!--- IE SPECIFIC --->
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<LINK rel="shortcut icon" type=image/x-icon href="/favicon.ico">
<LINK rel=icon type=image/ico href="/favicon.ico">
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
<script language="javascript" type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js"></script>
<script language="javascript" type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jqueryui/1.8.15/jquery-ui.js"></script>
<link href='http://fonts.googleapis.com/css?family=Droid+Sans:400,700' rel='stylesheet' type='text/css'>

<title>eBiz Help System</title>
<cfoutput>#renderView(view="stylesheets")#
</cfoutput><cfset getMyPlugin(plugin="jQuery").getDepends("dataTableAjaxReload,buildLink,livequery","main","tables",false)>

<meta http-equiv="content-type" content="text/html;charset=ISO-8859-2" />
    <link rel="stylesheet" href="https://www.buildingvine.com/includes/style/icons.css">
</head>

<body>
<div class="navbar navbar-fixed-top">
  <div class="navbar-inner">
    <div class="container">
      <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </a>
      <a class="brand" href="/"><img src="/includes/images/darklogo.png" border="0" hspace="10" align="left" alt="eBiz bugs and helpdesk" /></a>
    </div> <!-- /container -->
  </div> <!-- /navbar-inner -->
</div> <!-- /navbar -->
<div id="content">
  <div class="container">
    <div class="row">
      <div class="span3">
        <div class="account-container">
          <div class="account-avatar">
            <cfif isUserLoggedIn()>
              <cfset details = {
                email = "tom.miller@ebiz.co.uk",
                name = "Tom Miller",
                position = "Managing Director"
              }>
            <cfelse>
              <cfset details = {
                email = "support@ebiz.co.uk",
                name = "Guest User",
                position = "Login to see or create tickets"
              }>
            </cfif>
            <cfoutput><img width="55" src="https://secure.gravatar.com/avatar/#lcase(Hash(lcase('#details.email#')))#?size=55&amp;d=https://www.buildingvine.com/includes/images/secure/blankAvatar.jpg" alt="" class="thumbnail" /></cfoutput>
          </div> <!-- /account-avatar -->
          <div class="account-details">
            <cfoutput>
            <span class="account-name">#details.name#</span>
            <span class="account-role">#details.position#</span>
            </cfoutput>
            <cfif isUserLoggedIn()>
            <span class="account-actions">
              <a href="javascript:;">Profile</a> |
              <a href="javascript:;">Edit Settings</a>
            </span>
            </cfif>
          </div> <!-- /account-details -->
        </div> <!-- /account-container -->
        <hr />
        <ul id="main-nav" class="nav nav-tabs nav-stacked">
          <cfoutput>
          <li class="#Iif(event.getCurrentEvent() eq "bugs.index","'active'","''")#">
            <a href="#bl('bugs')#">
              <i class="icon-home"></i>
              Dashboard
            </a>
          </li>
          <li class="#Iif(event.getCurrentEvent() eq "bugs.current","'active'","''")#">
            <a href="#bl('bugs.current')#">
              <i class="icon-ticket"></i>
              Current Open Tickets
              <span class="label label-warning pull-right">#rc.bugCount#</span>
            </a>
          </li>
          <li class="#Iif(event.getCurrentEvent() eq "pingdom.index","'active'","''")#">
            <a href="#bl('pingdom.index')#">
                <i class="icon-server"></i>
                Server Statistics
            </a>
          </li>
          <li class="#Iif(event.getCurrentEvent() eq "bugs.server","'active'","''")#">
            <a href="#bl('bugs.server')#">
            <i class="icon-server--exclamation"></i>
            Server Errors
          </a>
          </li>
          </cfoutput>
        </ul>
        <hr />
        <ul id="secondary-nav" class="nav nav-tabs nav-stacked">
          <cfoutput>
            <li class="#Iif(event.getCurrentEvent() eq "bugs.create","'active'","''")#">
                <a href="#bl('bugs.edit')#">
                <i class="icon-ticket--plus"></i>
                Create new ticket
              </a>
            </li>
            <li class="#Iif(event.getCurrentEvent() eq "bugs.create","'active'","''")#">
              <a href="#bl('bugs.mytickets')#">
                <i class="icon-user"></i>
                Show my tickets
              </a>
            </li>
          </cfoutput>
          </ul>
        <div class="sidebar-extra">

        </div> <!-- .sidebar-extra -->
        <br />
      </div> <!-- /span3 -->
      <div class="span9">
       <cfoutput>#renderView()#</cfoutput>
      </div> <!-- /span9 -->
    </div> <!-- /row -->
  </div> <!-- /container -->
</div> <!-- /content -->
<div id="footer">
  <div class="container">
    <hr>
    <p>&copy; <cfoutput>#year(now())#</cfoutput> eBiz.co.uk</p>
  </div> <!-- /container -->
</div>
<div class="Aristo" id="dialog"></div>
<script type="text/javascript" src="http://maps.google.com/maps/api/js?sensor=false"></script>

</body>
</html>