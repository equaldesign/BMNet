
<cfcomponent output="false" autowire="true">
  <cfproperty name="MailService" inject="coldbox:plugin:MailService">
  <cfproperty name="Renderer" inject="coldbox:plugin:Renderer">

	<!--- index --->
	<cffunction name="index" returntype="any" output="true" cache="true">
		<cfargument name="event">
    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.recipient = urlDecrypt(event.getValue("recipient"))>
    <cfset rc.subject = urlDecrypt(event.getValue("subject"))>
    <cfset rc.sendautoresponse = urlDecrypt(event.getValue("sendautoresponse"))>
    <cfset rc.autoresponsecontent = urlDecrypt(event.getValue("autoresponsecontent"))>
    <cfset rc.userEmail = event.getValue("contactEmail","tom.miller@ebiz.co.uk")>

    <cfif rc.sendautoresponse>
      <cfset args = {
        content = HtmlUnEditFormat(rc.autoresponsecontent)
      }>
      <cfset rc.CustomerEmail = MailService.newMail().config(from="Turnbull 24-7 <customerservices@turnbullsonline.co.uk>",to="#rc.userEmail#",subject = "Ask an expert")>
      <cfset rc.CustomerEmail.setHtml(Renderer.renderLayout(layout="email/sums/Layout.email.html",args={content="#HtmlUnEditFormat(rc.autoresponsecontent)#"}))>
      <cfset rc.CustomerEmailResult = MailService.send(rc.CustomerEmail)>
    </cfif>
    <cfsavecontent variable="emailContent">
      <cfoutput>
You have been sent a message from your website.
The following information was sent :
      <cfloop list="#Form.FieldNames#" index="field"><br /><cfif Left(field,1) NEQ '_'>#field#: #Evaluate('Form.#field#')##chr(10)#</cfif></cfloop>
      </cfoutput>
    </cfsavecontent>
    <cfset rc.StaffEmail = MailService.newMail().config(from="DO NOT REPLY <support@buildersmerchant.net>",to="#rc.recipient#",subject = "Ask an expert submitted!")>
    <cfset rc.StaffEmail.setHtml(Renderer.renderLayout(layout="email/sums/Layout.email.html",args={content="#emailContent#"}))>
    <cfset rc.StaffEmailResult = MailService.send(rc.StaffEmail)>

	</cffunction>



</cfcomponent>