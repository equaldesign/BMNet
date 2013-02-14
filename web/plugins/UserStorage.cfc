
<cfcomponent name="UserStorage"
       hint="Flash Storage plugin. It provides the user with a mechanism for permanent data storage using the flash scope."
       extends="coldbox.system.Plugin"
       output="false"
       cache="true">

  <cfproperty name="CookieStorage" inject="coldbox:plugin:CookieStorage" />
  <cfproperty name="ApplicationStorage" inject="coldbox:plugin:ApplicationStorage" />
  <cfproperty name="SessionStorage" inject="coldbox:plugin:SessionStorage" />
  <cfproperty name="logger" inject="logbox:root">
  <cffunction name="init" access="public" returntype="UserStorage" output="false">
    <cfargument name="controller" type="any" required="true">
    <cfscript>
      super.Init(arguments.controller);

      // Plugin Properties
      setpluginName("Flash Storage");
      setpluginVersion("1.0");
      setpluginAuthor("Tom Miller");
      setpluginDescription("A permanent data storage plugin using the flash scope.");

      // Lock Properties
      instance.lockTimeout = 20;

      return this;
    </cfscript> 
  </cffunction>

<!------------------------------------------- PUBLIC ------------------------------------------->

  <!--- Set a variable --->
  <cffunction name="setVar" access="public" returntype="void" hint="Set a new permanent variable." output="false">
    <!--- ************************************************************* --->
    <cfargument name="name"  type="string" required="true" hint="The name of the variable.">
    <cfargument name="value" type="any"    required="true" hint="The value to set in the variable.">
      
        <cfset SessionStorage.setVar(name,value)>
        <cfset logger.debug("Setting session var: #name# #GetHttpRequestData().headers['X-Forwarded-For']#")>
      
    <!---
      <cfset var secureLogin = CookieStorage.getVar("clusterUser","")>
      <cfif isSimpleValue(secureLogin) and secureLogin neq "">
        <cfset cacheObject["#arguments.name#"] = getVar(arguments.name)>
        <cfset cacheObject["#arguments.name#"] = arguments.value>
        <cfset UserCache.set(urlEncrypt("#secureLogin#_#siteName#"),cacheObject)>
      </cfif>
    --->
  </cffunction>
 
  <!--- Get A Variable --->
  <cffunction name="getVar" access="public" returntype="any" hint="Get a new permanent variable. If the variable does not exist. The method returns blank." output="false">
    <!--- ************************************************************* --->
    <cfargument  name="name"    type="string"  required="true"    hint="The variable name to retrieve.">
    <cfargument  name="default"   type="any"     required="false"   hint="The default value to set. If not used, a blank is returned." default="">
    <cfreturn SessionStorage.getVar(name,ApplicationStorage.getVar(arguments.name,arguments.default))>
    <!---
    <cfset var secureLogin = CookieStorage.getVar("clusterUser","")>
    <cfif isSimpleValue(secureLogin) and secureLogin neq "" AND UserCache.lookup(urlEncrypt("#secureLogin#_#siteName#"))>
      <cfset cacheObject = UserCache.get(urlEncrypt("#secureLogin#_#siteName#"))>

      <cfif isDefined("cacheObject") AND isStruct(cacheObject) AND StructKeyExists(cacheObject,arguments.name)>
        <cfreturn cacheObject[UCASE(arguments.name)]>
      <cfelse>
        <cfreturn ApplicationStorage.getVar(arguments.name,arguments.default)>
      </cfif>
    <cfelse>
      <cfreturn ApplicationStorage.getVar(arguments.name,arguments.default)>
    </cfif>
    --->
  </cffunction>


<Cfscript>
  function urlEncrypt(queryString){
    // encode the string
    var key = "cockcheddar";
    var uue = cfusion_encrypt(queryString, key);

    // make a checksum of the endoed string
    var checksum = left(hash(uue & key),2);

    // assemble the URL
    queryString = uue & checksum ;

    return queryString;
}
</cfscript>




</cfcomponent>
