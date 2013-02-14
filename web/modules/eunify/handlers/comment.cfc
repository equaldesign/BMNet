<cfcomponent name="commentHandler" output="false" cache="true" cacheTimeout="30" autowire="true">

  <!------------------------------------------- PUBLIC EVENTS ------------------------------------------>
  <!--- Default Action --->
  <cfproperty name="comment" inject="id:eunify.CommentService" />
  <cfproperty name="SubscriptionService" inject="id:eunify.SubscriptionService">


    <cfscript>
  instance = structnew();
  </cfscript>
  <cffunction name="list" returntype="void" output="false">
    <cfargument name="event">

    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.relatedID = arguments.event.getValue("relatedID",0)>
    <cfset rc.relatedType = arguments.event.getValue("relatedType","")>
    <cfset rc.commentLink = "/eunify/comment/add/t/#rc.relatedType#/tID/#rc.relatedID#">
    <cfset rc.comments = comment.getComments(rc.relatedID,rc.relatedType)>
    <cfset arguments.event.setView("comment/list")>
  </cffunction>

  <cffunction name="userlist" returntype="void" output="false">
    <cfargument name="event">

    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.relatedID = arguments.event.getValue("relatedID",0)>
    <cfset rc.relatedType = arguments.event.getValue("relatedType","")>
    <cfset rc.commentLink = "/comment/add/t/#rc.relatedType#/tID/#rc.relatedID#">
    <cfset rc.comments = comment.getComments(rc.relatedID,rc.relatedType)>
    <cfset arguments.event.setView("comment/list")>
  </cffunction>

  <cffunction name="add" returntype="void" output="false" hint="My main event">
    <cfargument name="event">

    <cfscript>
      var rc = arguments.event.getCollection();
      rc.relatedType = arguments.event.getValue("t","");
      rc.relatedID = arguments.event.getValue("tID",0);
      rc.title = arguments.event.getValue("title","");
      rc.comment = arguments.event.getValue("comment","");
      rc.contactID = arguments.event.getValue("contactID",request.bmnet.contactID);
      rc.commentKey = arguments.event.getValue("commentKey","");
      comment.addComment(
        relatedID=rc.relatedID,
        relatedType=rc.relatedType,
        title=rc.title,
        comment=rc.comment,
        contactID=rc.contactID,
        commentKey=rc.commentKey
      );
      SubscriptionService.add(rc.relatedID,rc.relatedType,rc.contactID);
    </cfscript>
    <cfset arguments.event.setLayout('Layout.ajax')>
    <cfset arguments.event.setView('comment/showAfterAdd')>
  </cffunction>
  <cffunction name="attachment" returntype="void">
    <cfargument name="event">

    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.file = arguments.event.getValue("f","")>
    <cfset arguments.event.setView(name="comment/attachment",noLayout=true)>
  </cffunction>
  <cffunction name="delete" returntype="void" output="false" hint="My main event">
    <cfargument name="event">

    <cfscript>
      var rc = arguments.event.getCollection();
      rc.id = arguments.event.getValue("id","");
      comment.deleteComment(rc.id);

    </cfscript>
    <cfset arguments.event.setLayout('Layout.ajax')>
    <cfset arguments.event.setView('blank')>
  </cffunction>

  <!------------------------------------------- PRIVATE EVENTS ------------------------------------------>
</cfcomponent>