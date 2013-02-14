<cfcomponent outut="false" hint="The bvine module service layer" cache="true">

	<!--- Dependencies --->

	<cfproperty name="userService" inject="model:UserService"  scope="instance" />

	<!--- init --->
	<cffunction name="init" output="false" access="public" returntype="any" hint="Constructor">
		<cfscript>
			return this;
		</cfscript>
	</cffunction>


	<!--- getParentListing --->
	<cffunction name="getBlog" output="false" access="public" returntype="any">
		<cfargument name="siteID" required="true" type="string">
		<cfset var ticket = request.buildingVine.admin_ticket>
		<cfset apiPath="http://46.51.188.170/alfresco/service/api/blog/site/#siteID#/blog?alf_ticket=#ticket#">
    	<cfhttp port="8080" url="#apiPath#" result="siteBlog"></cfhttp>
   		<cfreturn DeserializeJSON(siteBlog.fileContent)>
	</cffunction>

  <cffunction name="getRecent" output="false" access="public" returntype="any">
    <cfargument name="siteID" required="true" default="">
    <cfset var ticket = request.buildingVine.admin_ticket>
    <cfset var returnObject = {}>
    <cfset apiPath="http://46.51.188.170/alfresco/service/bv/recent/blog?siteID=#arguments.siteID#&alf_ticket=#ticket#">
    <cfhttp port="8080" url="#apiPath#" result="siteBlog"></cfhttp>
    <cfset returnObject = DeserializeJSON(siteBlog.fileContent)>
    <cftry>
      <cfloop array="#returnObject.items#" index="item">
        <cfset item.blogImage = getBlogImage(ListLast(item.url,"/"))>
      </cfloop>
      <cfreturn returnObject>
      <cfcatch type="any">
      <cfset returnObject = {}>
      <cfset returnObject.items = []>
        <cfreturn returnObject>
      </cfcatch>
    </cftry>

  </cffunction>

	<cffunction name="getPosts" access="public" returntype="any" output="false">
    	<cfargument name="siteID" required="true" type="string">
    	<cfargument name="startRow" required="true" type="numeric" default="0">
      <cfargument name="pageSize" required="true" type="numeric" default="10">
    	<cfset var ticket = request.buildingVine.admin_ticket>
    	<cfset blogURL = getBlog(siteID).item.blogPostsUrl>
   		<cfset apiPath="http://46.51.188.170/alfresco/service/api/#blogURL#?startIndex=#startRow-1#&pageSize=#pageSize#&alf_ticket=#ticket#">
    	<cfhttp port="8080" url="#apiPath#" result="blogPages"></cfhttp>
      <cfset var returnObject = {}>
      <cfset returnObject = DeserializeJSON(blogPages.fileContent)>
      <cfloop array="#returnObject.items#" index="item">
        <cfset item.blogImage = getBlogImage(ListLast(item.url,"/"))>
      </cfloop>
    	<cfreturn returnObject>
  </cffunction>

    <cffunction name="getPost" access="public" returntype="any" output="false">
	    <cfargument name="postID" type="string" required="true">
		  <cfargument name="pageLink" type="string" required="true">
      <cfargument name="siteID" type="string" required="true" default="#request.bvsiteID#">
	    <cfset var ticket = request.buildingVine.admin_ticket>
		  <cfset var returnStruct = {}>
      <cfif arguments.pageLink neq "">
		  	 <cfset postURL = "http://46.51.188.170/alfresco/service/api/blog/post/site/#arguments.siteID#/blog/#ListLast(arguments.pageLink,"=")#?alf_ticket=#ticket#">
			<cfelse>
		    <cfset postURL = "http://46.51.188.170/alfresco/service/api/#postID#?alf_ticket=#ticket#">
		  </cfif>
    	<cfhttp port="8080" method="get" url="#posturl#" result="blogPost"></cfhttp>
      <cfset returnStruct = DeserializeJSON(blogPost.fileContent).item>
      <cftry>
        
      
      <cfset returnStruct.blogImage = getBlogImage(returnStruct.nodeRef)>
      <cfcatch type="any"></cfcatch>
      </cftry>
	    <cfreturn returnStruct>
  	</cffunction>

    <cffunction name="getBlogImage" returntype="string">
      <cfargument name="nodeRef">
      <cfquery name="f" datasource="bvine">
        select imageURL from blogImage where blogNode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.nodeRef#">
      </cfquery>
      <cfreturn f.imageURL>
    </cffunction>

    <cffunction name="createPost" access="public" returntype="Struct">
      <cfargument name="title">
      <cfargument name="tags">
      <cfargument name="contents">
      <cfargument name="siteID">
      <cfargument name="siteBlog">
      <cfset var ticket = request.user_ticket>
	    <cfset js = StructNew()>
	    <cfset js["title"] = title>
	    <cfset js["content"] = contents>
	    <cfset js["tags"] = tags>
      <cfset js["page"] = "/blog/viewPost/siteID/#siteID#/">
      <cfset js["container"] = "blog">
	    <cfset js["site"] = siteID>
	    <cfhttp port="8080" method="post" url="http://46.51.188.170/alfresco/service/api/#siteBlog.item.blogPostsUrl#?alf_ticket=#ticket#" result="blogPost">
	      <cfhttpparam type="header" name="content-type" value="application/json">
	      <cfhttpparam type="body" name="json" value="#serializeJSON(js)#">
	    </cfhttp>
	    <cfreturn DeserializeJSON(blogPost.fileContent).item>
    </cffunction>

    <cffunction name="editPost" access="public" returntype="Struct">
      <cfargument name="title">
      <cfargument name="tags">
      <cfargument name="contents">
      <cfargument name="siteID">
      <cfargument name="postURL">
      <cfset var ticket = request.user_ticket>
      <cfset js = StructNew()>
      <cfset js["title"] = title>
      <cfset js["content"] = contents>
      <cfset js["tags"] = tags>
      <cfset js["page"] = "/blog/viewPost/siteID/#siteID#/">
      <cfset js["container"] = "blog">
      <cfset js["site"] = siteID>
      <cfhttp port="8080" method="put" url="http://46.51.188.170/alfresco/service/api/#postURL#?alf_ticket=#ticket#" result="blogPost">
        <cfhttpparam type="header" name="content-type" value="application/json">
        <cfhttpparam type="body" name="json" value="#serializeJSON(js)#">
      </cfhttp>
      <cfreturn DeserializeJSON(blogPost.fileContent).item>
    </cffunction>

    <cffunction name="deletePost" access="public" returntype="void">
      <cfargument name="postURL">
      <cfset var ticket = request.user_ticket>
      <cfhttp port="8080" method="delete" url="http://46.51.188.170/alfresco/service/api/#postURL#?alf_ticket=#ticket#" result="blogPost">
      </cfhttp>
    </cffunction>
</cfcomponent>