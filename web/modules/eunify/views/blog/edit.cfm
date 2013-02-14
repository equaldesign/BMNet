<div class="form-signUp">
<cfoutput>
  <cfif rc.blogPost.getid() eq ""><h2>Create new blog post</h2></cfif>
  <cfform class="form" id="editWiki" method="post" action="#bl('blog.doEdit')#">
  <cfinput type="hidden" name="id" value="#rc.blogPost.getid()#">
  <p>Required fields are are denoted by <em>*</em></p>
    <fieldset>
      <legend>Blog</legend>
      <div>
        <label for="title" class="o">Category <em>*</em></label>
        <cfselect id="categoryID" name="categoryID">
          <cfloop query="rc.blogCategories">
            <option value="#id#" #vm(id,rc.blog.categoryID)#>#name#</option>
          </cfloop>
        </cfselect>
      </div>
      <div>
        <label for="importance" class="o">Importance</label>
        <cfselect name="importance" multiple="true">
          <option value="1" #vm(1,rc.blog.importance)#>1 Very Important</option>
          <option value="2" #vm(2,rc.blog.importance)#>2 Important</option>
          <option value="3" #vm(3,rc.blog.importance)#>3 Price Lists</option>
          <option value="4" #vm(4,rc.blog.importance)#>4 Promotions and Offers</option>
          <option value="5" #vm(5,rc.blog.importance)#>5 Minor Adjustments</option>
        </cfselect>
      </div>
      <div>
        <label for="title" class="o">Title <em>*</em></label>
        <cfinput size="30" type="text" name="title" id="title" value="#rc.blog.title#" />
      </div>
      <div>
        <label for="title" class="o">Related ID</label>
        <cfinput size="5" type="text" name="relatedID" id="relatedID" value="#rc.blog.relatedID#" />
      </div>
      <div>
        <label for="title" class="o">Related To</label>
        <cfselect name="relatedTo" id="relatedTo">
          <option #vm(rc.blog.relatedTo,"none")# value="none"> none </option>
          <option #vm(rc.blog.relatedTo,"arrangement")# value="arrangement">Agreement</option>
          <option #vm(rc.blog.relatedTo,"company")# value="company">Company</option>
          <option #vm(rc.blog.relatedTo,"appointment")# value="appointment">Appointment</option>
          <option #vm(rc.blog.relatedTo,"contact")# value="contact">Contact</option>
        </cfselect>
      </div>
      <div>
        <label for="date" class="o">Date <em>*</em></label>
        <cfinput size="30" type="text" class="date" name="date" id="date" value="#iif (rc.blog.date eq "",'"#dateFormat(now(),"DD/MM/YYYY")#"','"#dateFormat(rc.blog.date,"DD/MM/YYYY")#"')#" />
      </div>
      <div>
        <cftextarea name="body" id="content" richtext="true" height="600">#rc.blog.body#</cftextarea>
      </div>
    </fieldset>
    <div class="rightControlSet">
      <div>
      <cfinput name="submit" class="doIt" type="submit" value="#IIF(rc.blogPost.getid() eq "", "'Create Blog Post'","'Edit Blog Post'")#" />
      </div>
    </div>
  </cfform>
</cfoutput>
</div>