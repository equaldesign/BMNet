<cfhtmlhead text='<title>BuildersMerchant.net - #paramValue("rc.requestData.page.title","100s of Builders Merchants and Building Supplies online and under one roof")#</title>'>
<header class="jumbotron subhead" id="overview">
  <cfoutput>
  <div class="container">
    <h1>#paramValue('rc.requestData.page.attributes.customproperties.pagetitle','')#</h1>
    <p>#paramValue('rc.requestData.page.attributes.customproperties.description','')#</p>
  </div>
  </cfoutput>
</header>
<div class="container" id="homepage">
  <div class="row">
    <cfif paramValue("rc.requestData.page.showLinks",false) AND ArrayLen(paramValue("rc.requestData.page.links",[]))>
      <div class="span3">
        <cfoutput>#renderView(view="templates/links",module="sums")#</cfoutput>
      </div>
      <div class="span9">
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
        <cftry>
          <cfoutput>
          <div class="wht">
            <div class="row-fluid" #isE()# name="content">
              #HtmlUnEditFormat(paramValue("rc.requestData.page.attributes.customProperties.content","Content"))#
            </div>
          </div>
          </cfoutput>
        <cfcatch type="any"></cfcatch>
        </cftry>
      </div>
    <cfelse>
    <div class="span12">
      <cftry>
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
        <cfoutput>
        <div class="wht">
          <div class="row-fluid" #isE()# name="content">
            #HtmlUnEditFormat(paramValue("rc.requestData.page.attributes.customProperties.content","Content"))#
          </div>
        </div>
        </cfoutput>
      <cfcatch type="any"></cfcatch>
      </cftry>
    </div>
    </cfif>
  </div>
</div>


</div>


