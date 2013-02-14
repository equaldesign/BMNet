<cfcomponent>
  <cfproperty name="TagService" inject="id:bv.TagService">
  <cffunction name="index">
    <cfargument name="event" required="true">
    <cfset var rc = event.getCollection()>

  </cffunction>
 