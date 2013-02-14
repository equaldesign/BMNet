<cfset getMyPlugin(plugin="jQuery").getDepends("validate","contact/edit")>

<cfoutput>
<div class="form-signUp">
	<cfif rc.id eq 0><h2>Create new contact</h2></cfif>
	<form class="form" id="editContact" method="post" action="#bl('contact.doEdit')#">
	<input type="hidden" name="id" value="#rc.contact.getid()#">
	<p>Required fields are are denoted by <em>*</em></p>
	  <fieldset>
		  <legend>Contact Information</legend>
		  <div>
		    <label for="name" class="o">First Name <em>*</em></label>
		    <input size="30" type="text" name="first_name" id="first_name" value="#rc.contact.getfirst_name()#" />
		  </div>
		  <div>
		    <label for="surname" class="o">Surname<em>*</em></label>
		    <input size="30" type="text" name="surname" id="surname" value="#rc.contact.getsurname()#" />
		  </div>
		  <div>
		    <label for="tel" class="o">Phone</label>
		    <input size="30" type="text" name="tel" id="tel" value="#rc.contact.gettel()#" />
		  </div>
		  <div>
		    <label for="mobile" class="o">Mobile</label>
		    <input size="30" type="text" name="mobile" id="mobile" value="#rc.contact.getmobile()#" />
		  </div>
		  <div>
		    <label for="mobile" class="o">Picture</label>
		    <cfif isEmail(rc.contact.getemail())><img class="gravatar" src="http://www.gravatar.com/avatar/#lcase(Hash(lcase(rc.contact.getemail())))#?size=50&d=mm"></cfif> <a target="_blank" href="http://www.gravatar.com">update your picture at gravatar.com &raquo;</a>
		  </div>
		</fieldset>
		<fieldset>
			<legend>Company information</legend>
			<cfif IsUserInRole("superusers") OR (rc.id eq 0 AND isUserInRole("member"))>
			<div>
				<label for="description" class="o">Company<em>*</em></label>
		    <select id="company_id" name="company_id">
		    	<option value="0">-- Members --</option>
					<cfif isUserInRole("member")>
						<cfif isUserInRole("superusers")>
						<cfloop query="rc.members">
							<option #vm(id,rc.contact.getcompany_id())# class="member" value="#id#">#known_as#</option>
						</cfloop>
						<cfelse>
							<option class="member" value="#rc.sess.eGroup.companyID#">#rc.sess.eGroup.companyknown_as#</option>
						</cfif>
					</cfif>
					<option value="0">-- Suppliers --</option>
					<cfloop query="rc.suppliers">
						<option #vm(id,rc.contact.getcompany_id())# class="supplier" value="#id#">#known_as#</option>
					</cfloop>
          <cfif isUserInRole("admin")>
          <option value="0">-- Both --</option>
          <cfloop query="rc.both">
            <option #vm(id,rc.contact.getcompany_id())# class="supplier" value="#id#">#known_as#</option>
          </cfloop>
          </cfif>
				</select>
			</div>
			<cfelseif rc.id eq 0 AND isUserInRole("supplier")>
				<label for="name" class="o">Company <em>*</em></label>
				<p>#rc.sess.eGroup.companyknown_as#</p>
				<input type="hidden" name="company_id" value="#rc.sess.eGroup.companyID#" />
			</cfif>
      <cfif rc.id neq 0>
      <div>
        <label for="branchID" class="o">Based at Branch:</label>
        <select id="branchID" name="branchID">
          <option value="0">-- Choose Branch --</option>
          <cfset branches = getModel("branch").getAll(rc.contact.getcompany_id())>
          <cfloop query="branches">
          <option #vm(id,rc.contact.getbranchID())# value="#id#">#name#</option>
          </cfloop>
        </select>
      </div>
      </cfif>
			<div>
		    <label for="jobTitle" class="o">Job Title</label>
		    <input size="30" type="text" name="jobTitle" id="jobTitle" value="#rc.contact.getjobTitle()#" />
		  </div>
		</fieldset>
		<fieldset>
			<legend>Login information</legend>
			<cfif canSeeEmail(rc.id,rc.contact.getcompany_id())>
				<div>
			    <label for="email" class="o">Email<em>*</em></label>
			    <input size="30" type="text" name="email" id="email" value="#rc.contact.getemail()#" />
			  </div>
        <div>
          <label for="localUser" class="o">Local UserName</label>
          <input size="30" type="text" name="localUser" id="localUser" value="#rc.contact.getlocalUser()#" />
        </div>
			</cfif>
			<cfset usergroups = getSetting("securityGroups")>
			<!--- only show CBA permissions if we're editing --->
			<cfif rc.id neq 0>
				<cfif (rc.company.gettype_id() eq 1 OR rc.company.gettype_id() eq 3) and IsUserInRole("admin")>
					<div class="#IIf(rc.id eq 0,"'hidden'","''")#" id="cbapermissions">
				    <label for="email" class="o">#getSetting('groupName')# Permission<em>*</em></label>
				    <select name="permissions">
                  <option value="">--choose permission--</option>
                  <cfif isUserInRole("ebiz")>
                  <option value="#getModel('groups').getGroupByName('ebiz')#">ebiz</option>
                  </cfif>
							<cfloop array="#usergroups.group#" index="g">
									<option #IIf(listFind(rc.contact.getpermissions(),g.id) gte 1,"'selected=selected'","''")# value="#g.id#">#g.name#</option>
							</cfloop>
						</select>
					</div>
          <cfset simpleMode = getModel('groups').getGroupByName('SimpleMode')>
          <cfif simpleMode neq 0>
            <div>
              <label for="email" class="o">Enforce Simple Mode?</label>
              <input size="30" type="text" name="simpleMode" id="simpleMode" #IIf(listFind(rc.contact.getpermissions(),g.id) gte 1,"checked","''")# value="true" />
            </div>
          </cfif>
				</cfif>
  			<cfif rc.company.gettype_id() eq 1 and IsUserInRole("memberadmin") AND rc.company.getid() eq rc.sess.eGroup.companyID>
  			<div class="#IIf(rc.id eq 0,"'hidden'","''")#" id="memberpermissions">
  		    <label for="email" class="o">Member Permission<em>*</em></label>
  		    <select name="permissions">
                <option value="">--choose permission--</option>
  					<cfloop array="#usergroups.members#" index="g">
  							<option #IIf(listFind(rc.contact.getpermissions(),g.id) gte 1,"'selected=selected'","''")# value="#g.id#">#g.name#</option>
  					</cfloop>
  				</select>
  			</div>
  			</cfif>
			</cfif>
			<cfif rc.id neq 0>
			<cfif canSetPrivs("supplier") AND rc.company.gettype_id() eq 2>
			<div class="#IIf(rc.id eq 0,"'hidden'","''")#" id="supplierpermissions">
		    <label for="email" class="o">Supplier Permission<em>*</em></label>
		    <select name="permissions">
              <option value="">--choose permission--</option>
					<cfloop array="#usergroups.suppliers#" index="s">
							<option #IIf(listFind(rc.contact.getpermissions(),s.id) gte 1,"'selected=selected'","''")# value="#s.id#">#s.name#</option>
					</cfloop>
				</select>
			</div>
			</cfif>
			</cfif>
			<cfif rc.id neq 0 AND canSeeUserPassword(rc.id,rc.contact.getcompany_id(),rc.company.gettype_id())>
		  <div>
		    <label for="email" class="o">Password<em>*</em></label>
		    <input size="30" type="text" name="password" id="password" value="#rc.contact.getpassword()#" />
		  </div>
			<cfelseif rc.id eq 0>
      <div>
        <label for="sendPassword" class="o">Send Password?<em>*</em></label>
        <input type="checkbox" name="sendPassword" id="sendPassword" value="true" />
      </div>
      <div style="padding: 0pt 0.7em;" class="ui-state-highlight ui-corner-all">
        <p><span style="float: left; margin-right: 0.3em;" class="ui-icon ui-icon-alert"></span>
        <strong>Password Generation</strong></p>
        <p>A password for this user can be generated automatically and emailed to the supplied email address.</p>
        <p>They can then login and change this password to something more memorable.</p>
      </div>
			</cfif>
		</fieldset>
    <cfif rc.id neq 0>
      <cfif rc.id eq rc.sess.eGroup.contactID OR isUserInRole("ebiz")>
        <fieldset>
          <legend>Building Vine Information</legend>
          <cfif rc.contact.getbuildingvine()>
            <!--- let them edit their building vine username and password --->
            <div>
              <label for="bvusername" class="o">Building Vine Username<em>*</em></label>
              <input size="30" type="text" name="bvusername" id="bvusername" value="#rc.contact.getbvusername()#" />
            </div>
            <div>
              <label for="bvpassword" class="o">Building Vine Password<em>*</em></label>
              <input size="30" type="text" name="bvpassword" id="bvpassword" value="#rc.contact.getbvpassword()#" />
            </div>
          <cfelse>
            <!--- they are not in Building Vine --->
            <cfif rc.company.getbuildingvine()>
              <h4>You do not have a Building Vine Account</h4>
              <p>You do not appear to have a Building Vine account, but your company, <strong>#rc.company.getknown_as()#</strong> does.</p>
              <p>Would you like to be automatically set up as a registered user at <strong>#rc.company.getknown_as()#</strong>?</p>
              <p>Registration is free - and you'll be up and running in a few seconds.</p>
              <input id="setupBV" rel="#rc.id#" type="button" class="doIt silverbg submit" value="Set me up! &raquo;" />
              <!--- let them signup just themselves --->
            <cfelse>
              <!--- give them some sales spiel --->
            </cfif>
          </cfif>
        </fieldset>
      </cfif>
    <cfif rc.company.gettype_id() neq 2>
    <fieldset>
      <Legend>Notification Areas</Legend>
      <div>
        <label for="sendDigest" class="o">Send Daily Digest?<em>*</em></label>
        <input type="checkbox" id="sendDigest" name="sendDigest" value="true" #vm(rc.contact.getsendDigest(),true,"checkbox")# />
      </div>
      <div>
        <label for="sendImmediate" class="o">Send Updates Immediately?<em>*</em></label>
        <input type="checkbox" id="sendImmediate" name="sendImmediate" value="true" #vm(rc.contact.getsendImmediate(),true,"checkbox")# />
      </div>
      <div>
        <label for="notification" class="o">Update me about</label>
        <select id="interests" name="interests" multiple="true">
          <cfset bTeams = rc.groups.getCommittees(true)>
          <cfloop query="bTeams">
            <option <cfif rc.contact.userInterest(rc.contact.getid(),id)>selected</cfif> value="#id#">#name#</option>
          </cfloop>
        </select>
      </div>
      <div>
        <label for="importance" class="o">When update level is</label>
        <select name="importance" multiple="multiple">
          <option value="1" #vm(1,rc.contact.getPrefence(rc.contact.getid(),1))#>1 Very Important</option>
          <option value="2" #vm(2,rc.contact.getPrefence(rc.contact.getid(),2))#>2 Important</option>
          <option value="3" #vm(3,rc.contact.getPrefence(rc.contact.getid(),3))#>3 Price Lists</option>
          <option value="4" #vm(4,rc.contact.getPrefence(rc.contact.getid(),4))#>4 Promotions and Offers</option>
          <option value="5" #vm(5,rc.contact.getPrefence(rc.contact.getid(),5))#>5 Minor Adjustments</option>
        </select>
      </div>
    </fieldset>
    </cfif>
    </cfif>
	  <div class="rightControlSet">
	    <div>
	    <input class="doIt" type="submit" value="#IIF(rc.id eq 0, "'Create Contact'","'Save Contact'")# &raquo;" />
	    </div>
	  </div>
	</form>
</div>
</cfoutput>
