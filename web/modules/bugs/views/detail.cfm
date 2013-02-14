<cfset getMyPlugin(plugin="jQuery").getDepends("","","comment",false)>
<cfset getMyPlugin(plugin="jQuery").getDepends("","","extra",true)>
<cfoutput>
<div class="page-header">
  <h1>#rc.bug.gettitle()#</h1>
</div>
<dl class="dl-horizontal">
	<dt>Ticket:</dt>
	<dd>#rc.bug.getticket()#</dd>
	<dt>Date:</dt>
    <dd>#DateFormatOrdinal(rc.bug.getcreated(),"DDDD D MMMM YYYY")#</dd>
    <dt>Opened By</dt>
    <dd>#rc.bug.getusername()#</dd>
    <dt>Email</dt>
    <dd>#rc.bug.getemail()#</dd>
    <dt>Attachments</dt>
    <dd>
      <cfloop query="rc.bug.attachments">
      <span class="label"><a href="#bl('bugs.download','id=#id#')#">#listLast(filename,"/")#</a></span>
      </cfloop>
    </dd>
</dl>

<pre>#rc.bug.getdescription()#</pre>
<cfif rc.bug.getrequest() neq "">
<h3>Request Information</h3>
<cfset testURL = rc.bug.geturl()>
<cfset URLStruct = DeSerializeJSON(rc.bug.geturlVars())>
<cfloop collection="#URLStruct#" item="k">
<cfset testURL = "#testURL#/#k#/#URLStruct[k]#">
</cfloop>
<a href="#testURL#" target="_blank">#testURL#</a>
<cfdump label="Form Variables" var="#DeSerializeJSON(rc.bug.getformVars())#">
#rc.bug.getbrowser()#
#rc.bug.getrequest()#
#rc.bug.getdescription()#
#rc.bug.getreproduce()#

</cfif>

<h2>Comments</h2>
<div id="comments">
  <cfloop query="rc.bug.comments">
	<cfif event.getCurrentModule() neq ""><cfset commentAuthor = getModel("contact").getContactByEmail(email)></cfif>
    <div class="commentBox clearfix">
      <div class="commentTitle clearfix">
        <div class="commentSubject">#title#</div>
        <div class="commentAuthorImage">
          <cfif event.getCurrentModule() neq "">
          <cftry>
          <cfset args = {
            imageURL="https://secure.gravatar.com/avatar/#lcase(Hash(lcase(email)))#",
            contactID=commentAuthor.id,
            companyID = commentAuthor.company_id,
            width = 30,
            class = "gravatar",
            title = "Profile Picture"
          }>
          #renderView(view="viewlets/companyLogo",args=args,cache=true,cacheSuffix="logo_contact_#args.contactID#_#args.width#_#getSetting('siteName')#",cacheTimeout=0)#
          <cfcatch type="any"></cfcatch>
          </cftry>
          <cfelse>
          <cfoutput><img src="https://secure.gravatar.com/avatar/#lcase(Hash(lcase('#email#')))#?size=25&amp;d=https://www.buildingvine.com/includes/images/secure/blankAvatar.jpg" alt="" class="thumbnail" /></cfoutput>
          </cfif>
          </div>
        <div class="commentMeta">
          <span class="commentDate">#DateFormatOrdinal(datestamp,"DDDD DD MMMM YYYY")# at #TimeFormat(datestamp,"HH:MM")#</span>
          <span class="commentAuthor"><cfif event.getCurrentModule() neq ""><a href="#bl('contact.index','id=#commentAuthor.id#')#">#username#</a><cfelse>#username#</cfif></span>
        </div>
      </div>
      <div class="commentContent">#ParagraphFormat2(stripOriginalMessage(comment))#</div>
    </div>
  </cfloop>
</div>
</cfoutput>
<form action="#bl('bugs.createcomment','bugID=#rc.bug.getid()#')#" class="form form-horizotnal">
  <div class="control-group">
    <textarea rows="10" class="input-xlarge" name="comment" richtext="true" toolbar="Basic"></textarea>
  </div>
  <div class="form-actions">
    <input name="submit" type="submit" class="btn btn-success" value="add comment" />
  </div>
</form>
