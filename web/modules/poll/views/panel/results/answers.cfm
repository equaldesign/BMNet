<h2>Answers</h2>
<form class="form form-horizontal">
<cfoutput query="rc.answerList" group="groupName">
  <fieldset>
  <legend>#groupName#</legend>
  <cfoutput group="label">
    <div>
      <h2>#label#</h2>
      <cfoutput>
        <div class="currentUser">
          <cfset args = {
              imageURL="https://secure.gravatar.com/avatar/#lcase(Hash(lcase(email)))#",
              companyID = companyID,
              contactID=contactID,
              width = 20,
              class = "gravatar",
              title = ""
            }>
            #renderView(view="viewlets/companyLogo",args=args,cache=true,cacheSuffix="logo_contact_#args.contactID#_#args.width#_#getSetting('siteName')#",cacheTimeout=0)#
          <a href="#bl('contact.index','id=#contactID#')#" class="ajax tooltip" title="#name#">#first_name# #surname#</a><br />
          <p>#value#</p>
        </div>
      </cfoutput>
    </div>
  </cfoutput>
  </fieldset>
</cfoutput>
</form>
