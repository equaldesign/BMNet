
<cfcomponent cache="true" output="false" autowire="true">

  <!--- dependencies --->
  <cfproperty name="userService" inject="id:bv.userService">
  <cfproperty name="siteService" inject="id:bv.SiteService">
  <cfproperty name="blogService" inject="id:bv.BlogService">
  <cfproperty name="AuditService" inject="id:bv.AuditService">
  <cfproperty name="Paging" inject="coldbox:MyPlugin:Paging">
  <cfproperty name="commentService" inject="id:bv.CommentService">
  <!--- preHandler --->

  <!--- index --->
  <cffunction cache="true" name="index" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.paging = Paging;
      rc.paging.setPagingMaxRows(5);
      rc.boundaries = rc.paging.getBoundaries(5);
      rc.blog = blogService.getPosts(rc.bvsiteID,rc.boundaries.startRow,5);
      event.setView("#rc.viewPath#/blog/list");
    </cfscript>
  </cffunction>

  <cffunction name="edit" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript> 
      var rc = event.getCollection();
      rc.nodeRef = event.getValue("nodeRef","");
      if (rc.nodeRef neq "") {
        rc.blog = blogService.getPost(rc.nodeRef,"");
        rc.blogPostURL = "/alfresco/service/api/#rc.blog.url#?alf_ticket=#request.user_ticket#";
        rc.method = "PUT";
        rc.title = rc.blog.title;
        rc.content = rc.blog.content;
        rc.tags = ArrayToList(rc.blog.tags);
      } else {
        rc.blogPostURL = "/alfresco/service/api/blog/site/#lcase(request.bvsiteID)#/blog/posts?alf_ticket=#request.user_ticket#";
        rc.title = "";
        rc.content = "";
        rc.tags = "";
        rc.method = "POST";
      }
      event.setView("web/blog/edit");
    </cfscript>
  </cffunction>

  <cffunction cache="true" name="item" returntype="void" output="false">
    <cfargument name="Event">
    <cfscript>
      var rc = event.getCollection();
      rc.nodeRef = event.getValue("nodeRef","");
      rc.pageLink = event.getValue("pageLink","");
      rc.blog = blogService.getPost(rc.nodeRef,rc.pageLink);
      if (isUserInRole("admin_#request.bvsiteID#")) {
        rc.reach = AuditService.getReach(rc.blog.qName);
      }
      rc.comments = commentService.getComments(rc.blog.commentsUrl);
      rc.commentsUrl = rc.blog.commentsUrl;
      event.setView("web/blog/item");
    </cfscript>
  </cffunction>
</cfcomponent>