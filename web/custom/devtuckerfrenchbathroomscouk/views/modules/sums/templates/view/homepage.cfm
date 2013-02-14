<cfoutput>#getMyPlugin(plugin="jQuery").getDepends("","sites/2/homepage","jQuery/sr/default",false)#</cfoutput>
<cfset features = rc.templateModel.getFeatures()>
<cfset downloads = rc.templateModel.getDownloads()>
<cfoutput>
<div class="hidden-phone" id="homeHeader">
  <div id="myCarousel" class="bannercontainer">
    <div class="banner">
      <ul>
      <cfloop from="1" to="#ArrayLen(features)#" index="i">
       <cfset feature = features[i]>
         <li style="width:100%; background: ##005AAB" data-transition="boxslide" data-slotamount="7" data-link="/html/#feature.page.attributes.name#">
           <div class="pull-right" style="width:750px; text-align: right">#HtmlUnEditFormat(feature.page.attributes.customProperties.feature_image)#</div>           
           <div class="caption overlay fade"  data-x="0" data-y="-90" data-speed="0" data-start="0" data-easing="easeOutBack">
              #HtmlUnEditFormat(feature.page.attributes.customProperties.content)#
           </div>
           <div class="caption randomrotate butt" data-x="-90" data-y="150" data-speed="500" data-start="1500" data-easing="easeOutBack"><a href="/html/#feature.page.attributes.name#" class="btn btn-inverse"><i class="icon-white-arrow"></i> more information</a></div>
         </li>
       </cfloop>
      </ul>
    </div>
  </div>

</div>


  <div id="hometext">
    <div class="row-fluid">
      <div class="span6" name="content" #isE()# >
        #HtmlUnEditFormat(rc.requestData.page.attributes.customProperties.content)#
      </div>
      <div class="span6" name="logos" #isE()#>
        #HtmlUnEditFormat(paramValue("rc.requestData.page.attributes.customProperties.logos",""))#
      </div>
    </div>
  </div>
<div class="row" id="downloads">
  <cfset z = 1>
  <cfloop array="#downloads#" index="folder">
    <div class="span3">
      <div class="downloaddiv">
        <div class="topcurve"></div>
        <div class="bottomcurve"></div>
        <div class="content">
          <cfset documents = rc.templateModel.getDownloads(folder.attr.id)>
          <cfloop array="#documents#" index="d">
            <cfif d.data.icon eq "jpg">
              <img src="http://www.buildingvine.com/api/i?nodeRef=#ListLast(d.attr.id,"/")#" />
            </cfif>
          </cfloop>

        </div>
        <div class="overlay colour_#z#">
          <div class="overlayinner">
            <h3>#folder.data.title#</h3>
            <cfloop array="#documents#" index="d">
              <cfif d.data.icon eq "pdf">
                <a href="https://www.buildingvine.com/alfresco#d.data.attr.downloadURL#?guest=true" target="_blank" class="btn btn-mini" style="margin-bottom: 5px;"><i class="icon-document-pdf"></i> #ListFirst(d.data.title,".")#</a>
              </cfif>
            </cfloop>
          </div>
        </div>
      </div>

    </div>
    <cfset z++>
  </cfloop>
</div>
</cfoutput>
