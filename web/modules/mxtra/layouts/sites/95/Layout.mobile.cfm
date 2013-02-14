<cfsetting showdebugoutput="no">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
 <cfset ehandler = ListFirst(event.getCurrentEvent(),".")>
 <cfif eHandler eq "mxtra">
  <cfset showLinks = false>
 <cfelse>
  <cfset showLinks = true>
 </cfif>
 <cfoutput>#renderView("admin/htmlheader")#</cfoutput>
 <script src="/includes/javascript/jQuery/jQuery.js" type="text/javascript" language="javascript"></script>
 <script type="text/javascript" src="/includes/javascript/jQuery/jQuery.labelover.js"></script>
<link href="/includes/styles/sites/11/mobile.css" rel="stylesheet">
<link href="/includes/styles/sites/11/shop.css" rel="stylesheet">
<title>Turnbull building Supplies </title>
<link rel="shortcut icon" type="image/x-icon" href="/includes/images/turnbull/favicon.ico" />
<link rel="icon" type="image/x-icon" href="/includes/images/turnbull/favicon.ico" />
<cffunction name="breadcrumb" returntype="string" access="public" output="true">
  <cfargument name="pageid" required="yes">
  <cfargument name="tree" required="true" default="">
  <cfquery name="parentPage" datasource="sums">
    select parentid from Page where id = '#arguments.pageid#';
  </cfquery>
  <cfif parentPage.parentid is 0 or parentPage.recordCOunt eq 0>
    <!--- we've reached the root --->
    <cfset tree = "<a href='/' class='breadcrumb'>Home</a>&nbsp;&raquo;&nbsp; " & arguments.tree>
    <cfreturn tree>
  <cfelse>
    <cfquery name="pagename" datasource="sums">
      select name, quickLink from Page where id = '#arguments.pageid#';
    </cfquery>
    <cfif pageid eq rc.pageID>
      <cfset tree = "#pagename.name#">
    <cfelse>
      <cfset tree = "<a href='/html/#pagename.quickLink#.html' class='breadcrumb'>#pagename.name#</a>&nbsp;&raquo;&nbsp;" & arguments.tree>
    </cfif>
    <cfreturn breadcrumb(parentPage.parentid, tree)>

  </cfif>
</cffunction>
<cfsavecontent variable="menuCode">
<ul>
  <!-- begin links -->
  <!-- begin link body -->
  <li><!-- link --></li>
  <!-- end link body -->
  <!-- end links -->
  <li><a href="/" class="red">Special Offers</a></li>
</ul>
</cfsavecontent>
<cfset linkData = getMyPlugin("sumsnavigation").createLinks(classname="navigation", disableChildren=true,id="#rc.pageID#",displaySublinks=false,templateCode="#menuCode#")>

</head>
<body>
<div id="page">
  <div id="pageheader">
    <div id="logo"></div>
  </div>
  <div id="pagebody">
    <div id="basket_overview">
     <cfoutput>#renderView("mxtra/shop/basket_overview")#</cfoutput>
    </div>
    <div id="tree">
       <cfif showLinks AND isNumeric(rc.pageID) AND rc.pageID neq rc.sess.homeRedirect><cfoutput><div style="font-family: tahoma; font-size: 11px; padding: 0px;">#breadcrumb(rc.pageid)#</div>  </cfoutput>
       <cfelseif NOT showLinks>
       <cfoutput>You are here: #getMyPlugin("mxtra/shop/category").breadcrumb(categoryID=rc.categoryID,productID=rc.productID,tree="")#</cfoutput>
       </cfif>
    </div>
   <div id="mainp">
      <!-- fresh get -->
      <cfoutput>#renderView()#</cfoutput>
      <div class="clearer"></div>
    </div>
    <cfif showLinks>
	    <div class="homelinks">
	    <cfoutput>#linkData#</cfoutput>
	    </div>
    </cfif>
    <div class="clearer"></div>
    <cfoutput>#renderView("mxtra/shop/categoryTree")#</cfoutput>
  </div>
  <div id="footer">
    <div id="footerlinks" align="center">
      <cfoutput><p>Copyright &copy; 2001-#DateFormat(now(),"YYYY")# Turnbulls</p></cfoutput>
    </div>
    <div id="ebizPower"><a href="http://www.ebiz.co.uk" target="_blank"><img src="http://www.ebiz.co.uk/images/eBizLogo.png" border="0"></a></div>
    <div class="clearer"></div>
  </div>
</div>
<cfoutput>#renderView("admin/footer")#</cfoutput>
</body>
</html>
