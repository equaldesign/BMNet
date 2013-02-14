
<cftry>
  <div class="wht">
    <div class="row-fluid">
      <cfoutput><div class="span8" name="content" #isE()#>#HtmlUnEditFormat(paramValue("rc.requestData.page.attributes.customProperties.content","Content"))#</div></cfoutput>
      <cfoutput>
      <div class="span4">
        <div class="row-fluid max-buttons">
          <div class="span6">
            <a href="/signup" class="btn btn-large btn-success"><strong>FREE TRIAL</strong></a>
          </div>
          <div class="span6">
            <a href="/contact" class="btn btn-large btn-warning"><strong>MORE INFO</strong></a>
          </div>
        </div>
        <div name="images" #isE()#>#HtmlUnEditFormat(paramValue("rc.requestData.page.attributes.customProperties.images","Content"))#</div>
      </div></cfoutput>
    </div>
  </div>
<cfcatch type="any"></cfcatch>
</cftry>
