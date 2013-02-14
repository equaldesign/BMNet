
<cfcomponent output="false" autowire="true">

	<!--- dependencies --->

	<cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" />
  <cfproperty name="BeanFactory" inject="coldbox:plugin:BeanFactory" />
  <cfproperty name="PageService" inject="id:sums.PageService" />
	<!--- index --->
	<cffunction name="index" returntype="any" output="false" cache="false">
		<cfargument name="event">
    <cfargument name="widget" required="true" default="false">
    <cfset var rc = arguments.event.getCollection()>
    <cfif isUserInRole("staff") AND UserStorage.getVar("LayoutPath","public") eq "intranet">
      <cfset setNextEvent(uri="/eunify")>
    </cfif>
	  <cfset rc.proxyRoute = event.getValue("proxyRoute","")>
    <cfset rc.name = "">
	  <cfset rc.showMenu = false>
	  <cfif rc.proxyRoute eq "">
	    <cfif arguments.event.getCurrentRoutedURL() eq "">
	      <cfset rc.proxyRoute = "sums/page/homepage">
	    <cfelse> 
	      <cfset rc.proxyRoute = MID(arguments.event.getCurrentRoutedURL(),1,Len(arguments.event.getCurrentRoutedURL())-1)>
	    </cfif>
	    <cfset rc.proxyRoute = ReplaceNoCase(rc.proxyRoute,"html/","sums/page/","one")>
	    <cfset rc.proxyRoute ="#rc.proxyRoute#?#cgi.QUERY_STRING#&siteID=#rc.siteID#">
	  </cfif>
    <cfset rc.method = arguments.event.gethttpmethod()>
    <cfset rc.rs = arguments.event.getroutedStruct()>
    <cfset rc.fileData = arguments.event.getValue("fileData","")>
    <cfset rc.filename = arguments.event.getValue("filename","")>
    <cfset rc.requestData = PageService.proxy(
      proxyurl=rc.proxyroute,
      formCollection=form,
      method=rc.method,
      JSONRequest=isJSONRequest(),
      siteID = rc.siteID,
      jsonData = getHttpRequestData().content,
      alf_ticket=request.buildingVine.admin_ticket
    )>

    <cfif isDefined("rc.requestData.haserror") AND rc.requestData.haserror>
      <cfif arguments.widget>
         <cfreturn renderView(view="error/404",module="sums")>
      </cfif>

      <cfset arguments.event.setView("error/404")>
    <cfelse>
      <cfif isJsonRequest() OR isDefined("rc.format") AND rc.format eq "json">
        <cfset event.renderData(data=rc.requestData,type="JSON")>
      <cfelse>
        <cfset templatePath = "/#ExpandPath('./')#">
        <cfif isDefined("rc.requestData.page.title") OR isUserInRole("staff")>

          <cfset rc.templateModel = getModel("templates.#rc.requestdata.page.template#")>
          <cfset rc.templatePath = "templates/view/#rc.requestData.page.template#">
          <cfif NOT isDefined("rc.requestData.page.title")>
            <cfset rc.initialDialog = true>
          </cfif>
            <cfif arguments.widget>
              <cfreturn renderView(view="templates/index",module="sums")>
            </cfif>
            <cfset arguments.event.setView(view="templates/index")>
        <cfelse>
          <!--- page doesn't exist --->
            <cfif arguments.widget>
              <cfreturn renderView(view="error/404",module="sums")>
            </cfif>
            <cfset arguments.event.setView("error/404")>
        </cfif>
      </cfif>
    </cfif>
	</cffunction>



  <cfscript>
  Boolean function isJSONRequest(){
    var contentType = getHTTPHeader("Content-Type","");
    return find("application/json",contentType) != 0;
  }
  function getHTTPHeader(header,defaultValue){

    var headers = getHttpRequestData().headers;

    if( structKeyExists(headers, arguments.header) ){
      return headers[arguments.header];
    }
    if( structKeyExists(arguments,"defaultValue") ){
      return arguments.defaultValue;
    }
    throw(message="Header #arguments.header# not found in HTTP headers",detail="Headers found: #structKeyList(headers)#",type="RequestContext.InvalidHTTPHeader");
  }
  </cfscript>
</cfcomponent>