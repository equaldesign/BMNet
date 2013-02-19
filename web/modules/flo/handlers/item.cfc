<cfcomponent>
  <cfproperty name="tasks" inject="id:flo.TaskService">
  <cfproperty name="relationship" inject="id:flo.RelationshipService">
  <cfproperty name="WorklogService" inject="id:flo.WorklogService">
  <cfproperty name="CommentService" inject="id:eunify.CommentService">
  <cffunction name="changeStage" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.stages = tasks.setStage(rc.id,rc.stageID)>
    <cfset event.renderData("PLAIN","")>
  </cffunction>
  <cffunction name="new" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.relatedSystem = event.getValue("relatedSystem","BMNet")>
    <cfset rc.relatedID = event.getValue("relatedID",0)>
    <cfset rc.relatedType = event.getValue("relatedType","contact")>
    <cfset rc.itemName = event.getValue("itemName","")>
    <cfset rc.itemType = event.getValue("itemType","callback")>
    <cfset rc.relatedObject = relationship.getRelatedObject(rc.relatedSystem,rc.relatedType,rc.relatedID)>
    <cfset rc.itemTypes = tasks.getItemTypes()> 
    <cfset rc.contactObject = relationship.getRelatedObject("BMNet","contact",request.BMNet.contactID)>
    <cfset event.setView("task/new")> 
  </cffunction>

  <cffunction name="edit" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.id = event.getValue("id",0)>
    <cfset rc.task = tasks.getTask(rc.id)>
    <cfset rc.system = event.getValue("system","BMNet")>
    <cfset rc.relatedID = event.getValue("relatedID",0)>
    <cfset rc.relatedType = event.getValue("relatedType","contact")>
    <cfif rc.id eq 0>
      <cfset related = {}>
      <cfset related.type = rc.relatedType>
      <cfset related.system = rc.system>
      <cfset related.object = []>
      <cfset rc.task.dependencies = relationship.getRelatedObject(rc.system,"contact",request["#rc.system#"].contactID)>
      <cfset QueryAddColumn(rc.task.dependencies,"system","VarChar",["#rc.system#"])>
    <cfelse>
      <cfset rc.stages = tasks.getStages(rc.task.task.itemName)>
    </cfif>
    <cfset rc.itemTypes = tasks.getItemTypes()>
    <cfset event.setView("task/edit")>
  </cffunction>

  <cffunction name="myItems" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.taskList = tasks.getMyTasks()>
    <cfset event.setView("task/list")>
  </cffunction>

  <cffunction name="list" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.system = event.getValue("system","BMNet")>
    <cfset rc.taskList = tasks.getAllTasks()>
    <cfset event.setView("task/list")>
  </cffunction>

  <cffunction name="detail" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.item = tasks.getTask(rc.id)>
    <cfset rc.comments = CommentService.getComments(rc.id,"floItem")>
    <cfif isUserInRole("staff")>
      <cfset rc.commentLink = "/eunify/comment/add/tID/#rc.id#/t/floItem">
    </cfif>
    <cfset rc.worklogService = WorklogService>
    <cfif NOT isUserLoggedIn()>
      <cfset rc.email = UrlDecrypt(event.getValue("key"))>
      <!--- try to find the email in the related or participants --->
      <cfif not tasks.isAuthorised(rc.id,rc.email)>
        <cfset setNextEvent(uri="/login")>
      </cfif>
    </cfif>
    <cfset event.setView("task/detail")>
  </cffunction>

  <cffunction name="do" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.s = {}>
    <cfset rc.s.id = event.getValue("id",0)>
    <cfset rc.s.name = event.getValue("name","")>
    <cfset rc.s.description = event.getValue("description","")>
    <cfset rc.s.status = event.getValue("status","")>
    <cfset rc.s.amount = event.getValue("amount",0)>
    <cfset rc.s.stage = event.getValue("stage",0)>
    <cfset rc.s.itemType = event.getValue("itemType","")>
    <cfset rc.s.relationship = event.getValue("relationship",[])>
    <cfset rc.s.activity = event.getValue("activity",[])>
    <cfset rc.s.participant = event.getValue("participant",[])>

    <cfset rc.id = tasks.saveItem(rc.s)>
    <cfset setNextEvent(uri="/flo/item/detail/id/#rc.id#")>
  </cffunction>
</cfcomponent>