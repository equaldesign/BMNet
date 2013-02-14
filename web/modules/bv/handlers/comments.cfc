
<cfcomponent output="false" autowire="true">

  <!--- dependencies --->
  <cfproperty name="userService" inject="id:bv.userService">
  <cfproperty name="commentService" inject="id:bv.CommentService">

  <!--- preHandler --->

  <!--- index --->
  <cffunction name="index" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.commentLabel = event.getValue("label","comment");
      rc.commentTitle = event.getValue("title",true);
      rc.nodeRef = event.getValue("nodeRef","");
      rc.commentsURL = "/node/workspace/SpacesStore/#rc.nodeRef#/comments";
      rc.comments = commentService.getComments(rc.commentsURL);
      event.setView("web/comments/list");
    </cfscript>
  </cffunction>

  <cffunction name="ajaxList" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.letter = event.getValue("letter","A");
      paging = getMyPlugin("Paging");
      rc.boundaries = paging.getBoundaries();
      rc.companies = companyService.getList(rc.siteID,"Customers",rc.letter,rc.boundaries.startRow,rc.boundaries.maxrow);
      event.setView("secure/customers/panelList");
    </cfscript>
  </cffunction>

  <cffunction name="detail" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.nodeRef = event.getValue("nodeRef","");
      rc.company = companyService.getCompany(rc.nodeRef);
      event.setView("secure/customers/index");
    </cfscript>
  </cffunction>
  <cffunction name="edit" returntype="void" output="false">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.nodeRef = event.getValue("nodeRef","")>
    <cfif rc.nodeRef neq "">
      <cfset companyService.getCompany(rc.nodeRef)>
    </cfif>
    <cfset rc.company = companyService>
    <cfset event.setView("secure/customers/edit")>
  </cffunction>

  <cffunction name="doEdit" returntype="void" output="false">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.nodeRef = event.getValue("nodeRef","")>
    <cfif rc.nodeRef neq "">
      <cfset companyService.getCompany(rc.nodeRef)>
    </cfif>
    <cfset rc.company = populateModel(companyService)>
    <cfset rc.company.save()>
    <cfset event.setView("secure/customers/create")>
  </cffunction>
</cfcomponent>