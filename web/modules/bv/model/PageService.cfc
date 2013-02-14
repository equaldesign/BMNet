<cfcomponent name="PageService" accessors="true"  output="true" cache="true" cacheTimeout="0" autowire="true">
<!--- Dependencies --->

  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" />
  


  <cfset instance = structnew()>


  <cffunction name="proxy" returntype="any" output="false">
    <cfargument name="proxyurl" required="true">
    <cfargument name="method" required="true">
    <cfargument name="JSONRequest" required="true">
    <cfargument name="siteID" required="true">
    <cfargument name="alf_ticket" required="true">
    <cfargument name="jsonData">
    <cfargument name="formCollection">
    <cfset var returnStruct = {}>

    <cfif JSONRequest>
      <cfhttp port="8080" url="http://46.51.188.170/alfresco/service/#arguments.proxyurl#" method="#arguments.method#" result="requestResult">
        <cfhttpparam type="header" name="content-type" value="application/json">
        <cfhttpparam type="body" name="json" value="#arguments.jsonData#">
      </cfhttp>
    <cfelse>
      <cfhttp port="8080" url="http://46.51.188.170/alfresco/service/#arguments.proxyurl#" method="#arguments.method#" result="requestResult">
        <cfif arguments.method eq "post">
        <cfloop collection="#arguments.formCollection#" item="formItem">
          <cfhttpparam type="formfield" name="#formItem#" value="#arguments.formCollection[formItem]#">
        </cfloop>
        </cfif>
      </cfhttp>
    </cfif>
    <cfset returnStruct = DeserializeJSON(requestResult.fileContent)>
    <cfif requestResult.statusCode neq "200 OK">
        <cfset returnStruct["haserror"] = true>
    </cfif>
    <cfif isDefined("returnStruct.page.url")>
      <cfhttp port="8080" url="http://46.51.188.170/alfresco#returnStruct.page.url#?ticket=#arguments.alf_ticket#" method="get" result="contentResult"></cfhttp>
      <cfset returnStruct["htmlContent"] = contentResult.fileContent>
    </cfif>
    <cfreturn returnStruct>
  </cffunction>


  <!--- PRIVATE FUNCTIONS --->

  <cffunction access="private" name="render_links" output="false" returnType="string" hint="Links are rendered using [[url]] or [[url|label]] format. URLs can either be external, fully qualified URLs, or internal URLs in the form of FOO.MOO, where MOO Is a child of FOO.">
    <cfargument name="string" type="string" required="true">
    <cfargument name="webpath" type="string" required="true">
    <cfargument name="parentID" required="true">

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
          <cfset newString = "<a rel=""#location#"" class='ajaxMain normal' href=""#location#?parentID=#parentID###wiki"">#label#</a>">
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
          <cfset newString = "<a rel=""#arguments.webpath#/#Replace(location, " ", "_", "ALL")#"" class='ajaxMain normal' href=""#arguments.webpath#/#Replace(location, " ", "_", "ALL")#?parentID=#parentID###wiki"">#label#</a>">
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

  <cffunction access="private" name="render_wikiterms" output="true" returnType="string" priority="3" hint="WikiTerms are shortcuts for links to internal pages. Any word which begins with one capital letter - is followed by one or more lower case letters - followed by one more capital - and then one or more letters of any case - will be considered a WikiTerm.">
    <cfargument name="string" type="string" required="true">
    <cfargument name="webpath" type="string" required="true">
    <cfargument name="parentID" type="any" required="true">
    <cfset var urlRegex = "<a href=.*?>.*?</a>">
    <cfset var codeRegex = "<div class=""code"">.*?</div>">
    <!--- regex by Sean Corfield --->
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
    <!---
      Logic is:
      Loop through our WT matches. Check to see it is not inside a link match.
     --->
    <cfif matches.pos[1] gt 0>
      <cfloop index="i" from="#arrayLen(matches.pos)#" to="1" step="-1">
        <cfset match = mid(arguments.string, matches.pos[i], matches.len[i])>
        <!---<cflog file="canvas" text="#match#">--->
        <cfset matchPos = matches.pos[i]>
        <!--- so we got our match pos, loop through URL matches --->
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

          <cfset newString = "<a rel=""#arguments.webpath#/#match#"" class='ajaxMain normal' href=""#arguments.webpath#/#match#?parentID=#parentID###wiki"">#match#</a>">

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

    <!---
    Removed since it conflicted with url matches
    <cfreturn reReplace(arguments.string, regex, "<a href=""#arguments.webpath#/index.cfm/\1"">\1</a>","all")>
    --->
  </cffunction>

  <cffunction name="GetHeaderLink" access="private" returntype="string" output="false" description="Removes the html from the header and replaces all non-alphanumeric characters with underscores. Used in Table of Contents generation.">
    <cfargument name="header" type="string" required="true" />
    <cfset var link="">
    <!--- remove html tags from the header text for the link --->
    <cfset link=reReplaceNoCase(arguments.header, "<[^>]*>", "", "ALL")>
    <!--- change non-alphanumeric characters to an underscore for the link --->
    <cfset link=reReplaceNoCase(link, "\W", "_", "ALL")>
    <cfreturn link>
  </cffunction>

  <cffunction name="JREReplace" access="private" returntype="string" output="false"
    hint="This performs Java REReplaces on a string.">
    <!--- Define arguments. --->
    <cfargument name="Text" type="string" required="true" />
    <cfargument name="Pattern" type="any" required="true" /><!--- pass in a regex string or a compiled pattern object to save time on repetitious patterns --->
    <cfargument name="Target" type="any" required="true" />
    <cfargument name="Scope" type="string" required="false" default="ONE" />
    <cfscript>
      // Define the local scope.
      var LOCAL = StructNew();
      // Check to see if we are using a string replace or a method
      // helper replace.
      if (IsSimpleValue( ARGUMENTS.Target )){
        // We are doing a standard string replace, so just
        // use Java's string replacement. Check the scope.
        if (NOT Compare( ARGUMENTS.Scope, "ALL" )){
          // Replace all.
          return(
            CreateObject( "java", "java.lang.String" ).Init(
              ARGUMENTS.Text
              ).ReplaceAll(
                ARGUMENTS.Pattern, ARGUMENTS.Target
                )
            );
        } else {
          // Replace one.
          return(
            CreateObject( "java", "java.lang.String" ).Init(
              ARGUMENTS.Text
              ).ReplaceFirst(
                ARGUMENTS.Pattern,
                ARGUMENTS.Target
                )
            );
        }
      } else {
        // We are using a function here to replace out the
        // groups. That means that matches have to be
        // evaluated and replaced on an individual basis.
        // Create the java pattern complied to the given regular
        // expression.
        if (IsSimpleValue(ARGUMENTS.Pattern)) {
          LOCAL.Pattern = CreateObject(
            "java",
            "java.util.regex.Pattern"
            ).Compile(
              ARGUMENTS.Pattern
            );
        } else {
          // used the passed in Pattern object
          LOCAL.Pattern=ARGUMENTS.Pattern;
        }
        // Create the java matcher based on the given text using the
        // compiled regular expression.
        LOCAL.Matcher = LOCAL.Pattern.Matcher( ARGUMENTS.Text );
        // Create a string buffer to hold the results.
        LOCAL.Results = CreateObject(
          "java",
          "java.lang.StringBuffer"
          ).Init();
        // Loop over the matcher while we still have matches.
        while ( LOCAL.Matcher.Find() ){
          // We are going to build an array of matches.
          LOCAL.Groups = ArrayNew( 1 );
          for (
            LOCAL.GroupIndex = 1 ;
            LOCAL.GroupIndex LTE LOCAL.Matcher.GroupCount() ;
            LOCAL.GroupIndex = (LOCAL.GroupIndex + 1)
            ){
            // Add the current group to the array of groups.
            ArrayAppend(
              LOCAL.Groups,
              LOCAL.Matcher.Group( JavaCast( "int", LOCAL.GroupIndex ) )
              );
          }
          // Replace the current match. Be sure to get the value by
          // using the helper function.
          LOCAL.Matcher.AppendReplacement(
            LOCAL.Results,

            // Call the target function pointer using function notation.
            ARGUMENTS.Target(
              LOCAL.Matcher.Group(),
              LOCAL.Groups
              )
            );
          // Check to see if we need to break out of this.
          if (NOT Compare( ARGUMENTS.Scope, "ONE" )){
            break;
          }
        }
        // Add what ever is left of the text.
        LOCAL.Matcher.AppendTail( LOCAL.Results );
        // Return the string buffer.
        return( LOCAL.Results.ToString() );
      }
    </cfscript>
  </cffunction>

  <cffunction name="WikiHeaderRegexHelper" access="private" returntype="string" output="false"
    hint="Evaluates the matches in a JREReplace and returns a value.">
    <cfargument name="Match" type="string" required="true" />
    <cfargument name="Groups" type="array" required="false" default="#ArrayNew( 1 )#" />
    <cfset var header="">
    <cfset var link="">
    <cfset var hNum=0>
    <cfset var retStr=arguments.Match>
    <!---
    The arguments.Groups should match like this:
    1 - the beginning equals signs
    2 - the part between the equals signs
    3 - the ending equals signs
    --->
    <!--- if we don't have 3 matches in the group, the just return the match untouched --->
    <cfif ArrayLen(arguments.Groups) NEQ 3>
      <cfreturn retStr>
    </cfif>
    <!--- process our header match --->
    <cfset hNum=len(trim(arguments.Groups[1]))>
    <cfset header=trim(arguments.Groups[2])>
    <cfset link=GetHeaderLink(header)>
    <!--- add <h?> tags, anchor link and modified header to the return string --->
    <cfset retStr="<h#hNum#><a name=""#link#""></a>#header#</h#hNum#>">
    <cfreturn retStr>
  </cffunction>

  <cffunction access="private" name="reFindAll" output="false" returnType="struct">
     <cfargument name="regex" type="string" required="true">
     <cfargument name="text" type="string" required="true">

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


</cfcomponent>