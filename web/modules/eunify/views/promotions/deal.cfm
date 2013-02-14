<cfset dms = getModel("dms")>
<cfset promotions = dms.getParentCategoryDocuments(rc.promotionsCat,"",true)>
<div id="dealPromoNav" class="cyclenav"></div>
<div class="dealPromoList">
<cfif isDefined("rc.panelData.bvPromotions")>
	
  <cfloop array="#rc.panelData.bvPromotions#" index="bvPromo">
    <cfoutput>
    <div class="promotion">
      <h4>
        <cfset args = {
          imageURL="",
          companyID = getModel("company").getCompanyByBVSiteID(bvPromo.site),
          width = 25,
          class = "gravatar", 
          title = ""
        }>
        #renderView(view="viewlets/companyLogo",args=args,cache=true,cacheSuffix="logo_#args.companyID#_#args.width#_#getSetting('siteName')#",cacheTimeout=0)#
        #bvPromo.name#
        <div class="hidden">
        #paragraphFormat(bvPromo.description)#
        </div>
      </h4>
      <cfif arrayLen(bvPromo.files) gte 1>
				<div class="promoImage">
	        <a href="https://www.buildingvine.com/alfresco#bvPromo.files[1].downloadUrl#?ticket=#getModel('modules.bv.model.UserService').getUserTicket()#">
	          <img class="promotion glow" width="180" src="https://www.buildingvine.com/api/productImage?nodeRef=#bvPromo.files[1].nodeRef#" />
	        </a>
	      </div>
	    </cfif>
      <div class="promoDetail psa_priceLists">
        <p class="validity">Valid for #DateDiff("d",now(),bvPromo.validTo)# more days</p>
        <h5>Accompanying Files</h5>
        <cfloop array="#bvPromo.files#" index="f">
        <a href="https://www.buildingvine.com/alfresco#f.downloadUrl#?ticket=#getModel('modules.bv.model.UserService').getUserTicket()#" target="_blank"><h4 class="">#ListGetAt(f.title,1,".")#</h4></a>
        </cfloop>
      </div>
    </div>
    </cfoutput>
  </cfloop>
</cfif>
<cfoutput query="promotions" group="categoryID">
  <div class="promotion">
    <h4>
      <a href="/documents/categoryList/id/#categoryID#">
      <cfset args = {
          imageURL="",
          companyID = relID,
          width = 25,
          class = "gravatar",
          title = ""
        }>
        #renderView(view="viewlets/companyLogo",args=args,cache=true,cacheSuffix="logo_#args.companyID#_#args.width#_#getSetting('siteName')#",cacheTimeout=0)#
      #categoryName#
      <div class="hidden">
      #paragraphFormat(categoryDescription)#
      </div>
      </a>
    </h4>
    <div class="promoImage">
    <cfoutput>
      <cfif showThumbnail>
        <cfif fileExists("#rc.app.appRoot#dms/documents/thumbnails/#id#.jpg")>
            <a href="/documents/categoryList/id/#categoryID#?v=startList">
            <img class="promotion glow" width="180" src="/includes/images/thumbnails/#getSetting('siteName')#/#id#.jpg" />
            </a>
        <cfelse>
          <cfset getModel("dms").createThumbnails(id,filetype)>
        </cfif>
      </cfif>
    </cfoutput>
    </div>
    <div class="promoDetail psa_priceLists">
      <p class="validity">Valid for #DateDiff("d",now(),categoryValidTo)# more days</p>
      <h5>Accompanying Files</h5>
      <cfoutput>
      <a href="/documents/download/id/#id#" target="_blank"><h4 class="#fileType#">#ListGetAt(name,1,".")#</h4></a>
      </cfoutput>
    </div>
  </div>
</cfoutput>
</div>
