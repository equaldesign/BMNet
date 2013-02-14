<cfoutput>#getMyPlugin(plugin="jQuery").getDepends("","sites/1/homepage","")#</cfoutput>
<cfoutput>
  <div class="hidden-phone" id="showcase" style="position: relative; overflow-x: hidden; overflow-y: hidden; ">
    <cfif isDefined("rc.landingImages.items") AND isArray(rc.landingImages.items)>
      <cfloop array="#rc.landingImages.items#" index="limage">
      <a class="hlink" href="#bsl('/mxtra/shop/category/#ListFirst(limage.location.file,".")#')#">
        <img border="0" width="100%" height="291" name="" src="https://www.buildingvine.com/api/productImage?nodeRef=#ListLast(limage.nodeRef,"/")#&amp;size=698" alt="" title="">
      </a>
      </cfloop>
    </cfif>
  <div id="showcasenav"></div>
</div>
  <h2>#rc.landingData.landing[1].customProperties.metaTitle#</h2>
  <p>#HtmlUnEditFormat(rc.landingData.landing[1].customProperties.content)#</p>
</cfoutput>

<cfset prc.requestData.page.attributes.customProperties.description = rc.landingData.landing[1].customProperties.description>
<cfset prc.requestData.page.attributes.customProperties.keywords = rc.landingData.landing[1].customProperties.keywords>
