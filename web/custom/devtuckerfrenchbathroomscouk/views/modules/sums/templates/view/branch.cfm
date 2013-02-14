<cfhtmlhead text='<title>BuildersMerchant.net - #paramValue("rc.requestData.page.title","100s of Builders Merchants and Building Supplies online and under one roof")#</title>'>
<div id="hometextother">
<cftry>
  <div class="row-fluid">
    <cfoutput>
    <div class="span4">
      <!--- map --->
      <img class="thumnail"
        src="http://maps.googleapis.com/maps/api/staticmap?center=#StripHTML(HtmlUnEditFormat(paramValue("rc.requestData.page.attributes.customProperties.branch_postcode","branch postcode")))#&zoom=13&size=450x450&markers=color:green%7C#StripHTML(HtmlUnEditFormat(paramValue("rc.requestData.page.attributes.customProperties.branch_postcode","branch postcode")))#&sensor=false" />
    </div>
    <div class="span8">
      <div name="branchName" #isE()#>#HtmlUnEditFormat(paramValue("rc.requestData.page.attributes.customProperties.branchName","Branch Name"))#</div>
      <address><div name="branch_address" #isE()#>#HtmlUnEditFormat(paramValue("rc.requestData.page.attributes.customProperties.branch_address","branch address"))#</div></address>
      <div name="branch_postcode" #isE()#>#HtmlUnEditFormat(paramValue("rc.requestData.page.attributes.customProperties.branch_postcode","branch postcode"))#</div>
      <div><i class="icon-calendar"></i><div name="branch_opening_hours" #isE()#>#HtmlUnEditFormat(paramValue("rc.requestData.page.attributes.customProperties.branch_opening_hours","branch opening hours"))#</div></div>
      <ul class="branchDetail">
        <li><i class="icon-telephone"></i><span name="branch_tel" #isE()#>#HtmlUnEditFormat(paramValue("rc.requestData.page.attributes.customProperties.branch_tel","branch tel"))#</span></li>
        <li><i class="icon-email"></i><span name="branch_email" #isE()#>#HtmlUnEditFormat(paramValue("rc.requestData.page.attributes.customProperties.branch_email","branch email"))#</span></li>
      </ul>
      <div name="branch_extra" #isE()#>#HtmlUnEditFormat(paramValue("rc.requestData.page.attributes.customProperties.branch_extra","branch other"))#</div>
    </div>
  </div>
  </cfoutput>
<cfcatch type="any"></cfcatch>
</cftry>
</div>