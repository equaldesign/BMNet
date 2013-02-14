<cfcomponent outut="false" hint="The bvine module service layer" cache="true">

	<cfproperty name="userService" inject="model:UserService" />


  <cffunction name="getPage" access="public" returntype="string" output="false">
    <cfargument name="site">
    <cfargument name="title">
    <cfset var ticket = request.user_ticket>
    <cfset apiPath="http://46.51.188.170/alfresco/service/slingshot/wiki/page/#site#/#title#?format=mediawiki">
    <cfhttp port="8080" url="#apiPath#" result="wikiPages" username="admin" password="bugg3rm33"></cfhttp>
    <cfreturn render_links(wikiPages.fileContent,"/pages")>
  </cffunction>

  <cffunction name="getPageList" access="public" returntype="struct" output="false">
    <cfargument name="site" required="true" default="buildingVine">
    <cfargument name="filter" required="true" default="all">
    <cfset var ticket = request.user_ticket>
    <cfset apiPath="http://46.51.188.170/alfresco/service/slingshot/wiki/pages/#site#?filter=#arguments.filter#&alf_ticket=#ticket#">
    <cfhttp port="8080" url="#apiPath#" result="wikiPages"></cfhttp>
    <cfreturn DeSerializeJSON(wikiPages.fileContent)>
  </cffunction>

	<cffunction name="render_links" output="false" returnType="string">
    <cfargument name="string" type="string" required="true">
    <cfargument name="webpath" type="string" required="true"> 

	  <!--- First test, URLS in the form of [[label]] --->
	  <cfset var matches = reFindAll("\[\[[^<>]+?\]\]",arguments.string)>
	  <cfset var x = "">
	  <cfset var match = "">
	  <cfset var label = "">
	  <cfset var location = "">
	  <cfset var newString = "">
	  <cfset var imageinfo = StructNew()>

	  <cfif matches.pos[1] gt 0>
	    <cfloop index="x" to="1" from="#arrayLen(matches.pos)#" step="-1">
	      <cfset match = mid(arguments.string, matches.pos[x], matches.len[x])>
	      <!--- remove [[ and ]] --->
	      <cfset match = mid(match, 3, len(match)-4)>
	      <!--- Two kinds of matches: path or path|label
	      Also, path can be a URL or a internal match. --->
	      <cfif listLen(match, "|") gte 2>
	        <cfset label = listLast(match, "|")>
	        <cfset location = listFirst(match, "|")>
	      <cfelse>
	        <cfset label = match>
	        <cfset location = match>
	      </cfif>

	      <cfif isValid("url", location)>
	        <!--- external link --->
	        <cfset newString = "<a rel=""#location#"" class='ajaxMain normal' href=""#location#"">#label#</a>">
	      <cfelseif LCase(ListFirst(location, ":")) EQ "category">
	        <!--- Category link: add it the categories array, but do not output the link here --->
	        <cfset ArrayAppend(variables.categories, trim(ListRest(location, ":")))>
	        <cfset newString="">
	      <cfelseif LCase(ListFirst(location, ":")) EQ "image">
	        <!--- Image link: render an image source --->
	        <!--- may have a vertical bar to add alternate text--->
	        <cfset imageinfo.filename=trim(ListFirst(ListRest(location, ":"), "|"))>
	        <cfset imageinfo.fileNameWithUnderscores=replace(imageinfo.filename, " ", "_", "ALL")>
	        <cfset imageinfo.altText="">
	        <cfif listlen(location, "|") GT 1>
	          <cfset imageinfo.altText=trim(ListGetAt(location, 2, "|"))>
	        <cfelse>
	          <cfset imageinfo.altText=imageinfo.filename>
	        </cfif>
	        <!--- use HTMLEditFormat() to encode non-valid characters--->
	        <cfset imageinfo.altText=HTMLEditFormat(imageinfo.altText)>
	        <cfset newString="<a class='ajaxMain normal' href=""#arguments.webpath#/index.cfm/Special.Files.#imageinfo.fileNameWithUnderscores#"">">
	        <cfset newString=newString & "<img src=""#arguments.webpath#/index.cfm?event=Main&path=Special.Files.#imageinfo.fileNameWithUnderscores#&showfile=true"" alt=""#imageinfo.altText#"" title=""#imageinfo.altText#"" class=""wiki_inline_image"" />">
	        <cfset newString=newString & "</a>">
	      <cfelseif LCase(ListFirst(location, ":")) EQ "media">
	        <!--- media link --->
	        <!--- change to a special page and replace spaces with underscores --->
	        <cfset newString = "<a class='ajaxMain normal' href=""#arguments.webpath#/index.cfm?event=Main&path=Special.Files.#Replace(trim(ListRest(location, ":")), " ", "_", "ALL")#&showfile=1"">#label#</a>">
	      <cfelse>
	        <!--- normal internal link --->
	        <!--- replace spaces with underscores --->
	        <cfset newString = "<a rel=""#arguments.webpath#/#Replace(location, " ", "_", "ALL")#"" class='ajaxMain normal' href=""#arguments.webpath#/#Replace(location, " ", "_", "ALL")#"">#label#</a>">
	      </cfif>

	      <cfif matches.pos[x] gt 1>
	        <cfset arguments.string = left(arguments.string, matches.pos[x]-1) & newString &
	          mid(arguments.string, matches.pos[x]+matches.len[x], len(arguments.string))>
	      <cfelse>
	        <cfset arguments.string = newString &
	          mid(arguments.string, matches.pos[x]+matches.len[x], len(arguments.string))>
	      </cfif>

	    </cfloop>
	  </cfif>

	  <cfreturn arguments.string>
	</cffunction>

	<cffunction name="render_wikiterms" output="true" returnType="string" priority="3" hint="WikiTerms are shortcuts for links to internal pages. Any word which begins with one capital letter - is followed by one or more lower case letters - followed by one more capital - and then one or more letters of any case - will be considered a WikiTerm.">
	  <cfargument name="string" type="string" required="true"> 
	  <cfargument name="webpath" type="string" required="true">
	  <cfset var urlRegex = "<a href=.*?>.*?</a>">
	  <cfset var codeRegex = "<div class=""code"">.*?</div>">
	  <cfset var regex = "\b([A-Z][a-z]+[A-Z][A-Za-z]+)\b">
	  <cfset var matches = "">
	  <cfset var urlMatches = "">
	  <cfset var codeMatches = "">
	  <cfset var i = "">
	  <cfset var match = "">
	  <cfset var matchPos = "">
	  <cfset var x = "">
	  <cfset var badMatch = "">
	  <cfset var newString = "">
	  <cfset matches = reFindAll(regex,arguments.string)>
	  <cfset urlMatches = reFindAll(urlRegex,arguments.string)>
	  <cfset codeMatches = reFindAll(codeRegex,arguments.string)>
	  <cfif matches.pos[1] gt 0>
	    <cfloop index="i" from="#arrayLen(matches.pos)#" to="1" step="-1">
	      <cfset match = mid(arguments.string, matches.pos[i], matches.len[i])>
	      <cfset matchPos = matches.pos[i]>
	      <cfset badMatch = false>
	      <cfloop index="x" from="1" to="#arrayLen(urlMatches.pos)#">
	        <cfif urlMatches.pos[x] lt matchPos and (urlMatches.pos[x]+urlMatches.len[x] gt matchPos)>
	          <cfset badMatch = true>
	          <cfbreak>
	        </cfif>
	      </cfloop>
	      <cfif not badMatch>
	        <cfloop index="x" from="1" to="#arrayLen(codeMatches.pos)#">
	          <cfif codeMatches.pos[x] lt matchPos and (codeMatches.pos[x]+codeMatches.len[x] gt matchPos)>
	            <cfset badMatch = true>
	            <cfbreak>
	          </cfif>
	        </cfloop>
	      </cfif>
	      <cfif not badMatch>
	        <cfset newString = "<a rel=""#arguments.webpath#/#match#"" class='ajax' href=""#arguments.webpath#/#match#.html"">#match#</a>">
	        <cfif matches.pos[i] gt 1>
	          <cfset arguments.string = left(arguments.string, matches.pos[i] - 1) & newString &
	            mid(arguments.string, matches.pos[i]+matches.len[i], len(arguments.string))>
	        <cfelse>
	          <cfset arguments.string = newString &
	            mid(arguments.string, matches.pos[i]+matches.len[i], len(arguments.string))>
	        </cfif>
	      </cfif>
	    </cfloop>
	  </cfif>
	  <cfreturn arguments.string>
	</cffunction>


  <!---
 Returns all the matches of a regular expression within a string.

 @param regex      Regular expression. (Required)
 @param text      String to search. (Required)
 @return Returns a structure.
 @author Ben Forta (ben@forta.com)
 @version 1, July 15, 2005
--->
<cffunction name="reFindAll" output="true" returnType="struct">
   <cfargument name="regex" type="string" required="yes">
   <cfargument name="text" type="string" required="yes">

   <!--- Define local variables --->
   <cfset var results=structNew()>
   <cfset var pos=1>
   <cfset var subex="">
   <cfset var done=false>

   <!--- Initialize results structure --->
   <cfset results.len=arraynew(1)>
   <cfset results.pos=arraynew(1)>

   <!--- Loop through text --->
   <cfloop condition="not done">

      <!--- Perform search --->
      <cfset subex=reFind(arguments.regex, arguments.text, pos, true)>
      <!--- Anything matched? --->
      <cfif subex.len[1] is 0>
         <!--- Nothing found, outta here --->
         <cfset done=true>
      <cfelse>
         <!--- Got one, add to arrays --->
         <cfset arrayappend(results.len, subex.len[1])>
         <cfset arrayappend(results.pos, subex.pos[1])>
         <!--- Reposition start point --->
         <cfset pos=subex.pos[1]+subex.len[1]>
      </cfif>
   </cfloop>

   <!--- If no matches, add 0 to both arrays --->
   <cfif arraylen(results.len) is 0>
      <cfset arrayappend(results.len, 0)>
      <cfset arrayappend(results.pos, 0)>
   </cfif>

   <!--- and return results --->
   <cfreturn results>
</cffunction>

  <cffunction name="search" returntype="Any">
    <cfargument name="query">
    <cfargument name="site" default="buildingVine">
     <cfset var ticket = request.user_ticket>
    <cfhttp port="8080" method="post" url="http://46.51.188.170/alfresco/service/bvine/search/wiki.json?alf_ticket=#ticket#" result="wikiSearch">
      <cfhttpparam type="formfield" name="query" value="#arguments.query#">
      <cfhttpparam type="formfield" name="site" value="#arguments.site#">
    </cfhttp>
    <cfreturn DeSerializejson(wikiSearch.fileContent)>
  </cffunction>

</cfcomponent>