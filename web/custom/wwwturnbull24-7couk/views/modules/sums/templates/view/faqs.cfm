<cfset rc.toplinkData = getModel("PageService").proxy(
  proxyurl="sums/page/energy-saving--generating-your-own-energy?alf_ticket=#request.buildingVine.guest_ticket#&siteID=#rc.siteID#",
  formCollection=form,
  method="get",
  JSONRequest="false",
  siteID = rc.siteID,
  jsonData = getHttpRequestData().content,
  alf_ticket=request.buildingVine.guest_ticket
)>

<div class="navbar">
  <div class="navbar-inner">
    <div class="container">
      <a class="brand" href="/html/energy-saving--generating-your-own-energy.html"><i style="margin-top:4px;" class="icon-light-bulb"></i> Energy Saving</a>
      <div class="nav-collapse collapse navbar-responsive-collapse">
        <ul class="nav">      
          <cfoutput>
          <cfloop array="#rc.topLinkData.page.links#" index="tl">
          <li class="dropdown">
            <a href="##" class="dropdown-toggle" data-toggle="dropdown">#tl.name# <b class="caret"></b></a>
            <cfset tlinkData = getModel("PageService").proxy(
              proxyurl="sums/page/#ListFirst(ListLast(tl.linkURL,"/"),".")#?alf_ticket=#request.buildingVine.guest_ticket#&siteID=#rc.siteID#",
              formCollection=form,
              method="get",
              JSONRequest="false",
              siteID = rc.siteID,
              jsonData = getHttpRequestData().content,
              alf_ticket=request.buildingVine.guest_ticket
            )>
            <ul class="dropdown-menu">
              <cfloop array="#tlinkData.page.links#" index="sl">
                <li><a href="#sl.linkURL#">#sl.name#</a></li>  
              </cfloop>              
            </ul>
          </li>
          </cfloop> 
          </cfoutput>                     
        </ul>        
      </div><!-- /.nav-collapse -->
    </div>
  </div><!-- /navbar-inner -->
</div>
<div id="mainpLinks">
      <!-- fresh get -->
      <cfoutput>
        <h1>#paramValue("rc.requestData.page.title","")#</h1>
        <div  name="content" #isE()# >
        #HtmlUnEditFormat(paramValue("rc.requestData.page.attributes.customProperties.content",""))#
        </div>
      </cfoutput> 
</div>

