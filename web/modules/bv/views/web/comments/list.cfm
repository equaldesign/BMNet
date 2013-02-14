<cfset getMyPlugin(plugin="jQuery").getDepends("form","secure/comments/comments","secure/comments/default")>
<cfparam name="rc.commentLabel" default="comment" type="string">
<cfparam name="rc.commentTitle" default="true" type="boolean">
<cfoutput>
  <cfloop array="#rc.comments.items#" index="comment">
  <div class="commentBox clearfix">
    <div class="commentTitle clearfix">
      <div class="commentSubject">#comment.title#</div>
      <div class="commentAuthorImage"><img alt="Profile Picture" src="http://www.gravatar.com/avatar/#lcase(Hash(lcase(comment.author.userName)))#?size=30&amp;d=mm" /></div>
      <div class="commentMeta"><span class="commentDate">#DateFormat(cdt2(comment.createdOn),"DDDD MMMM DD")# @ #TimeFormat(cdt2(comment.createdOn),"HH:MM")# </span> <span class="commentAuthor"><a href="/contact/index/id/#urlencrypt(comment.author.username)#">#comment.author.firstName# #comment.author.lastName#</a></span></div>
      <div class="commentControls">
      <cfif comment.permissions.delete>
        <a href="/alfresco/service/#comment.url#?alf_ticket=#request.user_ticket#" class="deleteComment"></a>
      </cfif>
      <cfif comment.permissions.edit>
        <a href="/alfresco/service/#comment.url#?alf_ticket=#request.user_ticket#" class="editComment"></a>
      </cfif>
      </div>
    </div>
    <div class="commentContent">#ParagraphFormat2(comment.content)#</div>
  </div>
  </cfloop>
</cfoutput>

<cfoutput>
<div class="form">
  <form class="form-horizontal" id="doComment" action="/alfresco/service/api#rc.commentsUrl#?alf_ticket=#request.user_ticket#" method="post">
    <fieldset>
      <legend>Add comment</legend>
      <div class="control-group">
        <label class="control-label" for="title">Title</label>
        <div class="controls">
          <input type="text" name="title" id="title">
        </div>
      </div>
      <div class="control-group">
        <label class="control-label" for="content">Comment</label>
        <div class="controls">
          <textarea name="content" id="content"></textarea>
        </div>
      </div>
    </fieldset>
    <div class="form-actions">
      <input id="doComment" type="submit" class="btn btn-success" value="add your comment">
    </div>    
  </form>
</div>
</cfoutput>