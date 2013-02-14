
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
        <labe class="control-label" for="content">Comment</label>
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