<cfcomponent name="admin">
  <cfproperty name="bvUserService" inject="id:bv.UserService">
  <cfproperty name="ContactService" inject="id:eunify.ContactService">  
  <cfproperty name="SiteService" inject="id:bv.SiteService">
  <cfproperty name="CompanyService" inject="id:eunify.CompanyService">

  <cffunction name="index">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <!--- get all users --->
    <cfset rc.userList = bvUserService.allPeople()>
    <cfloop array="#rc.userList.people#" index="user">      
      <!--- check if they are in already (they shouldn't be!) --->
      <cfset eUnifyContact = ContactService.getContactByEmail(user.email,2,request.siteID)>
      <cfif eUnifyContact.recordCount eq 0>
        <!--- add them --->
        <cfset var contact = getModel("eunify.ContactService")>
        <cfset contact.setid("")>
        <cfset contact.setfirst_name(user.firstName)>
        <cfset contact.setsurname(user.lastName)>        
        <cfset contact.setemail(user.email)>
        <cfset contact.setpassword("")>
        <cfif isDefined("user.jobtitle") AND NOT isNull(user.jobtitle)>
          <cfset contact.getjobTitle(user.jobtitle)>  
        </cfif>        
        <cfset contact.save()>        
      </cfif>
    </cfloop>
    <cfabort>
  </cffunction>
</cfcomponent>