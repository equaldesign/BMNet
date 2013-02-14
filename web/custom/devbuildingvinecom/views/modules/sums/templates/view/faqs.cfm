<div class="home faq">
  <div class="container pageheading">    
    <div class="pull-right" id="homebuttons"> 
      <a class="span2 btn btn-large btn-warning" href="/signup">REGISTER NOW</a>
    </div>
    <cfoutput><h1>#paramValue("rc.requestData.page.attributes.customproperties.pagetitle","Feature Tour")#</h1></cfoutput>
  </div> 
</div>
<div class="homerest faq">
<cfoutput>
<cfif isDefined("rc.requestData.page.parents") AND paramValue("rc.requestData.page.name","") neq "homepage.html" AND NOT paramValue("rc.requestData.page.template","") eq "homepage" AND NOT paramValue("rc.requestData.page.template","") eq "bvproductlist">
<div class="breadcrumb"><div class="container"><ul class="breadcrumb">
  <cfloop from="#arrayLen(rc.requestData.page.parents)#" to="1" index="i" step="-1">
  <li><a href="/html/#rc.requestData.page.parents[i].name#">#rc.requestData.page.parents[i].title#</a> <span class="divider">/</span></li>
  </cfloop>
  <li class="active">#rc.requestData.page.title#</li>
</ul>
</div>
</div>
</cfif>
</cfoutput>
<cftry>  
  <div class="container">
    <div class="row-fluid">
      <div class="span4">
        <cfoutput>#createLinks(rc.linkData)#</cfoutput>
      </div>
      <cfoutput>
        <div class="span8" name="content" #isE()#>
          #HtmlUnEditFormat(paramValue("rc.requestData.page.attributes.customProperties.content","Content"))#
        </div>
      </cfoutput>    
    </div>
  </div>
<cfcatch type="any"></cfcatch> 
</cftry>
 </div>