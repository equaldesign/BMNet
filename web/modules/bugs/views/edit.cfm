<cfoutput>
<cfif rc.bug.getid() eq "">
  <div class="page-header">
	 <h2>Create new ticket</h2>
	</div>
</cfif>
  <form class="form form-horizontal" enctype="multipart/form-data" id="editBranch" method="post" action="#bl('bugs.doEdit')#">
    <fieldset>
      <legend>&nbsp; Bug Information &nbsp;</legend>
      <div class="control-group">
        <label for="name" class="control-label">Title <em>*</em></label>
        <div class="controls">
        	<input size="30" type="text" name="title" id="title" value="#rc.bug.gettitle()#" />
				</div>
      </div>
      <div class="control-group">
        <label for="known_as"  class="control-label">Description<em>*</em></label>
        <div class="controls">
        	<textarea rows="8" cols="30" richtext="true" class="input-xlarge" name="description" id="description">#rc.bug.getdescription()#</textarea>
				</div>
      </div>
      <div class="control-group">
        <label for="known_as"  class="control-label">Steps to reproduce<em>*</em></label>
        <div class="controls">
				  <textarea cols="30" rows="8" richtext="true" class="input-xlarge" name="reproduce" id="reproduce">#rc.bug.getreproduce()#</textarea>
				</div>
      </div>

      <cfif isUserInAnyRole("egroup_admin,ebiz")>
      <div class="control-group">
        <label for="version"  class="control-label">Version</label>
        <div class="controls">
          <input type="text" name="version" value="#rc.bug.getversion()#">
        </div>
      </div>
      <div class="control-group">
        <label for="fixversion"  class="control-label">Fix Version</label>
        <div class="controls">
          <input type="text" name="fixversion" value="#rc.bug.getfixversion()#">
        </div>
      </div>
      <div class="control-group">
        <label for="fixDate"  class="control-label">Fix Date</label>
        <div class="controls">
          <input type="text" class="date" name="fixDate" value="#rc.bug.getfixDate()#">
        </div>
      </div>
      <div class="control-group">
        <label for="assignee"  class="control-label">Assignee</label>
        <div class="controls">
          <input type="text" class="date" name="assignee" value="#rc.bug.getassignee()#">
        </div>
      </div>
      <div class="control-group">
        <label for="component"  class="control-label">Component</label>
        <div class="controls">
          <select id="component" name="component">
            <option value="agreement" #vm(rc.bug.getcomponent(),"agreement")#>Agreement</option>
            <option value="contact" #vm(rc.bug.getcomponent(),"contact")#>Contact</option>
            <option value="Company" #vm(rc.bug.getcomponent(),"Company")#>Company</option>
            <option value="Calendar" #vm(rc.bug.getcomponent(),"Calendar")#>Calendar</option>
            <option value="faq" #vm(rc.bug.getcomponent(),"faq")#>FAQs</option>
            <option value="blog" #vm(rc.bug.getcomponent(),"blog")#>Blog</option>
            <option value="calculation" #vm(rc.bug.getcomponent(),"calculation")#>Calculation</option>
            <option value="rebates" #vm(rc.bug.getcomponent(),"rebates")#>Rebates</option>
            <option value="ledger" #vm(rc.bug.getcomponent(),"ledger")#>Ledger</option>
            <option value="buildingvine" #vm(rc.bug.getcomponent(),"buildingvine")#>Building Vine</option>
          </select>
        </div>
      </div>
      <div class="control-group">
        <label for="username"  class="control-label">Name</label>
        <div class="controls">
        	<input type="text" name="username" value="#rc.bug.getusername()#">
				</div>
      </div>
      <div class="control-group">
        <label for="username"  class="control-label">Email</label>
        <div class="controls">
        	<input type="text" name="email" value="#rc.bug.getemail()#">
				</div>
      </div>
      <div class="control-group">
        <label for="known_as"  class="control-label">System</label>
        <div class="controls">
        	<select name="system">
	          <option value="intranet" #vm(rc.bug.getsystem(),"intranet")#>Intranet</option>
	          <option value="buildingVine" #vm(rc.bug.getsystem(),"buildingVine")#>Building Vine</option>
	          <option value="merchantXtra" #vm(rc.bug.getsystem(),"merchantXtra")#>Merchant Xtra</option>
	        </select>
				</div>
      </div>
      <div class="control-group">
        <label for="known_as"  class="control-label">Site</label>
        <div class="controls">
        	<select name="site">
	          <option value="cbagroup" #vm(rc.bug.getsite(),"cbagroup")#>CBA Group</option>
	          <option value="handbgroup" #vm(rc.bug.getsite(),"handbgroup")#>h&b Group</option>
	          <option value="cemco" #vm(rc.bug.getsite(),"cemco")#>CEMCO</option>
            <option value="nbg" #vm(rc.bug.getsite(),"nbg")#>NBG</option>
	        </select>
				</div>
      </div>
      <cfelse>
        <input type="hidden" name="site" value="#getSetting("siteName")#" />
        <input type="hidden" name="system" value="intranet" />
        <input type="hidden" name="email" value="#rc.sess.bugs.username#" />
        <input type="hidden" name="username" value="#rc.sess.bugs.name#" />
      </cfif>
      <div class="control-group">
        <label for="name"  class="control-label">URL</label>
        <div class="controls">
        	<input size="30" type="text" name="url" id="url" value="#rc.bug.geturl()#" />
				</div>
      </div>
      <div class="control-group">
        <label for="description"  class="control-label">Type<em>*</em></label>
        <div class="controls">
        	<select name="type">
            <option #vm("Bug",rc.bug.gettype())# value="Bug">Bug</option>
            <option #vm("request",rc.bug.gettype())# value="request">Feature request</option>
            <option #vm("help",rc.bug.gettype())# value="help">support</option>
            <option #vm("general",rc.bug.gettype())# value="general">Other</option>
          </select>
				</div>
      </div>
    </fieldset>
    <fieldset>
      <legend>&nbsp; Extended Information &nbsp;</legend>
      <div class="control-group">
        <label for="description"  class="control-label">Priority</label>
        <div class="controls">
        	<select name="Priority">
            <option #vm(1,rc.bug.getPriority())# value="1">Important</option>
            <option #vm(2,rc.bug.getPriority())# value="2">Moderate</option>
            <option #vm(3,rc.bug.getPriority())# value="3">Not important</option>
          </select>
				</div>
      </div>
      <div class="control-group">
        <label for="description"  class="control-label">Status</label>
        <div class="controls">
        	<select name="status">
            <option #vm("open",rc.bug.getstatus())# value="open">Open</option>
            <option #vm("pending",rc.bug.getstatus())# value="pending">Pending Completion</option>
            <option #vm("closed",rc.bug.getstatus())# value="closed">Closed</option>
          </select>
				</div>
      </div>
    </fieldset>
    <div class="form-actions">      
      <input name="submit" class="btn btn-warning" type="submit" value="#IIF(rc.bug.getid() eq "", "'Create Ticket'","'Save Ticket'")#" />      
    </div>
		<input type="hidden" name="id" value="#rc.bug.getid()#">
  </form>
</cfoutput>