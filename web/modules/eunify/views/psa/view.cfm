<cfset getMyPlugin(plugin="jQuery").getDepends("","menus","",true,"eunify")>
<cfoutput>
  <cfif canViewPSA(rc.psa.ID,rc.psa.memberID,rc.psa.company_id)>
  <input type="hidden" id="psaID" value="#rc.psa.id#" />
  <h2 class="cufon"><cfif isDate(rc.psa.period_from)>#year(rc.psa.period_from)#</cfif>-#NumberFormat(rc.psa.id,"000")# <cfif rc.company.id neq "">#rc.company.name#</cfif> <cfif rc.revisionID neq 0><span class="red"> (Revision id #rc.revisionID#)</span> <a href="#bl('psa.index','psaID=#rc.psaID#')#"><span class="green">(Cancel)</span></a></cfif></h2>
  <div id="tabs" class="psaTabs">
    <ul>
      <li><a class="show_tools dashboard" href="#bl('psa.view','panel=overview&psaID=#rc.psa.id#&revisionID=#rc.revisionID#')#"><span>dashboard</span></a></li>
      <li><a class="show_tools marketing" href="#bl('psa.view','panel=marketing&psaID=#rc.psa.id#&revisionID=#rc.revisionID#')#"><span>marketing</span></a></li>
      <li><a class="show_tools fullagreement" href="#bl('psa.view','panel=psa&psaID=#rc.psa.id#&revisionID=#rc.revisionID#')#"><span>full agreement</span></a></li>
      <cfif isUserInRole("staff")><li><a class="show_tools documents" href="#bl('documents.relatedCategories','type=deal&relatedID=#rc.psa.id#&l=m')#"><span>files</span></a></li></cfif>
      <cfif isUserInAnyRole("Categories,figures") OR rc.psa.company_id eq rc.sess.eGroup.companyID><li><a class="show_tools figures" href="#bl('psa.view','panel=figures&psaID=#rc.psa.id#')#"><span>financial</span></a></li></cfif>
      <cfif isUserInRole("staff")><li><a class="show_tools updates" href="#bl('blog.related','relatedTo=arrangement&relatedID=#rc.psa.id#')#"><span>news</span></a></li>
      <li><a class="show_tools feed" href="/feed/index?searchOn=arrangement&searchID=#rc.psa.id#"><span>Feed</span></a></li>
      </cfif>
      <cftry>
      <cfif rc.company.buildingVine>
      <li><a class="buildingvine" href="#bl('bv.site.overview','siteID=#rc.company.bvsiteid#&showBVMenu=Site')#"><span>BV</span></a></li>
      </cfif>
      <cfcatch type="any"></cfcatch>
      </cftry>
    </ul>
  </div>
  <cfelse>
    <h2>You do not have permission to view this arrangement</h2>
  </cfif>
</cfoutput>