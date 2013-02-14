<cfoutput>
<div class="t">
  <div class="trow">
    <div class="tcell">
    <h2>#rc.message.subject#</h2>
    <h4>#rc.message.from#</h4>
    <p>#rc.message.date#</p>
    <p>#rc.message.to#</p>
    </div>
    <div class="tcell">
      <cfloop array="#rc.message.attachments#" index="attachment">
        <a href="/alfresco#attachment.downloadURL#">
          <img src="http://www.buildingvine.com/alfresco/service/api/node/#replace(attachment.nodeRef,':/','')#/content/thumbnails/doclib?ph=true&c=force&alf_ticket=#request.user_ticket#">
          <h4>#attachment.name#</h4>
          <h5>#fncFileSize(replace(attachment.size,",","","ALL"))#</h5>
        </a>
      </cfloop>
    </div>
  </div>
</div>
<iframe width="100%" height="400" src="/bv/email/body?downloadURL=#rc.message.downloadURL#"></iframe>
</cfoutput>