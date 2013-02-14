<cfoutput>
<cfif isDefined("rc.requestData.page.parents") AND paramValue("rc.requestData.page.name","") neq "homepage.html" AND NOT paramValue("rc.requestData.page.template","") eq "bvproductlist">
<ul class="breadcrumb">
  <cfloop from="#arrayLen(rc.requestData.page.parents)#" to="1" index="i" step="-1">
  <li><a href="/html/#rc.requestData.page.parents[i].name#">#rc.requestData.page.parents[i].title#</a> <span class="divider">/</span></li>
  </cfloop>
  <li class="active">#rc.requestData.page.title#</li>
</ul>
</cfif>
</cfoutput>
<div id="mainpLinks">
  <div id="homecontainer">
    <cfoutput>
    <div name="top_image" #isE()# class="thumbnail">

      #HtmlUnEditFormat(rc.requestData.page.attributes.customProperties.top_image)#
    </div>

    <div name="content" #isE()# id="homelinks">

    #HtmlUnEditFormat(rc.requestData.page.attributes.customProperties.content)#
    </div>
    </cfoutput>
  </div>
  <div class="clearer"></div>
</div>
