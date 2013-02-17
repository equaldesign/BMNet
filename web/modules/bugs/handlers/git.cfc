<cfcomponent output="false" cache="true" cacheTimeout="30" >

  <cfproperty name="bugs" inject="model:BugService" scope="instance" />
  <cfproperty name="dsn" inject="coldbox:datasource:bugs" scope="instance" />
  <cfproperty name="logger" inject="logbox:root" />  
  <cfproperty name="floRelationShipService" inject="id:flo.RelationShipService">
  <cfproperty name="floTaskService" inject="id:flo.TaskService">
  <cfproperty name="pingdom" inject="model:pingdomService">
  <cffunction name="push" returntype="void">
    <cfset var rc = event.getCollection()>
    <cfset rc.gitPayLoad = event.getValue("payload")>
    <cfset prc.plO = DeSerializeJSON(rc.gitPayLoad)>
    <cfset thisU = prc.plO.head_commit.url>
    <cfset thisU = Replace(thisU,"github.com","api.github.com/repos")>
    <cfset thisU = Replace(thisU,"commit","commits")>
    <cfhttp url="#thisU#" result="commitDetail"></cfhttp>     
    <cfset logger.debug(thisU)>
    <cffile action="write" file="/tmp/git.tmp" output="#commitDetail.fileContent#">
    <cfset prc.commit = DeSerializejson(commitDetail.fileContent)>
    <cfset ticketA = ReFindNoCase("[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{16}",prc.commit.commit.message,1,true)>
    <cfset ticket = mid(prc.commit.commit.message,ticketA.pos[1],ticketA.len[1])>
    <cfset bug = instance.bugs.getBug("",ticket)>
    <cfquery name="insertD" datasource="#instance.dsn.getName()#">
      insert into codeCommits (bugID,commitJSON)
      VALUES
      (
        <cfqueryparam cfsqltype="cf_sql_integer" value="#bug.getid()#">,
        <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#commitDetail.fileContent#">
      )
    </cfquery>
    <cfset event.noRender()>
  </cffunction> 
</cfcomponent>