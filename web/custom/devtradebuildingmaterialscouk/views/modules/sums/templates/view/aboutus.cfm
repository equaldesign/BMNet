<div id="mainpLinks">
  <div id="homecontainer">
    <div id="showcase" style="position: relative; overflow-x: hidden; overflow-y: hidden; ">
    <cfoutput>
      <img border="0" width="698" height="291" name="" src="#rc.requestData.page.attributes.customProperties.top_image#" alt="" title="">
    </cfoutput>
    </div>
    <div id="homelinks">
    <cfoutput>
    #HtmlUnEditFormat(rc.requestData.page.attributes.customProperties.content)#
    </cfoutput>
    </div>
  </div>
  <div class="clearer"></div>
</div>
<div class="homepage homelinks">
  <cfoutput>#renderView(rc.linkPath)#</cfoutput>
  <div id="rightPanelAdvert">
    <cfoutput>#renderView("viewlets/sites/1/linksAd")#</cfoutput>
  </div>
</div>