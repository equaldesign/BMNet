<cfcomponent output="false" cache="true" cacheTimeout="30" >

  <cfproperty name="bugs" inject="model:BugService" scope="instance" />
  <cfproperty name="dsn" inject="coldbox:datasource:bugs" scope="instance" />
  <cfscript>
    instance = structnew();
  </cfscript>

  <cffunction name="index" returntype="void" output="false">
    <cfargument name="event" required="true">
    <cfset var rc = event.getCollection()>
	  <cfset rc.type = event.getValue("type","help")>    
    <cfset event.setView('charts/overview')>
  </cffunction>
  
  <cffunction name="chartData" returntype="void" output="false">
    <cfargument name="event" required="true">
    <cfset var rc = event.getCollection()>
    <cfscript>
		  rc.filterBy = event.getValue("filterBy","type");
      rc.filterValue = event.getValue("filterValue","help");
      rc.salesData = instance.bugs.bugChartData(rc.filterBy,rc.filtervalue);
      event.renderData(data=rc.salesData,type="JSON");    
	</cfscript>
  </cffunction>

</cfcomponent>