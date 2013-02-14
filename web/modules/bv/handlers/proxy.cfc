<cfcomponent name="proxy" output="false" cache="false" cacheTimeout="30"  autowire="true">
  <cfproperty name="logger" inject="logbox:root" />
  <cffunction name="index" returntype="void" output="false">
    <cfargument name="event">

    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.proxyRoute = MID(arguments.event.getCurrentRoutedURL(),1,Len(arguments.event.getCurrentRoutedURL())-1)>
    <cfif isDefined("rc.format") AND rc.format neq "">
      <cfset rc.proxyRoute ="#rc.proxyRoute#.#rc.format#">
    </cfif>
    <cfset rc.proxyRoute ="#rc.proxyRoute#?#cgi.QUERY_STRING#">
    <cfset rc.proxyRoute = ReplaceNoCase(rc.proxyRoute,"proxy/","","ALL")>
    <cfset rc.method = arguments.event.gethttpmethod()>
    <cfset rc.rs = arguments.event.getroutedStruct()>
    <cfset rc.fileData = arguments.event.getValue("fileData","")>
    <cfset rc.filename = arguments.event.getValue("filename","")>
    <cfset arguments.event.setView("debug")>
    <cfset logger.debug("proxying")>

    <cfif isJSONRequest()>
      <cfhttp url="http://www.buildingvine.com/#rc.proxyroute#" method="#rc.method#" result="rc.proxyResult">
        <cfhttpparam type="header" name="content-type" value="application/json">
       <cfhttpparam type="body" name="json" value="#serializeJSON(deserializeJSON(toString(getHttpRequestData().content)))#">
      </cfhttp>
    <cfelseif rc.fileData neq "">
      <cfset logger.debug("has file data: #rc.filename#")>
      <cffile action="copy" source="#rc.fileData#" destination="/tmp/#rc.filename#">
      <cfhttp result="rc.proxyResult" method="post" url="http://www.buildingvine.com/alfresco/service/bvine/docs/files/upload.xml?alf_ticket=#request.user_ticket#">
        <cfhttpparam type="formfield" name="folder" value="#rc.destination#">
        <cfhttpparam type="file" name="file" mimetype="#getPageContext().getServletContext().getMimeType('/tmp/#rc.filename#')#" file="/tmp/#rc.filename#">
      </cfhttp>
    <cfelse>
      <cfhttp url="http://www.buildingvine.com/#rc.proxyroute#" method="#rc.method#" result="rc.proxyResult"></cfhttp>
    </cfif>
    <cftry>
      <cfset rc.json = rc.proxyResult.fileContent>
      <cfset arguments.event.setView("renderJSON",true)>
      <cfcatch type="any">
        <cfset rc.out = proxyResult.fileContent>
      <cfset arguments.event.setView("renderOutput",true)>
      </cfcatch>
    </cftry>
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
