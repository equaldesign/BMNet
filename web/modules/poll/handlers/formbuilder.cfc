<cfcomponent name="formBuilder" output="false" cache="true" cacheTimeout="30" autowire="true">
  <!------------------------------------------- PUBLIC EVENTS ------------------------------------------>
  <!--- Default Action --->
  <cfproperty name="formbuilder" inject="id:poll.formbuilder">


  <cfscript>
    instance = structnew();
  </cfscript>

  <cffunction name="edit" returntype="void" output="false" hint="My main event">
    <cfargument name="event">
    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.table = event.getValue("table","")>
    <cfset rc.field = event.getValue("field","")>
    <cfset rc.id = event.getValue("id","")>
    <cfset rc.value = event.getValue("value","")>
    <cfset formbuilder.editValue(rc.table,rc.field,rc.id,rc.value)>
    <cfset arguments.event.setView('blank')>
  </cffunction>

  <cffunction name="delete" returntype="void" output="false" hint="My main event">
    <cfargument name="event">
    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.type = event.getValue("type","")>
    <cfset rc.id = event.getValue("id","")>
    <cfset formbuilder.delete(rc.type,rc.id)>
    <cfset arguments.event.setView('blank')>
  </cffunction>

  <cffunction name="move" returntype="void" output="false" hint="My main event">
    <cfargument name="event">
    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.jsonData = deserializeJSON(toString(getHttpRequestData().content))>
    <cfset formbuilder.move(rc.jsonData)>
    <cfset arguments.event.setView('blank')>
  </cffunction>

  <cffunction name="addoption" returntype="void" output="false" hint="My main event">
    <cfargument name="event">
    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.table = event.getValue("table","")>
    <cfset rc.rel = event.getValue("rel","")>
    <cfset rc.id = event.getValue("id","")>
    <cfset rc.value = event.getValue("value","")>
    <cfset formbuilder.addOption(rc.table,rc.rel,rc.id,rc.value)>
    <cfset arguments.event.setView('blank')>
  </cffunction>

  <cffunction name="addField" returntype="void" output="false" hint="My main event">
    <cfargument name="event">
    <cfset var rc = arguments.event.getCollection()>
    <cfset formbuilder.addField(
      id =  event.getValue("id",""),
      label = event.getValue("label",""),
      name = event.getValue("name",""),
      encryptIt = event.getValue("encrypt",""),
      rel = event.getValue("rel",""),
      requireIt = event.getValue("required",""),
      requirenumeric = event.getValue("requirenumeric","false"),
      type = event.getValue("type",""),
      table = event.getValue("table","")
    )>
    <cfset arguments.event.setView('blank')>
  </cffunction>

  <cffunction name="addGroup" returntype="void" output="false" hint="My main event">
    <cfargument name="event">
    <cfset var rc = arguments.event.getCollection()>
    <cfset formbuilder.addGroup(
      name = event.getValue("name",""),
      id = event.getValue("id",""),
      description = event.getValue("description",""),
      rel = event.getValue("rel",""),
      table = event.getValue("table","")
    )>
    <cfset arguments.event.setView('blank')>
  </cffunction>
  </cfcomponent>