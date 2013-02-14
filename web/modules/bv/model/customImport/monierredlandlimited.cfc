<cfcomponent>
  <cffunction name="runIt" returntype="any">
    <cfargument name="productSpreadsheet">
    <cfargument name="currentRow">
    <cfargument name="product">
    <cfargument name="rc">
    <cfargument name="ticket">
    <cftry>
    <cfset var thisURL = '#arguments.productSpreadsheet["Web URL"][arguments.currentRow]#'>
    <cfhttp useragent="Mozilla/5.0 (X11; U; Linux i686; en-US) AppleWebKit/533.7 (KHTML, like Gecko) Chrome/5.0.391.0 Safari/533.7" url="http://www.w3.org/services/tidy?indent=on&forceXML=on&docAddr=#thisURL#" result="urlData"></cfhttp>
    <cfset var xmlData = xmlParse(urlData.fileContent)>

    <cfset technicalLink = xmlData.html.body.div.xmlChildren[2].xmlChildren[3].div.div.ul.xmlChildren[2].a.xmlAttributes.href>
    <cfset downloadLink = xmlData.html.body.div.xmlChildren[2].xmlChildren[3].div.div.ul.xmlChildren[4].a.xmlAttributes.href>
    <cfhttp url="http://www.w3.org/services/tidy?indent=on&forceXML=on&docAddr=http://www.monier.co.uk/#technicalLink#" result="techData"></cfhttp>
    <cfset var techDataXML = xmlParse(techData.fileContent)>
    <cfset var table = techDataXML.html.body.div.xmlCHildren[2].xmlChildren[3].div.xmlChildren[2].div.div.div.div.table>
    <cfloop array="#table.tbody.xmlChildren#" index="tr">
      <cfset product.customData[tr.xmlChildren[1].xmlText] = tr.xmlCHildren[2].xmlText>
    </cfloop>
    <cfhttp url="http://www.w3.org/services/tidy?indent=on&forceXML=on&docAddr=http://www.monier.co.uk/#downloadLink#" result="dowloadData"></cfhttp>
    <cfset var dowloadData = xmlParse(dowloadData.fileContent)>
    <cfloop array="#dowloadData.html.body.div.xmlCHildren[2].xmlChildren[3].div.xmlChildren[2].div.div.div.div.xmlChildren#" index="divD">
      <cfdump var="#divD.div#">
      <cfhttp port="80" resolveurl="true" getasbinary="auto" url="http://www.monier.co.uk/#divD.div.a.xmlAttributes.href#" result="doc"></cfhttp>
       <cfif doc.statusCode eq "200 OK">
        <cfset localFileName = friendlyUrl(divD.div.h4.xmlText)>
        <cffile action="write" file="/tmp/#localFileName#" output="#doc.fileContent#">
        <cfif listLast(localFileName,".") eq "tmp" OR len(listLast(localFileName,".")) gte 5>
          <cftry>
          <cfset mimExt = getMimeTypeExtension(mimetype=getPageContext().getServletContext().getMimeType("/tmp/#localFileName#"))>
          <cfcatch type="any">
            <cfset mimExt = "pdf">
          </cfcatch>
          </cftry>
          <cffile action="move" source="/tmp/#localFileName#" destination="/tmp/#ListFirst(localFileName,'.')#.#mimExt#">
          <cfset localFileName = "/tmp/#ListFirst(localFileName,'.')#.#mimExt#">
        <cfelse>
          <cffile action="move" source="/tmp/#localFileName#" destination="/tmp/#ListFirst(localFileName,'.')#.#ListLast(localFileName,'.')#">
          <cfset localFileName = "/tmp/#ListFirst(localFileName,'.')#.#ListLast(localFileName,'.')#">
        </cfif>
        <cfhttp port="8080" result="docUp" url="http://46.51.188.170/alfresco/service/bvine/docs/files/upload.json?alf_ticket=#ticket#&niceFolder=Sites/#rc.siteID#/documentLibrary/Product%20Information/Product%20Brochures" method="post">
          <cfhttpparam type="file" name="file" file="#localFileName#">
        </cfhttp>
        <cfset DocRes = DeSerializejson(docUp.fileContent)>
        <cfset ArrayAppend(product["documentNodeRefs"],DocRes.nodeRef)>
      </cfif>
    </cfloop>
    <cfcatch type="any">
      <cflog application="true" text="monier #cfcatch.Message#">
    </cfcatch>
    </cftry>
    <cfreturn product>
  </cffunction>
<cfscript>
function friendlyUrl(title) {
    title = trim(title);
    title = replaceNoCase(title,"&amp;","and","all"); //replace &amp;
    title = replaceNoCase(title,"&","and","all"); //replace &
    title = replaceNoCase(title,"'","","all"); //remove apostrophe
    title = reReplaceNoCase(trim(title),"[^a-zA-Z0-9]","","ALL");
    return lcase(title);
}
</cfscript>
</cfcomponent>