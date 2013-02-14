
<cfcomponent name="jsonChecker"
       hint="Flash Storage plugin. It provides the user with a mechanism for permanent data storage using the flash scope."
       extends="coldbox.system.Plugin"
       output="false"
       cache="true">

  
  <cffunction name="init" access="public" returntype="jsonChecker" output="false">
    <cfargument name="controller" type="any" required="true">
    <cfscript>
      super.Init(arguments.controller);

      // Plugin Properties
      setpluginName("JSON HTTP Check");
      setpluginVersion("1.0");
      setpluginAuthor("Tom Miller");
      setpluginDescription("Checks if http data is ok");

      // Lock Properties
      instance.lockTimeout = 20;

      return this;
    </cfscript>
  </cffunction>

<!------------------------------------------- PUBLIC ------------------------------------------->

  <!--- Set a variable --->
  <cffunction name="check" access="public" returntype="any" hint="checks for data" output="false">
    <!--- ************************************************************* --->
    <cfargument name="data"  type="struct" required="true" hint="The name of the variable.">    
    <cfif data.status_code eq 200>
      <cfreturn deserializeJSON(arguments.data.fileContent)>
    <cfelse>
      <cfthrow errorcode="503" message="#arguments.data.fileContent#">
    </cfif>    
  </cffunction>

</cfcomponent>
