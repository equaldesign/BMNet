<cfset getMyPlugin(plugin="jQuery").getDepends("","accordion,psa/psa,psa/overview","dms")>
<cfoutput>

<div class="row mb">
	<div class="span3 gradient">
		<h2 class="">Supplier Info</h2>
    <a href="/company?id=#rc.panelData.company.id#">
    <cfset args = {
        imageURL="",
        companyID=rc.panelData.company.id,
        width = 0,
        class = "companyDetailImage",
        title = rc.panelData.company.name
      }>
      #renderView(view="viewlets/companyLogo",args=args,cache=true,cacheSuffix="logo_#args.companyID#_#args.width#_#getSetting('siteName')#",cacheTimeout=0)#
    </a>
    <br class="clear" />
    <p><b><a href="/company?id=#rc.panelData.company.id#">#rc.panelData.company.name#</a></b><br />
        <cfif rc.panelData.company.company_address_1 neq "">#rc.panelData.company.company_address_1#<br /></cfif>
        <cfif rc.panelData.company.company_address_2 neq "">#rc.panelData.company.company_address_2#<br /></cfif>
        <cfif rc.panelData.company.company_address_3 neq "">#rc.panelData.company.company_address_3#<br /></cfif>
        <cfif rc.panelData.company.company_address_4 neq "">#rc.panelData.company.company_address_4#<br /></cfif>
        <cfif rc.panelData.company.company_address_5 neq "">#rc.panelData.company.company_address_5#<br /></cfif>
        <cfif rc.panelData.company.company_postcode neq "">#rc.panelData.company.company_postcode#<br /></cfif>
       <br /> <b>Tel: #rc.panelData.company.company_phone#</b><br />
        Fax: #rc.panelData.company.company_fax#<br /><br />
        <cfif rc.panelData.company.company_website neq "">
          <a title="website" href="#makeURL(rc.panelData.company.company_website)#"><img src="https://d25ke41d0c64z1.cloudfront.net/images/icons/globe.png" border="0" hspace="3" /></a>
        </cfif>
        <cfif rc.panelData.company.company_email neq "">
          <a title="email"  href="mailto:#rc.panelData.company.company_email#"><img src="https://d25ke41d0c64z1.cloudfront.net/images/icons/mail.png" border="0" hspace="3" /></a>
        </cfif>
        <cfset supplierContact = getModel("contact").getCustomContact(rc.panelData.company.id)>
        <!--- <h4>Contact</h4>
        <b><a href="/contact/index/id/#supplierContact.id#">#supplierContact.first_name# #supplierContact.surname#</a></b> <cfif supplierContact.tel neq "">(#supplierContact.tel#)</cfif>
        <!---
    <a title="Set a custom contact" href="/contact/setCustom/companyID/#rc.panelData.company.id#" class="tooltip doDiag customContact noAjax void">Got a different contact?</a>
    ---> --->
     </p>
     <cfset rgs = {relationship="arrangement",id=rc.psaID}>
     #renderView(view="tags/list",args=rgs)#
	</div>
	<div class="span3 gradient">
		<h2>Deal Information</h2><br />
    <p>
      <b>PRODUCTS</b><br />
      #rc.panelData.psa.name#<br /><br />
      <b>DURATION:</b><br />
      #DateFormat(rc.panelData.psa.period_From,"MMMM YYYY")# - #DateFormat(rc.panelData.psa.period_To,"MMMM YYYY")#<br /><br />
      <b>CATEGORIES:</b><br />
      #ValueList(rc.panelData.psaCategories.name,", ")#<br />
      <br /><b>NEGOTIATED BY:</b><br />
      <div style="margin:0 5px;" class="currentUser">
        <cfset args = {
          imageURL="http://www.gravatar.com/avatar/#lcase(Hash(lcase(rc.panelData.contact.email)))#",
          companyID=rc.panelData.membercompany.id,
          width = 20,
          class = "gravatar",
          title = ""
        }>
        #renderView(view="viewlets/companyLogo",args=args,cache=true,cacheSuffix="logo_#args.companyID#_#args.width#_#getSetting('siteName')#",cacheTimeout=0)#
        <a href="#bl('contact.index','id=#rc.panelData.contact.id#')#" class="tooltip" title="#rc.panelData.membercompany.name#">#rc.panelData.contact.first_name# #rc.panelData.contact.surname#</a>
        <p style="color: ##999; font-size: 11px;">#rc.panelData.membercompany.known_as#</p>
      </div>
    </p>
    <h2 class="prices">Price Lists</h2>

      <div class="accordionopen">
      <h5><a href="##">Current</a></h5>
      <div>
      <cfloop query="rc.panelData.priceLists">
      <div class="psa_priceLists">
        <cfif showThumbnail>
        <div class="image">
          <cfif fileExists("#rc.app.appRoot#dms/documents/thumbnails/#id#_small.jpg")>
            <a href="/documents/download/id/#id#" target="_blank">
            <img border="0" align="left" class="priceListFile glow" width="30" src="/includes/images/thumbnails/#getSetting('siteName')#/#id#_small.jpg" />
            </a>
          <cfelse>
            <cftry>
            <cfset getModel("dms").createThumbnails(id,filetype)>
            <cfcatch type="any"></cfcatch>
            </cftry>
          </cfif>
        </div>
        <div class="desc">
        <cfelse>
        <div>
        </cfif>
          <a href="#bl('documents.download','id=#id#')#" target="_blank"><h4 class="#fileType#">#ListGetAt(name,1,".")#</h4></a>
          <cfif timeSensitive>
            <cfset expiryDays = DateDiff("d",now(),validTo)>
            <cfif expiryDays LT 60>
              <p class="expiry">Expires in <strong>#expiryDays# days</strong></p>
            </cfif>
          </cfif>
        </div>
        <br class="clear" />
      </div>
      </cfloop>
      </div>
      <cfif rc.panelData.pendingPriceLists.recordCount neq 0>
      <h5><a href="##">Pending</a></h5>
      <div>
      <cfloop query="rc.panelData.pendingPriceLists">
      <div class="psa_priceLists">
        <cfif showThumbnail>
        <div class="image">
          <cfif fileExists("#rc.app.appRoot#dms/documents/thumbnails/#id#_small.jpg")>
            <a class="noAjax" href="/documents/download/id/#id#" tar="_blank">
            <img border="0" align="left" class="priceListFile glow" width="30" src="/includes/images/thumbnails/#getSetting('siteName')#/#id#_small.jpg" />
            </a>
          <cfelse>
            <cfset getModel("dms").createThumbnails(id,filetype)>
          </cfif>
        </div>

        <div class="desc">
        <cfelse>
        <div>
        </cfif>
          <a class="noAjax" href="#bl('documents.download','id=#id#')#" tar="_blank"><h4 class="#LCASE(fileType)#">#ListGetAt(name,1,".")#</h4></a>
          <cfif timeSensitive>
            <cfset startsOn = DateDiff("d",now(),validFrom)>
            <p class="expiry">Valid in <strong>#startsOn# days</strong></p>
          </cfif>
        </div>
      </div>
      </cfloop>
      </div>
      </cfif>
      </div>
	</div>
	<div class="span3 gradient">

		<cfif StructKeyExists(rc.panelData.xml.arrangement,"terms") AND ArrayLen(rc.panelData.xml.arrangement.terms.XmlChildren) gte 1>
      <h2>Terms</h2>
      <div class="Aristo accordion tclothtable">
      <cfloop from="1" to="#ArrayLen(rc.panelData.xml.arrangement.terms.component)#" index="c">
        <cfset curr = rc.panelData.xml.arrangement.terms.component>
            <cfif curr[c].details.XmlText neq ""  AND canView(curr[c])>
        <h5><a href="##">#curr[c].title.XmlText#</a></h5>
        <div>#curr[c].details.XmlText#<br /><br /></div>
        </cfif>
      </cfloop>
      </div>
      </cfif>
      <cfif StructKeyExists(rc.panelData.xml.arrangement,"discount") AND ArrayLen(rc.panelData.xml.arrangement.discount.XmlChildren) gte 1>
        <cfset displayDiscounts = false>
        <cfloop from="1" to="#ArrayLen(rc.panelData.xml.arrangement.discount.component)#" index="c">
          <cfset curr = rc.panelData.xml.arrangement.discount.component>
          <cfif curr[c].details.XmlText neq "">
            <cfset displayDiscounts = true>
          </cfif>
        </cfloop>
        <cfif displayDiscounts>
          <h2>Discounts</h2>
          <div class="Aristo accordion tclothtable">
          <cfloop from="1" to="#ArrayLen(rc.panelData.xml.arrangement.discount.component)#" index="c">
            <cfset curr = rc.panelData.xml.arrangement.discount.component>
            <cfif curr[c].details.XmlText neq "" AND canView(curr[c])>
            <h5><a href="##">#curr[c].title.XmlText#</a></h5>
            <div>#curr[c].details.XmlText#<br /><br /></div>
            </cfif>
          </cfloop>
          </div>
        </cfif>
      </cfif>
      <cfif StructKeyExists(rc.panelData.xml.arrangement,"notes") AND ArrayLen(rc.panelData.xml.arrangement.notes.XmlChildren) gte 1>
        <cfset displayNotes = false>
        <cfloop from="1" to="#ArrayLen(rc.panelData.xml.arrangement.notes.component)#" index="c">
          <cfset curr = rc.panelData.xml.arrangement.notes.component>
          <cfif curr[c].details.XmlText neq "">
           <cfset displayNotes = true>
          </cfif>
        </cfloop>
        <cfif displayNotes>
          <h2>Notes</h2>
          <div class="Aristo accordion tclothtable">
          <cfloop from="1" to="#ArrayLen(rc.panelData.xml.arrangement.notes.component)#" index="c">
            <cfset curr = rc.panelData.xml.arrangement.notes.component>
            <cfif curr[c].details.XmlText neq "" AND canView(curr[c])>
              <h5><a href="##">#curr[c].title.XmlText#</a></h5>
              <div>#curr[c].details.XmlText#<br /><br /></div>
            </cfif>
          </cfloop>
          </div>
        </cfif>
      </cfif>
      <cfif StructKeyExists(rc.panelData.xml.arrangement,"carriage") AND ArrayLen(rc.panelData.xml.arrangement.carriage.XmlChildren) gte 1>
        <cfset displayDelivery = false>
        <cfloop from="1" to="#ArrayLen(rc.panelData.xml.arrangement.carriage.component)#" index="c">
          <cfset curr = rc.panelData.xml.arrangement.carriage.component>
          <cfif curr[c].details.XmlText neq "" AND canView(curr[c])>
           <cfset displayDelivery = true>
          </cfif>
        </cfloop>
        <cfif displayDelivery>
          <h2>Delivery</h2>
          <div class="Aristo accordion tclothtable">
          <cfloop from="1" to="#ArrayLen(rc.panelData.xml.arrangement.carriage.component)#" index="c">
            <cfset curr = rc.panelData.xml.arrangement.carriage.component>
            <cfif curr[c].details.XmlText neq "" AND  canView(curr[c])>
              <h5><a href="##">#curr[c].title.XmlText#</a></h5>
              <div>#curr[c].details.XmlText#<br /><br /></div>
            </cfif>
          </cfloop>
          </div>
        </cfif>
      </cfif>
	</div>
</div>
<div class="row mb">
	<div class="span6 gradient">
		<h2>Rebates</h2>
		<cfif isUserInRole("rebates")>
     <div class="Aristo accordion tclothtable">
      <cfif StructKeyExists(rc.panelData.xml.arrangement,"rebate") AND ArrayLen(rc.panelData.xml.arrangement.rebate.XmlChildren) gte 1>
          <cfloop from="1" to="#ArrayLen(rc.panelData.xml.arrangement.rebate.component)#" index="c">
            <cfset curr = rc.panelData.xml.arrangement.rebate.component>
            <cfif canView(curr)>
              <cfif curr[c].XmlAttributes.type  neq "rebate">
                <h5><a href="##">#curr[c].title.XmlText#</a></h5>
                <div>
                    <!--- it's just meta --->
                    <p>#curr[c].details.XmlText#</p>
                </div>
              <cfelse>
                <cfif curr[c].calculate.XmlText eq "true">
                    <h5><a href="##">#curr[c].title.XmlText#</a></h5>
                    <div>
                   <cfif #curr[c].details.XmlText# neq ""><p>#curr[c].details.XmlText#</p></cfif>
                   <!--- it's a rebate of some kind --->
                   <cfif StructKeyExists(curr[c],"step") AND IsXmlElem(curr[c].step)>
                     <cfset tarValue = 0>

                     <cfset steps = curr[c].step>
                     <table class="v tableCloth">
                       <thead>
                       <tr>
                         <th class="rightalign">From</th>
                         <th class="rightalign">To</th>
                         <th class="rightalign">value</th>
                       </tr>
                      </thead>
                      <tbody>
                       <cfloop from="1" to="#ArrayLen(steps)#" index="st">
                         <cfif isNumeric(steps[st].value.XmlText)>
                            <cfset v = steps[st].value.XmlText>
                         <cfelse>
                            <Cfset v = 0>
                         </cfif>
                         <tr id="tr_#c#_#st#" class="#IIf(NumberFormat(v,'99999.00') eq tarValue,"'ok'","'na'")#">
                           <td class="rightalign" nowrap="nowrap" width="100"><cfif #getUnitType2(curr[c].inputtype.XmlText).name# eq "&pound;">#getUnitType2(curr[c].inputtype.XmlText).name##NumberFormatIfNumber(steps[st].from.XmlText,"9,999,999")#<cfelse>#NumberFormatIfNumber(steps[st].from.XmlText,"9,999,999")##getUnitType2(curr[c].inputtype.XmlText).name# </cfif></td>
                           <td class="rightalign" nowrap="nowrap" width="100"><cfif #getUnitType2(curr[c].inputtype.XmlText).name# eq "&pound;">#getUnitType2(curr[c].inputtype.XmlText).name##NumberFormatIfNumber(steps[st].to.XmlText,"9,999,999")#<cfelse>#NumberFormatIfNumber(steps[st].to.XmlText,"9,999,999")##getUnitType2(curr[c].inputtype.XmlText).name# </cfif></td>
                           <td class="rightalign" nowrap="nowrap" width="75"><cfif #getUnitType2(curr[c].outputtype.XmlText).name# eq "&pound;">#getUnitType2(curr[c].outputtype.XmlText).name##steps[st].value.XmlText#<cfelse>#steps[st].value.XmlText##getUnitType2(curr[c].outputtype.XmlText).name#</cfif></td>
                         </tr>
                       </cfloop>
                        </tbody>
                     </table>
                      </cfif>
                    </div>
                </cfif>
             </cfif>
          </cfif>
        </cfloop>
      </cfif>
    </div>
    </cfif>
	</div>
	<div class="span3 gradient">
		<h2>Promotions</h2>
      <div id="dealPromotions">
      <cfset rc.promotionsCat = rc.panelData.promotions.id>
      <cfif isNumeric(rc.promotionsCat)>
        <cfoutput>#renderView(view="promotions/deal",cache=false)#</cfoutput>
      <cfelse>
        <!-- no promotions category found -->
        <!--- so create one for them --->
        <cfset rc.promotionsCat = getModel("promotions").createCompanyPromotionFolder(rc.panelData.company.id)>
        <cfoutput>#renderView(view="promotions/deal",cache=false)#</cfoutput>
      </cfif>

      <!---<cfloop query="rc.panelData.promotions">
        <a href="/documents/download/id/#id#">
          <cfif fileExists("#rc.app.appRoot#dms/documents/thumbnails/#id#.jpg")>
            <img class="promotion glow" width="200" src="/includes/images/thumbnails/#Setting('siteName')#/#id#.jpg" />
          <cfelse>
            <cfset Model("dms").createThumbnails(id,filetype)>
          </cfif>
        </a>
      </cfloop>--->
      </div>
	</div>
</div>
</cfoutput>