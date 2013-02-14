<cfcomponent name="importService" accessors="true"  output="true" cache="true" cacheTimeout="0" autowire="true">
<!--- Dependencies --->

  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" />
  <cfproperty name="dsn" inject="coldbox:datasource:BMNet" />

  <cffunction name="doImport">
    <cfargument name="sumsSiteID">
    <cfargument name="bvineSiteID">
    <cfset variables.sumsSiteID = arguments.sumsSiteID>
    <cfset variables.bvsiteID = arguments.bvineSiteID>
    <cfset createPages(0,"")>

  </cffunction>

  <cffunction name="createPages">
    <cfargument name="sumsparent">
    <cfargument name="alfparent">
    <cfset sumschildren = getChildren(sumsparent)>
    <cfloop query="sumschildren">
      <cfquery name="getpagemeta" datasource="sums">
        select
          ObjectProperty.name,
          ObjectProperty.value
        from
          MetaData,
          ObjectProperty
        where
          MetaData.pageid = <cfqueryparam cfsqltype="cf_sql_integer" value="#id#">
          AND
          ObjectProperty.metaid = MetaData.id
      </cfquery>
      <!--- now, create a page in BV --->
      <cfset var PageData = {}>
      <cfset pageData["title"] = "#name#">
      <cfset pageData["name"] = "#friendlyUrl(name)#.html">
      <cfset pageData["template"] = LCASE(ListFirst(templatename," "))>
      <cfloop query="getpagemeta">
        <cfif name eq "text">
          <cfset cname = "content">
        <cfelse>
          <cfset cname = name>
        </cfif>
        <cfset pageData["#cname#"] = value>
      </cfloop>
      <cfset var jsonOb = {}>
      <cfset jsonOb["PageData"] = pageData>
      <!--- now we should have all our meta to create the page --->
      <cfhttp url="http://www.buildingvine.com/alfresco/service/sums/page?parentNodeRef=#arguments.alfparent#&siteID=#variables.bvsiteID#" username="tom.miller@ebiz.co.uk" password="aleighbishop" method="POST" result="requestResult">
        <cfhttpparam type="header" name="content-type" value="application/json">
        <cfhttpparam type="body" name="json" value="#serializeJSON(jsonOb)#">
      </cfhttp>
      <cfset newPage = DeSerializeJSON(requestResult.fileContent)>
      <cftry>
      <cfset createPages(id,newPage.page.nodeRef)>
      <cfcatch type="any"></cfcatch>
      </cftry>
    </cfloop>
  </cffunction>
  <cfscript>
  function friendlyUrl(title) {
    title = replaceNoCase(title,"&amp;","and","all"); //replace &amp;
    title = replaceNoCase(title,"&","and","all"); //replace &
    title = replaceNoCase(title,"'","","all"); //remove apostrophe
    title = reReplaceNoCase(trim(title),"[^a-zA-Z0-9]","-","ALL");
    title = reReplaceNoCase(title,"[\-\-]+","-","all");
    //Remove trailing dashes
    if(right(title,1) eq "-") {
        title = left(title,len(title) - 1);
    }
    if(left(title,1) eq "-") {
        title = right(title,len(title) - 1);
    }
    return lcase(title);
}
  </cfscript>
  <cffunction name="getChildren" output="false" access="public" returntype="query">
    <cfargument name="page" required="true" default="">
    <cfargument name="templateID" required="true" default="0">
    <cfargument name="orderBy" required="true" default="id">
    <cfargument name="orderDir" required="true" default="asc">
    <cfset var siteID = variables.sumsSiteID>

    <cfquery name="pages" datasource="sums">
      SELECT
       *,
       Template.name as templateName
      FROM
        Page,
        Template
      WHERE
        Page.siteid = <cfqueryparam cfsqltype="cf_sql_integer" value="#siteid#">
        <cfif templateID neq 0>
        AND
        templateid = <cfqueryparam cfsqltype="cf_sql_integer" value="#templateID#">
        </cfif>

        <cfif page neq "">
        AND parentID IN(<cfqueryparam value="#page#" list="true" cfsqltype="cf_sql_integer">)
        <cfelseif page eq "">
        <!--- do nothing! --->
        <cfelse>
        AND parentID IN(<cfqueryparam value="#getPage(page).id#" cfsqltype="cf_sql_integer">)
        </cfif>
        AND
        Template.id = Page.templateID
        Order by Page.id asc
      </cfquery>
     <cfreturn pages>
  </cffunction>
</cfcomponent>