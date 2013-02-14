
<cfset bgImage = "/includes/images/sites/14/homebg.jpg">
<cfoutput>

  <cfif event.getCurrentEvent() eq "bv:documents.detail">
    <input type="hidden" id="folderNodeRef" value="#rc.document.parent#">
    <input id="nodeRef" type="hidden" name="nodeRef" value="#rc.document.docNodeRef#" />
    <cfset tree =  ReplaceNoCase(rc.document.path,"/Company Home","","ALL")>
    <cfset cFolder =  rc.document.properties.title>
    <cfif cFolder eq "">
      <!--- this is a document, and doesn't have a title --->
      <cfset cFolder =  Replace(rc.document.properties.name,"documentLibrary","Documents")>
    </cfif>
    <cfset treeArray = ListToArray(tree,"/")>  
    <cfset bgImage = "http://dev.buildingvine.com/api/i?nodeRef=#rc.document.properties.guid#&size=1500">
  <cfelse>
    <input type="hidden" id="folderNodeRef" value="#rc.documents.parent#">
    <input id="nodeRef" type="hidden" name="nodeRef" value="#rc.documents.parent#" />
    <cfset tree =  ReplaceNoCase(rc.documents.path,"/Company Home","","ALL")>
    <cfset cFolder =  ReplaceNoCase(rc.documents.cFolder,"/Company Home","Documents","ALL")>
    <cfset cFolder =  ReplaceNoCase(cFolder,"documentLibrary","Documents","ALL")>
    <cfset treeArray = ListToArray(tree,"/")>
  </cfif>
  
  <cfset link = "">  


  
<div class="mainBG"> 
  <div class="documents">   
    <div class="breadcrumb">
      <div class="container">
        <cfoutput>
        <div>
          <form class="pull-right form-horizontal" method="get" action="/bv/search/documents?siteID=#request.siteID#&layout=#rc.layout#&maxrows=#rc.maxrows#">
            <div class="input-append">
              <input class="input-xlarge" placeholder="Document Search..." type="text" name="query" id="furtherSearchBox">
              <input type="button" class="btn" value="Search" />
            </div>
          </form> 
          <ul class="breadcrumb">
            <cfif treeArray[1] eq "Sites">
            <cfset startCounter = 3>
            <cfelse>
            <cfset startCounter = 2>
            </cfif>

            <cfset counter = 1>
            <cfloop array="#treeArray#" index="i">
              <cfif counter lt startCounter>
                <cfset link = "#link#/#i#">
              <cfelse>
                <cfset link = "#link#/#i#">
                 <li><a href="#bl("documents.index","layout=#rc.layout#&maxrows=#rc.maxrows#&v=Documents&bc=#link#&siteID=#request.bvsiteID#")#">#ReplaceNoCase(i,"documentLibrary","Documents","ALL")#</a><span class="divider">/</span></li>
              </cfif>
              <cfset counter = counter +1 >
            </cfloop>
            <li class="active">#cFolder#</li>
          </ul>      
        </div> 
        </cfoutput>     
      </div>
    </div>
    <div class="container">    
      <cfoutput>#renderView()#</cfoutput>          
    </div>
  </div>
</div>
</cfoutput>