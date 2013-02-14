<cfhtmlhead text='<title>BuildersMerchant.net - #paramValue("rc.requestData.page.title","100s of Builders Merchants and Building Supplies online and under one roof")#</title>'></cfhtmlhead>
<cftry>
  <div class="wht">
    <div class="row-fluid">
      <cfoutput><div class="span12" name="content" #isE()#>#HtmlUnEditFormat(paramValue("rc.requestData.page.attributes.customProperties.content","Content"))#</div></cfoutput>
    </div>
  </div>
<cfcatch type="any"></cfcatch>
</cftry>
