<cfset getMyPlugin(plugin="jQuery").getDepends("","comment/doComment","comment",false,"eunify")>
<cfoutput>
<cfif isDefined("rc.commentLink")>
  <cfset cSpan = "span6">
<cfelse>
  <cfset cSpan = "span12">
</cfif>
<div class="row-fluid">
  <div id="comments" class="#cSpan#">
    <cfloop query="rc.comments">
      <div class="commentBox clearfix">
        <div class="commentTitle clearfix">
          <div class="commentSubject">#title#</div>
          <div class="commentAuthorImage">
            <img width="30" class="gravatar" src="http://www.gravatar.com/avatar/#lcase(Hash(lcase(email)))#?size=75&d=http://#cgi.HTTP_HOST#/modules/eunify/includes/images/blankAvatar.jpg" />
            </div>
          <div class="commentMeta">
            <span class="commentDate">#DateFormatOrdinal(stamp,"DDDD DD MMMM YYYY")# at #TimeFormat(stamp,"HH:MM")#</span>
            <span class="commentAuthor"><a href="#bl('contact.index','id=#contactID#')#">#first_name# #surname#</a> (<a href="#bl('company.index','id=#company_id#')#">#known_as#</a>)</span>
          </div>
          <div class="commentControls">
            <cfif rc.sess.BMNet.contactID eq contactID or rc.sess.BMNet.contactID eq contactID OR isUserInRole("admin") OR isUserInRole("memberadmin")><a href="##" class="deleteComment" rev="#id#"></a></cfif>
          </div>
          <div class="commentAttachments">
            <cfloop list="#attachments#" index="fileName">
             <cfset f = ListLast(fileName,"/")>
             <a href="/comment/attachment?f=#f#" target="_blank"><h4 class="#LCASE(listLast(f,'.'))#">#ListGetAt(f,1,".")#</h4></a>
            </cfloop>
          </div>
        </div>
        <div class="commentContent">#ParagraphFormat2(content)#</div>
      </div>
    </cfloop>

  </div>
  <cfif isDefined("rc.commentLink")>
  <div class="span6" id="createComment">

    <form class="form-horizontal" id="form_comment" action="#rc.commentLink#" method="post">
      <fieldset>
        <legend>Add new Comment / Note</legend>
        <div class="control-group">
          <label class="control-label">Title<em>*</em></label>
          <div class="controls">
            <input type="text" size="30" name="title" value="" />
          </div>
        </div>
        <div class="control-group">
          <label class="control-label">Comment</label>
          <div class="controls">
            <textarea id="comment" name="comment" rows="15" columns="35" ></textarea>
          </div>
        </div>
      </fieldset>
      <div class="form-actions">
        <button type="submit" class="btn btn-primary">Add comment</button>
      </div>
      <input name="security" value="public" type="hidden">
      <input name="relationshipURL" value="#paramValue('rc.relationshipURL','')#" type="hidden">
    </form>
  </div>
  </cfif>
</div>


</cfoutput>