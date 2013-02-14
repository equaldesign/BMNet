<cfset getMyPlugin(plugin="jQuery").getDepends("scroll,localScroll","promotions/fullList","promotions")>
<a name="top"></a>
<div id="fullPromoList">
  <h1>Current Promotions</h1>
  <cfif isDefined("rc.promotions.buildingVine")>
  <div>
  <cfloop array="#rc.promotions.buildingVine#" index="bvPromo">
    <div class="companyPromo">
      <div class="individualPromo">
        <div class="promoThumb">
        <cfoutput>
        <cfif arrayLen(bvPromo.files) gte 1>
        <a href="https://www.buildingvine.com/alfresco#bvPromo.files[1].downloadUrl#?ticket=#getModel('modules.bv.model.UserService').getUserTicket()#">
          <img class="promotion glow" width="75" src="https://www.buildingvine.com/api/productImage?nodeRef=#bvPromo.files[1].nodeRef#&size=small" />
        </a>
        </cfif>
        </div>
        <div class="promoDetail blueBox">
          <h3>#bvPromo.name#</h3>
          <div>#paragraphFormat(bvPromo.description)#</div>
          <p class="validity">Valid for #DateDiff("d",now(),bvPromo.validTo)# more days</p>
          <h5>Accompanying Files</h5>
          <cfloop array="#bvPromo.files#" index="f">
          <a href="https://www.buildingvine.com/alfresco#f.downloadUrl#?ticket=#getModel('modules.bv.model.UserService').getUserTicket()#" target="_blank"><h4 class="">#ListGetAt(f.title,1,".")#</h4></a>
          </cfloop>
        </div>
        </cfoutput>
        <div class="clear"></div>
      </div>
    </div>
  </cfloop>
  </div>
  </cfif>
  <cfoutput query="rc.promotions.eGroup" group="companyID"><a class="noAjax" href="###companyID#"><img width="40" class="gravatar" src="#paramImage('company/#relID#_square.jpg','website/unknown.jpg')#" /></a></cfoutput>
  <div class="clear"></div>
  <div>
  <cfoutput query="rc.promotions.eGroup" group="companyID">
    <a name="#companyID#"></a>
    <div class="companyPromo">
      <a href="##top" class="noAjax bak">Back to Top</a>
      <h2>
        <cfset args = {
          imageURL="",
          companyID = relID,
          width = 25,
          class = "gravatar",
          title = ""
        }>
        #renderView(view="viewlets/companyLogo",args=args,cache=true,cacheSuffix="logo_#args.companyID#_#args.width#_#getSetting('siteName')#",cacheTimeout=0)#
        #companyName#</h2><br />
      <cfoutput group="categoryID">
        <div class="individualPromo">
          <div class="promoThumb">
          <cfoutput>
            <cfif showThumbnail>
              <cfif fileExists("#rc.app.appRoot#dms/documents/thumbnails/#id#_small.jpg")>
                  <a href="/documents/categoryList/id/#categoryID#?v=startList">
                  <img class="promotion glow" width="75" src="/includes/images/thumbnails/#getSetting('siteName')#/#id#_small.jpg" />
                  </a>
              <cfelse>
                <cfset getModel("dms").createThumbnails(id,filetype)>
              </cfif>
            </cfif>
          </cfoutput>
          </div>
          <div class="promoDetail blueBox">
            <h3><a href="/documents/categoryList/id/#categoryID#?v=startList">#categoryName#</a></h3>
            <a href="##" rev="desc_#categoryID#" class="show noAjax">show/hide detail</a>
            <div class="hidden" id="desc_#categoryID#">#paragraphFormat(categoryDescription)#</div>
            <cftry>
        <p class="validity">Valid for #DateDiff("d",now(),categoryValidTo)# more days</p>
        <h5>Accompanying Files</h5>
        <cfoutput>
        <a href="/documents/download/id/#id#" target="_blank"><h4 class="#fileType#">#ListGetAt(name,1,".")#</h4></a>
        </cfoutput>
        <cfcatch type="any"></cfcatch>
        </cftry>
          </div>
          <div class="clear"></div>
        </div>
      </cfoutput>
    </div>
  </cfoutput>
  </div>
</div>

