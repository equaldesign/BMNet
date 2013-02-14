
<cfcomponent output="false" autowire="true">

	<!--- dependencies --->

	<!--- index --->
	<cffunction name="index" returntype="void" output="false" cache="true">
		<cfargument name="Event">
		<cfscript>
			var rc = event.getCollection();
      rc.section = event.getValue("section","index");           
      rc.leftMenu = "tour"; 
      arguments.event.setView("public/tour/#rc.section#"); 
		</cfscript>
	</cffunction>
	<cffunction name="pricing" returntype="void" output="false" cache="true">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();                
      rc.showMenu = false;
      arguments.event.setView("public/pricing/index"); 
    </cfscript>
  </cffunction>
</cfcomponent>  