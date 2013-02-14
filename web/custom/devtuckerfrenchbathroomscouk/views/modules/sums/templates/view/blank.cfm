<cfhtmlhead text='<title>BuildersMerchant.net - #paramValue("rc.requestData.page.title","100s of Builders Merchants and Building Supplies online and under one roof")#</title>'>
<div id="hometextother">
<cftry>
  <cfoutput><div name="content" #isE()#>#HtmlUnEditFormat(paramValue("rc.requestData.page.attributes.customProperties.content","Content"))#</div></cfoutput>
<cfcatch type="any"></cfcatch>
</cftry>
</div>
