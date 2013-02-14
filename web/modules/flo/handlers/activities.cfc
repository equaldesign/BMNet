<cfcomponent>
  <cfproperty name="tasks" inject="id:flo.TaskService">
  <cfproperty name="relationship" inject="id:flo.RelationshipService">
  <cffunction name="myActivities" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.system = event.getValue("system","BMNet")>
    <cfset rc.hideNotDone = event.getValue("hideNotDone","true")>
    <cfset rc.activities = tasks.getMyactivities(rc.system,rc.hideNotDone)>
    <cfset event.setView("activity/myActivities")>
  </cffunction>

  <cffunction name="assign" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.id = event.getValue("id")>
    <cfset rc.contactID = event.getValue("contactID")>

    <cfset tasks.assignActivityTo(rc.id,rc.contactID)>
    <cfset setNextEvent(uri="/flo/item/detail/id/#tasks.getActivity(rc.id).itemID#")>
  </cffunction>

  <cffunction name="new">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset tasks.addActivity(rc.activityName,rc.description,rc.dueDate,rc.reminderDate,rc.itemID)>
    <cfset setNextEvent(uri="/flo/item/detail/id/#rc.itemID#")>
  </cffunction>

  <cffunction name="markdone" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.id = event.getValue("id")>
    <cfset rc.complete = event.getValue("complete",true)>
    <cfset tasks.completeActiviy(rc.id,rc.complete)>
    <cfset setNextEvent(uri="/flo/item/detail/id/#tasks.getActivity(rc.id).itemID#")>
  </cffunction>

  <cffunction name="pushBack" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.activityID = event.getValue("activityID",0)>
    <cfset rc.newDate = event.getValue("newDate",0)>
    <cfset tasks.pushBack(rc.activityID,rc.newDate)>
    <cfset event.noRender()>
  </cffunction>

  <cffunction name="changePriority" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.activityID = event.getValue("activityID",0)>
    <cfset rc.priority = event.getValue("priority",0)>
    <cfset tasks.changePriority(rc.activityID,rc.priority)>
    <cfset event.noRender()>
  </cffunction>
</cfcomponent>