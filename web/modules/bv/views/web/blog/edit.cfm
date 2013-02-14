<script type="text/javascript" src="/ckeditor/ckeditor.js"></script>
<script type="text/javascript" src="/ckeditor/adapters/jquery.js"></script>
<cfset getMyPlugin(plugin="jQuery").getDepends("ckeditor,form","secure/blog/edit","")>

<cfoutput>
<form id="doBlog" data-siteID="#request.bvsiteID#" class="form-horizontal" action="#rc.blogPostURL#" method="#rc.method#">
    <fieldset>
    	
      <legend><cfif rc.method eq "post">Create<cfelse>Edit</cfif> Blog post</legend>
      <div class="control-group">			
        <label class="control-label" for="title">Title</label>
				<div class="controls">
          <input class="blog_title" type="text" name="title" id="title" value="#rc.title#">
				</div>
      </div>
      <div class="control-group">
        <label class="control-label" for="content">Content</label>
        <div class="controls">
				  <textarea class="ckeditor blog_content" toolbar="Basic" name="content" id="content">#rc.content#</textarea>
				</div>
      </div>
      <div class="control-group">
        <label class="control-label" for="tags">Tags</label>
        <div class="controls">
          <input class="blog_tags" type="text" name="tags" id="tags" value="#rc.tags#">
				</div>
      </div>      
      <div class="form-actions">
        <input name="button" id="doComment" type="button" class="btn btn-success" value="create blog post" />
      </div>
    </fieldset>
  </form>
</cfoutput>