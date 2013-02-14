<div id="rightMenuAccordion">
  <cfoutput>

    <h3><a class="admin_deals" href="##deals">Purchasing Agreements</a></h3>
    <div id="right_deals">
      <cfoutput>#renderView(view="shortcuts/panels/deals")#</cfoutput>
    </div>
    <h3 class="hidden" id="feedM"><a href="##" class="admin_feedtools">Feed Control</a></h3>
      <div class="hidden" id="right_feedTools">
        <cfoutput>#renderView(view="feed/filter")#</cfoutput>
      </div>
      <h3 class="hidden" id="psaM"><a href="##" class="admin_dealtools">Deal Tools</a></h3>
      <div class="hidden" id="left_dealTools">
      </div>
    <h3><a class="admin_calendar" href="##calendar">Calendar</a></h3>
    <div id="left_calendar">
    </div>
    <h3><a href="##administration" class="admin_admin">Administration</a></h3>
    <div id="right_administration">
      <cfoutput>#renderView(view="shortcuts/panels/administration")#</cfoutput>
    </div>
    <h3><a href="##bugs" class="admin_bugs">Bugs and support</a></h3>
    <div id="right_bugs">
      <cfoutput>#renderView(view="shortcuts/panels/bugs",cache="true")#</cfoutput>
    </div>
  </cfoutput>
</div>