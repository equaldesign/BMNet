<cfhtmlhead text='<title>BuildersMerchant.net - #paramValue("rc.requestData.page.title","100s of Builders Merchants and Building Supplies online and under one roof")#</title>'></cfhtmlhead>
<div class="jumbotron masthead">
  <div class="container">
    <cfoutput>
    <h1>#paramValue('rc.requestData.page.attributes.customproperties.pagetitle','')#</h1>
    <p>#paramValue('rc.requestData.page.attributes.customproperties.description','')#</p>
    </cfoutput>
  </div>
</div>
<div class="bs-docs-social">
  <div class="container">
    <ul class="bs-docs-social-buttons">

    </ul>
  </div>
</div>
<div class="container" id="homepage">
  <div class="row">
   <cfoutput><div class="span12" name="content" #isE()#>#HtmlUnEditFormat(paramValue("rc.requestData.page.attributes.customProperties.content","Content"))#</div></cfoutput>
  </div>
</div>
</div>


</div>


