<div id="pollList">
<cfloop query="rc.polls">
  <div class="poll">
    <cfif invited eq 0>
      <cfset p = 0>
    <cfelse>
      <cfset p = int(completed/invited*100)>
    </cfif>
    <cfoutput>
    <img align="right" title="#p# percent complete" class="" src="http://chart.apis.google.com/chart?chf=bg,s,FFFFFF00&chs=100x50&cht=gm&chd=t:#p#">
    <h3><a href="#bl('poll.detail','id=#id#')#">#name#</a></h3>
    <p>#description#</p>
    </cfoutput>
    <cfif rc.filter eq "open">
      <cfif allowMultipleResponses>
        <h4>Completed by</h4>
        <cfset invitees = getModel("poll").getInvitees(id,"true")>
        <cfoutput query="invitees">
          <a href="#bl('contact.index','id=#contactID#')#">
            <cfset args = {
              imageURL="https://secure.gravatar.com/avatar/#lcase(Hash(lcase(email)))#",
              companyID = company_id,
              contactID=contactID,
              width = 20,
              class = "tooltip gravatar",
              title = name
            }>
            #renderView(view="viewlets/companyLogo",args=args,cache=true,cacheSuffix="logo_contact_#args.contactID#_#args.width#_#getSetting('siteName')#",cacheTimeout=0)#

          </a>
        </cfoutput>
        <div class="clear"></div>
        <h4>Awaiting completion from</h4>
        <cfset invitees = getModel("poll").getInvitees(id,"false")>
        <cfoutput query="invitees">
          <a href="#bl('contact.index','id=#contactID#')#">
            <cfset args = {
              imageURL="https://secure.gravatar.com/avatar/#lcase(Hash(lcase(email)))#",
              companyID = company_id,
              contactID=contactID,
              width = 20,
              class = "tooltip gravatar",
              title = name
            }>
            #renderView(view="viewlets/companyLogo",args=args,cache=true,cacheSuffix="logo_contact_#args.contactID#_#args.width#_#getSetting('siteName')#",cacheTimeout=0)#
          </a>
        </cfoutput>
        <div class="clear"></div>
      <cfelse>
        <h4>Completed by</h4>
        <cfset invitees = getModel("poll").getInvitees(id,"true")>
        <cfoutput query="invitees" group="known_as">
          <a href="#bl('contact.index','id=#contactID#')#">
            <cfset args = {
              imageURL="https://secure.gravatar.com/avatar/#lcase(Hash(lcase(email)))#",
              companyID = company_id,
              contactID=contactID,
              width = 20,
              class = "tooltip gravatar",
              title = name
            }>
            #renderView(view="viewlets/companyLogo",args=args,cache=true,cacheSuffix="logo_contact_#args.contactID#_#args.width#_#getSetting('siteName')#",cacheTimeout=0)#
          </a>
        </cfoutput>
        <div class="clear"></div>
        <h4>Awaiting completion from</h4>
        <cfset invitees = getModel("poll").getInvitees(id,"false")>
        <cfoutput query="invitees" group="known_as">
          <a href="#bl('contact.index','id=#contactID#')#">
            <cfset args = {
              imageURL="https://secure.gravatar.com/avatar/#lcase(Hash(lcase(email)))#",
              companyID = company_id,
              contactID=contactID,
              width = 20,
              class = "tooltip gravatar",
              title = name
            }>
            #renderView(view="viewlets/companyLogo",args=args,cache=true,cacheSuffix="logo_contact_#args.contactID#_#args.width#_#getSetting('siteName')#",cacheTimeout=0)#
          </a>
        </cfoutput>
        <div class="clear"></div>
      </cfif>
    </cfif>
  </div>
</cfloop>
<cfif rc.polls.recordCount eq 0>
  <h2>No current Questionnaires</h2>
</cfif>
</div>