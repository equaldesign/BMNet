
<cfset getMyPlugin(plugin="jQuery").getDepends("validate","contact/edit")>

<cfoutput>

  <cfif rc.id eq 0><h2>Create new contact</h2></cfif>
  <form class="form form-horizontal" id="editContact" method="post" action="#bl('contact.doEdit')#">
  <input type="hidden" name="id" value="#rc.contact.id#">
  <p>Required fields are are denoted by <em>*</em></p>
    <fieldset>
      <legend>Contact Information</legend>
      <div class="control-group">
        <label for="name" class="control-label">First Name <em>*</em></label>
        <div class="controls">
          <input size="30" type="text" name="first_name" id="first_name" value="#rc.contact.first_name#" />
        </div>
      </div>
      <div class="control-group">
        <label for="surname" class="control-label">Surname<em>*</em></label>
        <div class="controls">
          <input size="30" type="text" name="surname" id="surname" value="#rc.contact.surname#" />
        </div>
      </div>
      <div class="control-group">
        <label for="tel" class="control-label">Phone</label>
        <div class="controls">
          <div class="input-prepend">
            <span class="add-on">
              <i class="icon-phone"></i>
            </span>
            <input size="30" type="text" name="tel" id="tel" value="#rc.contact.tel#" />
          </div>
        </div>
      </div>
      <div class="control-group">
        <label for="mobile" class="control-label">Mobile</label>
        <div class="controls">
          <div class="input-prepend">
            <span class="add-on">
              <i class="icon-mobile"></i>
            </span>
            <input size="30" type="text" name="mobile" id="mobile" value="#rc.contact.mobile#" />
          </div>
        </div>
      </div>
      <div class="control-group">
        <label for="email" class="control-label">Email 2</label>
        <div class="controls">
          <div class="input-prepend">
            <span class="add-on">
              <i class="icon-mail"></i>
            </span>
            <input size="30" type="text" name="email_2" id="email_2" value="#rc.contact.email_2#" />
          </div>
        </div>
      </div>
      <div class="control-group">
        <label for="email" class="control-label">Email 3</label>
        <div class="controls">
          <div class="input-prepend">
            <span class="add-on">
              <i class="icon-mail"></i>
            </span>
            <input size="30" type="text" name="email_3" id="email_3" value="#rc.contact.email_3#" />
          </div>
        </div>
      </div>
      <div class="control-group">
        <label for="mobile" class="control-label">Picture</label>
        <cfif isEmail(rc.contact.email)><img class="gravatar" src="http://www.gravatar.com/avatar/#lcase(Hash(lcase(rc.contact.email)))#?size=50&d=mm"></cfif> <a target="_blank" href="http://www.gravatar.com">update your picture at gravatar.com &raquo;</a>
      </div>
    </fieldset>
    #renderView(view="tags/create",args={relationship="contact",id="#rc.id#",delete=true})#
    <fieldset>
      <legend>Company information</legend>
      <cfif (rc.id eq 0 OR rc.contact.company_id eq "") OR isUserInRole("staff")>
      <div class="control-group">
        <label for="description" class="control-label">Company<em>*</em></label>
        <div class="controls">
          <select id="company_id" name="company_id">
            <cfloop query="rc.companies">
              <option #vm(id,rc.contact.company_id)# class="supplier" value="#id#">#name#</option>
            </cfloop>
          </select>
        </div>
      </div>
      <cfelseif rc.id eq 0 AND isUserInRole("supplier")>
      <div class="control-group">
        <label for="name" class="control-label">Company <em>*</em></label>
        <div class="controls">
          <p>#rc.sess.eGroup.companyknown_as#</p>
          <input type="hidden" name="company_id" value="#rc.sess.eGroup.companyID#" />
        </div>
      </div>
      </cfif>
      <cfif rc.id neq 0 AND rc.contact.company_id neq "" and rc.contact.eGroupUsername neq "">
      <div class="control-group">
        <label for="branchID" class="control-label">Based at Branch:</label>
        <div class="controls">
          <select id="branchID" name="branchID">
            <option value="0">-- Choose Branch --</option>
            <cfset branches = getModel("branch").getAll(rc.contact.company_id)>
            <cfloop query="branches">
            <option #vm(id,rc.contact.branchID)# value="#id#">#name#</option>
            </cfloop>
          </select>
        </div>
      </div>
      </cfif>
      <div class="control-group">
        <label for="jobTitle" class="control-label">Job Title</label>
        <div class="controls">
          <input size="30" type="text" name="jobTitle" id="jobTitle" value="#rc.contact.jobTitle#" />
        </div>
      </div>
    </fieldset>
    <fieldset>
      <legend>Login information</legend>
      <cfif canSeeEmail(rc.id,rc.contact.company_id)>
        <div class="control-group">
          <label for="email" class="control-label">Email<em>*</em></label>
          <div class="controls">
            <div class="input-prepend">
              <span class="add-on">
                <i class="icon-mail"></i>
              </span>
              <input size="30" type="text" name="email" id="email" value="#rc.contact.email#" />
            </div>
          </div>
        </div>
      </cfif>

      <cfset usergroups = request.groupService.securityGroups>
      <!--- only show CBA permissions if we're editing --->
      <cfif rc.id neq 0 AND rc.contact.company_id neq "">
        <cfif (rc.company.type_id eq 1 OR rc.company.type_id eq 3) and IsUserInRole("admin")>
          <div class="control-group #IIf(rc.id eq 0,"'hidden'","''")#" id="cbapermissions">
            <label for="email" class="control-label">#getSetting('groupName')# Permission<em>*</em></label>
            <div class="controls">
              <select name="permissions">
                  <option value="">--choose permission--</option>
                  <option value="#getModel('eunify.GroupsService').getGroupByName('view')#">view</option>
                  <cfif isUserInRole("ebiz")>
                  <option value="#getModel('eunify.GroupsService').getGroupByName('ebiz')#">ebiz</option>
                  </cfif>
              <cfloop array="#usergroups.group#" index="g">
                  <option #IIf(listFind(getModel('eunify.ContactService').getPermissions(rc.contact.id),g.id) gte 1,"'selected=selected'","''")# value="#g.id#">#g.name#</option>
              </cfloop>
              </select>
            </div>
          </div>
          <cfset simpleMode = getModel('eunify.GroupsService').getGroupByName('SimpleMode')>
          <cfif simpleMode neq 0>
            <div class="control-group">
              <label for="email" class="control-label">Enforce Simple Mode?</label>
              <div class="controls">
                <input size="30" type="text" name="simpleMode" id="simpleMode" #IIf(listFind(getModel('contact').getpermissionList(rc.contact.id),g.id) gte 1,"checked","''")# value="true" />
              </div>
            </div>
          </cfif>
        </cfif>
        <cfif (rc.company.type_id eq 1 and IsUserInRole("memberadmin")) AND rc.company.id eq rc.sess.eGroup.companyID>
        <div class="control-group #IIf(rc.id eq 0,"'hidden'","''")#" id="memberpermissions">
          <label for="email" class="control-label">Member Permission<em>*</em></label>
          <div class="controls">
            <select name="permissions">
                <option value="">--choose permission--</option>
            <cfloop array="#usergroups.members#" index="mg">
                <option #IIf(listFind(getModel('eunify.ContactService').getPermissions(rc.contact.id),mg.id) gte 1,"'selected=selected'","''")# value="#mg.id#">#mg.name#</option>
            </cfloop>
            </select>
          </div>
        </div>
        </cfif>
      </cfif>
      <cfif rc.id neq 0 AND rc.contact.company_id neq "">
      <cfif canSetPrivs("supplier") AND rc.company.type_id eq 2>
      <div  class="control-group #IIf(rc.id eq 0,"'hidden'","''")#" id="supplierpermissions">
        <label for="email" class="control-label">Supplier Permission<em>*</em></label>
        <div class="controls">
          <select name="permissions">
              <option value="">--choose permission--</option>
          <cfloop array="#usergroups.suppliers#" index="s">
              <option #IIf(listFind(getModel('eunify.ContactService').getPermissions(rc.contact.id),s.id) gte 1,"'selected=selected'","''")# value="#s.id#">#s.name#</option>
          </cfloop>
          </select>
        </div>
      </div>
      </cfif>
      </cfif>
      <cfif rc.id neq 0 AND rc.contact.company_id neq "" AND canSeeUserPassword(rc.id,rc.contact.company_id,rc.company.type_id)>
      <div class="control-group">
        <label for="email" class="control-label">Password<em>*</em></label>
        <div class="controls">
          <input size="30" type="text" name="password" id="password" value="#rc.contact.password#" />
        </div>
      </div>
      <cfelseif rc.id eq 0>
      <div class="control-group">
        <label for="sendPassword" class="control-label">Send Password?<em>*</em></label>
        <div class="controls">
          <input type="checkbox" name="emailLogin" id="emailLogin" value="true" />
        </div>
      </div>
      <div class="alert alert-info">
        <a href="##" class="close">&times;</a>
        <strong>Password Generation</strong>
        <p>A password for this user can be generated automatically and emailed to the supplied email address.</p>
        <p>They can then login and change this password to something more memorable.</p>
      </div>
      <div>
        <label for="setUpBuildingVine" class="control-label">Create Building Vine Account?</label>
        <div class="controls">
          <input type="checkbox" name="setUpBuildingVine" id="setUpBuildingVine" value="true" />
        </div>
      </div>
      </cfif>
    </fieldset>
    <cfif rc.id neq 0 AND rc.contact.company_id neq "">
      <cfif isUserInRole("ebiz")>
        <fieldset>
          <legend>Building Vine Information</legend>
          <cfif rc.contact.buildingvine>
            <!--- let them edit their building vine username and password --->
            <div class="control-group">
              <label for="bvusername" class="control-label">Building Vine Username<em>*</em></label>
              <div class="controls">
                <input size="30" type="text" name="bvusername" id="bvusername" value="#rc.contact.bvusername#" />
              </div>
            </div>
            <div class="control-group">
              <label for="bvpassword" class="control-label">Building Vine Password<em>*</em></label>
              <div class="controls">
                <input size="30" type="text" name="bvpassword" id="bvpassword" value="#rc.contact.bvpassword#" />
              </div>
            </div>
          <cfelse>
            <!--- they are not in Building Vine --->

            <cfif isBoolean(rc.company.buildingVine) AND rc.company.buildingvine>
              <h4>You do not have a Building Vine Account</h4>
              <p>You do not appear to have a Building Vine account, but your company, <strong>#rc.company.known_as#</strong> does.</p>
              <p>Would you like to be automatically set up as a registered user at <strong>#rc.company.known_as#</strong>?</p>
              <p>Registration is free - and you'll be up and running in a few seconds.</p>
              <input id="setupBV" rel="#rc.id#" type="button" class="btn btn-info" value="Set me up! &raquo;" />
              <!--- let them signup just themselves --->
            <cfelse>
              <!--- give them some sales spiel --->
            </cfif>
          </cfif>
        </fieldset>
      </cfif>
	  </cfif>
    <div class="form-actions">
      <input class="btn btn-success" type="submit" value="#IIF(rc.id eq 0, "'Create Contact'","'Save Contact'")# &raquo;" />
    </div>
  </form>
</cfoutput>
