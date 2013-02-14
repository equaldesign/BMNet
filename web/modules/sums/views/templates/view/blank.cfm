
<cftry>
  <div class="wht">
    <div class="row-fluid">
      <cfoutput><div class="span8" name="content" #isE()#>#HtmlUnEditFormat(paramValue("rc.requestData.page.attributes.customProperties.content","Content"))#</div></cfoutput>
      <cfoutput><div class="span4" name="images" #isE()#>#HtmlUnEditFormat(paramValue("rc.requestData.page.attributes.customProperties.images","Content"))#</div></cfoutput>
    </div>
  </div>
<cfcatch type="any"></cfcatch>
</cftry>
