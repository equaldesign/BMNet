<div id="rightMenuAccordion" class="Aristo">
  <cfoutput>
    <cfif isUserInRole("member")>

    <h3><a class="admin_deals" href="##deals">Purchasing Agreements</a></h3>
    <div id="right_deals">
      <cfoutput>#renderView(view="admin/panels/deals")#</cfoutput>
    </div>
    </cfif>
      <h3 class="hidden" id="feedM"><a href="##" class="admin_feedtools">Feed Control</a></h3>
      <div class="hidden" id="right_feedTools">
        <cfoutput>#renderView(view="feed/filter")#</cfoutput>
      </div>
      <h3 class="hidden" id="psaM"><a href="##" class="admin_dealtools">Deal Tools</a></h3>
      <div class="hidden" id="right_dealTools">
      </div>
    <cfif isUserInRole("member")>
    <h3><a class="admin_favourites" href="##favourites">Favourites</a></h3>
    <div id="right_favourites">
      <cfoutput>#renderView(view="admin/panels/favourites")#</cfoutput>
    </div>
    </cfif>
    <cfif isUserInRole("member")>
    <h3><a href="##pricelists" class="admin_prices">Price Lists</a></h3>
    <div id="right_pricelists">
       <cfoutput>#renderView("admin/panels/priceLists",180,true)#</cfoutput>
    </div>
    </cfif>
    <cfif isUserInRole("member")>
    <h3><a href="##promotions" class="admin_promotions">Promotions</a></h3>
    <div id="right_promotions">
       <cfoutput>#renderView("promotions/all",180,true)#</cfoutput>
    </div>
    </cfif>
    <!--- <cfif isUserInRole("ebiz")>
    <h3><a href="##buildingvine" class="admin_bv">Building Vine&trade;</a></h3>
    <div id="right_buildingvine">
      <cfoutput>#renderView(view="admin/panels/buildingvine",cache="false")#</cfoutput>
    </div>
    </cfif> --->
    <cfif isUserInRole("member")>
		<h3><a class="admin_calendar" href="##calendar">Calendar</a></h3>
		<div id="right_calendar">
		</div>
    </cfif>
    <h3><a class="admin_directory" href="##contacts">Directory of Contacts and Companies</a></h3>
    <div id="right_directory">
      <cfoutput>#renderView(view="admin/panels/directory")#</cfoutput>
    </div>

    <cfif isUserInRole("member")>
    <h3><a class="admin_dms" href="##documents">Documents</a></h3>
    <div id="right_dms">
      <cfoutput>#renderView(view="admin/panels/dms")#</cfoutput>
    </div>
    </cfif>

    <cfif isUserInRole("figures")><!--- isUserInRole("member") --->
    <h3><a href="##figures" class="admin_figures">Figures &amp; Financials</a></h3>
    <div id="right_figures">
      <cfoutput>#renderView(view="admin/panels/figures",cache="false")#</cfoutput>
    </div>
    </cfif>
    <cfif isUserInAnyRole("admin,author")>
  	<h3><a href="##administration" class="admin_admin">Administration</a></h3>
  	<div id="right_administration">
			<cfoutput>#renderView(view="admin/panels/administration",cache="true")#</cfoutput>
	  </div>
    </cfif>
    <cfif isUserInRole("ebiz")>
    <h3><a class="admin_wiki" href="##wiki">Help &amp; Support Wiki</a></h3>
    <div id="right_wiki">
      <cfoutput>#renderView(view="admin/panels/wiki")#</cfoutput>
    </div>
    </cfif>
    <cfif isUserInRole("member")>
    <h3><a href="##bugs" class="admin_bugs">Bugs and support</a></h3>
    <div id="right_bugs">
      <cfoutput>#renderView(view="admin/panels/bugs",cache="true")#</cfoutput>
    </div>
    </cfif>
  </cfoutput>
</div>