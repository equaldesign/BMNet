<cfcomponent extends="uk.co.ebiz.ajax">
	<cffunction name="callmeBack" access="public" returntype="string">
		<cfargument name="fullname" type="string" required="yes">
		<cfargument name="email" type="string" required="yes">
		<cfargument name="phoneNumber" type="string" required="yes">
		<cfargument name="comment" type="string" required="yes">    
    <cfargument name="pageid" type="numeric" required="yes">            
		<!--- check for existing approved comments --->
    <cfmail server="127.0.0.1" failto="tom.miller@ebiz.co.uk" to="tom.miller@ebiz.co.uk" subject="Lawsons Lead" from="#fullname# <#email#>">
			<cfoutput>
      #comment#
      http://www.lawsons.co.uk/html/#pageid#.html
      </cfoutput>
    </cfmail>
    <cfreturn "thankyou.">
	</cffunction>
</cfcomponent>