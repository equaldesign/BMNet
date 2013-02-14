<cfcomponent>
    <cfproperty name="tasks" inject="id:flo.TaskService">
    <cffunction name="new" hint="Create a new callback for a specific contact">
      <cfargument name="event">
      <cfset var rc = event.getCollection()>
      <cfset rc.system = event.getValue("system","BMNet")>
      <cfset rc.contactID = event.getValue("contactID",0)>
      <cfset event.setView("activity/callback/new")>
    </cffunction>

    <cffunction name="do" hint="Create a new callback for a specific contact">
      <cfargument name="event">
      <cfset var rc = event.getCollection()>
      <cfset rc.contact = event.getValue("related",{})>
      <cfset rc.participant = event.getValue("participant",{})>
      <cfset rc.name = event.getValue("activityname","")>
      <cfset rc.activityDescription = event.getValue("activityDescription","")>
      <cfset rc.dueDate = event.getValue("dueDate","")>
      <cfset rc.reminderDate = event.getValue("reminderDate","")>
      <cfset tasks.createCallback(rc.name,rc.activityDescription,rc.dueDate,rc.reminderDate,rc.contact,rc.participant)>
      <cfset setNextEvent(uri="/flo/general/index")>
    </cffunction>
</cfcomponent>