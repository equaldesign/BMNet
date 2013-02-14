<div id="mainpLinks">
  <div id="homecontainer">
    <div id="showcase" style="position: relative; overflow-x: hidden; overflow-y: hidden; ">
    <cfoutput>
      <img border="0" width="698" height="291" name="" src="#paramValue("rc.requestData.page.attributes.customProperties.top_image","")#" alt="" title="">
    </cfoutput>
    </div>
    <cfoutput>
    <div name="content" #isE()#>
    #HtmlUnEditFormat(paramValue("rc.requestData.page.attributes.customProperties.content","Content"))#
    </div>
    </cfoutput>

  </div>
  <div class="clearer"></div>
</div>
