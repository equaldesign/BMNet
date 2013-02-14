<cfcomponent name="blog" output="false" cache="true" cacheTimeout="30"  autowire="true">
  <cfproperty name="blog" inject="id:eunify.BlogService">
  <cfproperty name="contact" inject="id:eunify.ContactService">
  <cfproperty name="comment" inject="id:eunify.CommentService">
  <cfproperty name="CookieStorage" inject="coldbox:plugin:CookieStorage">

  <cffunction cache="true" name="index" returntype="void" output="false">
   <cfargument name="event">

   <cfset var rc = arguments.event.getCollection()>
   <cfset rc.filter = arguments.event.getValue("filter",0)>
   <cfif rc.sess.eGroup.contactID eq 0>
      <cfset setNextEvent(uri="/page/index")>
    </cfif>

   <cfset rc.id = arguments.event.getValue("id",0)>
   <cfscript>
    rc.boundaries = getMyPlugin("Paging").getBoundaries(20);
   </cfscript>
   <cfset rc.blogCount = blog.count().items>
   <cfset rc.blogList = blog.list(startRow=rc.boundaries.startRow-1,maxRows=rc.boundaries.maxrow,categoryID=rc.filter)>
   <cfset arguments.event.setView("blog/list")>
  </cffunction>

  <cffunction cache="true" name="related" returntype="void" output="false">
   <cfargument name="event">

   <cfset var rc = arguments.event.getCollection()>
   <cfset rc.relatedTo = arguments.event.getValue("relatedTo",0)>
   <cfset rc.relatedID = arguments.event.getValue("relatedID",0)>
   <cfset rc.blogList = blog.listRelated(rc.relatedID,rc.relatedTo)>
   <cfset arguments.event.setView("blog/listAll")>
  </cffunction>

  <cffunction cache="true" name="view" returntype="void" output="false">
   <cfargument name="event">

   <cfset var rc = arguments.event.getCollection()>
   <cfset rc.id = arguments.event.getValue("id",0)>
   <cfset rc.blogPost = blog.getBlogPost(rc.id)>
   <cfset rc.comments = comment.getComments(rc.id,"blog")>
   <cfset rc.commentLink = "">

   <cfif rc.blogPost.getid() neq "">
    <cfset rc.createdBy = contact.getContact(rc.blogPost.getcreatedBy())>
    <cfset rc.modifiedBy = contact.getContact(rc.blogPost.getmodifiedBy())>
   </cfif>

   <cfset arguments.event.setView("blog/post")>
  </cffunction>

  <cffunction name="edit" returntype="void" output="false">
   <cfargument name="event">

   <cfset var rc = arguments.event.getCollection()>
   <cfset rc.id = arguments.event.getValue("id",0)>
   <cfset rc.blogPost = blog.getBlogPost(rc.id)>
   <cfset rc.blog = {}>
   <cfset rc.blog.title = event.getValue("blogTitle",rc.blogPost.gettitle())>
   <cfset rc.blog.body = event.getValue("blogBody",rc.blogPost.getbody())>
   <cfset rc.blog.date = event.getValue("blogDate",rc.blogPost.getdate())>
   <cfset rc.blog.categoryID = event.getValue("blogCategory",rc.blogPost.getcategoryID())>
   <cfset rc.blog.relatedTo = event.getValue("blogRelatedTo",rc.blogPost.getrelatedTo())>
   <cfset rc.blog.relatedID = event.getValue("blogRelatedID",rc.blogPost.getrelatedID())>
   <cfset rc.blog.importance = event.getValue("blogImportance",rc.blogPost.getimportance())>
   <cfset rc.blogCategories = blog.blogCategories()>
   <cfif rc.blogPost.getid() neq "">
    <cfset rc.createdBy = contact.getContact(rc.blogPost.getcreatedBy())>
    <cfset rc.modifiedBy = contact.getContact(rc.blogPost.getmodifiedBy())>
   </cfif>
   <cfset arguments.event.setLayout("Layout.Main")>
   <cfset arguments.event.setView("blog/edit")>
  </cffunction>

  <cffunction name="delete" returntype="void" output="false">
   <cfargument name="event">

   <cfset var rc = arguments.event.getCollection()>
   <cfset rc.id = arguments.event.getValue("id",0)>
   <cfset rc.blogPost = blog.getblogPost(rc.id)>
   <cfset rc.blogPost.delete()>
   <cfif platform neq "CF9">
     <cfthread name="data_#createUUID()#" action="run" rc="#rc#">
        <cfset attributes.rc.blogPost.delete(remoteDB)>
     </cfthread>
   </cfif>
   <cfset setNextEvent("general.index")>
  </cffunction>

  <cffunction name="doEdit" returntype="void" output="false" hint="My main event">
      <cfargument name="event">

      <!--- should probably use a bean for this - but time is of the essence! --->
      <cfscript>
        var rc = arguments.event.getCollection();
        rc.id = arguments.event.getValue('id',0);
        if (rc.id neq 0 and rc.id neq "") {
          rc.blogPost = blog.getBlogPost(rc.id);
          rc.blogPost = populateModel(rc.blogPost);
        } else {
          rc.blogPost = populateModel(blog);
        }
        arguments.event.setLayout('Layout.Main');
        arguments.event.setView('debug');
        rc.blogPost.save();
        if (platform neq "CF9") {
         thread name="data_#createUUID()#" action="run" rc=rc {
          attributes.rc.blogPost.save(remoteDB);
         }
        }
				rc.sess.eGroup.editMode = false;
        setNextEvent("blog.view","id=#rc.blogPost.getid()###blog");
      </cfscript>

    </cffunction>
</cfcomponent>
