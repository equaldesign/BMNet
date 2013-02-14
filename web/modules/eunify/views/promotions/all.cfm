<cfset promotions = getModel("promotions")>
<cfset promos = promotions.getPromotionList()>
<div class="promotions">
  <h2>Current Promotions</h2>
  <span class="viewAll"><a href="/promotions/">view all</a></span>
  <div id="promoNavControls">
    <a title="previous promotion" href="##" class="tooltip cyclePrev"></a><a title="next promotion"  href="##" class="tooltip cycleNext"></a>
	  <div id="promoNav" class="cyclenav">

	  </div>
  </div>
  <div class="promoList">
  <cfoutput query="promos.eGroup" group="categoryID">
    <div class="promotion">
      <h4>
        <a href="/documents/categoryList/id/#categoryID#?v=startList">
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
              <img class="promotion glow" width="220" src="/includes/images/thumbnails/#getSetting('siteName')#/#id#.jpg" />
              </a>
          <cfelse>
            <cfset getModel("dms").createThumbnails(id,filetype)>
          </cfif>
        </cfif>
      </cfoutput>
      </div>
      <div class="promoDetail psa_priceLists">
        <cftry>
        <p class="validity">Valid for #DateDiff("d",now(),categoryValidTo)# more days</p>
        <h5>Accompanying Files</h5>
        <cfoutput>
        <a href="/documents/download/id/#id#" target="_blank"><h4 class="#fileType#">#ListGetAt(name,1,".")#</h4></a>
        </cfoutput>
        <cfcatch type="any"></cfcatch>
        </cftry>
      </div>
    </div>
  </cfoutput>
  </div>
</div>

