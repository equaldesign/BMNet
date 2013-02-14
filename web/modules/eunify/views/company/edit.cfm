<cfset getMyPlugin(plugin="jQuery").getDepends("","","form")>
<cfoutput>
<h2><cfif rc.id eq 0>New #rc.type#<cfelse>Edit</cfif> </h2>
  <form class="form form-horizontal" action="/eunify/company/doEdit" method="post" id="createCustomer">
    <input type="hidden" name="id" value="#rc.id#" />
    <fieldset>
      <legend>Details</legend>
      <div class="control-group">
        <label class="control-label" for="type_id">Type<em>*</em></label>
        <div class="controls">
	        <select name="type_id">
	          <option #vm(1,rc.company.type_id)# value="1">Customer</option>
	          <option #vm(2,rc.company.type_id)# value="2">Supplier</option>
	        </select>
				</div>
      </div>
      <div class="control-group">
        <label class="control-label" for="account_number">Account Number</label>
        <div class="controls">
        	<input size="50" type="text" name="account_number" id="account_number" value="#rc.company.account_number#"/>
				</div>
      </div>
      <div class="control-group">
        <label class="control-label" for="name">Company Name<em>*</em></label>
        <div class="controls">
        	<input size="50" type="text" name="name" id="name" value="#rc.company.name#"/>
				</div>
      </div>
      <div class="control-group">
        <label class="control-label" for="known_as">Known As</label>
        <div class="controls">
          <input size="50" type="text" name="address" id="known_as" value="#rc.company.known_as#"/>
				</div>
      </div>
    </fieldset>
    <fieldset>
      <legend>Address Information</legend>
      <div class="control-group">
        <label class="control-label"l for="company_address_1">Address 1</label>
        <div class="controls">
        	<input size="50" type="text" name="company_address_1" id="company_address_1" value="#rc.company.company_address_1#"/>
				</div>
      </div>
      <div class="control-group">
        <label class="control-label" for="company_address_2">Address 2</label>
        <div class="controls">
        	<input size="50" type="text" name="company_address_2" id="company_address_2" value="#rc.company.company_address_2#"/>
				</div>
      </div>
      <div class="control-group">
        <label class="control-label" for="company_address_3">Address 3</label>
        <div class="controls">
        	<input size="50" type="text" name="company_address_3" id="company_address_3" value="#rc.company.company_address_3#"/>
				</div>
      </div>
      <div class="control-group">
        <label class="control-label" for="company_address_4">Town</label>
        <div class="controls">
        	<input size="50" type="text" name="company_address_4" id="company_address_4" value="#rc.company.company_address_4#"/>
				</div>
      </div>
      <div class="control-group">
        <label class="control-label" for="company_address_5">County</label>
        <div class="controls">
        	<input size="50" type="text" name="company_address_5" id="company_address_5" value="#rc.company.company_address_5#"/>
				</div>
      </div>
      <div class="control-group">
        <label class="control-label" for="company_postcode">Post Code</label>
        <div class="controls">
        	<input size="50" type="text" name="company_postcode" id="company_postcode" value="#rc.company.company_postcode#"/>
				</div>
      </div>
    </fieldset>
    <cfif rc.id eq 0>
    <fieldset>
      <legend>&nbsp; Default Company Contact &nbsp;</legend>
      <br />
			<div class="alert">
        <a href="##" class="close">&times;</a>
        <strong>Default contact information</strong></p>
        <p>As you are creating a new company, a new contact for this
        company will also need to be created</p>
        <p>A password for this user will be generated automatically and emailed to the supplied email address.</p>
        <p>They can then login and change this password to something more memorable.</p>
      </div>
      <div class="control-group">
        <label for="default_contact_firstname" class="control-label">Contact first name <em>*</em></label>
        <div class="controls">
          <input size="30"  type="text" name="default_contact_firstname" id="default_contact_firstname" value="" />
				</div>
      </div>
      <div class="control-group">
        <label for="default_contact_surname" class="control-label">Contact surname <em>*</em></label>
        <div class="controls">
        	<input size="30"  type="text" name="default_contact_surname" id="default_contact_surname" value="" />
				</div>
      </div>
      <div class="control-group">
        <label for="default_contact_email" class="control-label">Contact email <em>*</em></label>
        <div class="controls">
        	<input size="30"  type="text" name="default_contact_email" id="default_contact_email" value="" />
				</div>
      </div>
      <div class="control-group">
        <label for="default_contact_tel" class="control-label">Contact Telephone</label>
        <div class="controls">
        	<input size="50"  type="text" name="default_contact_tel" id="default_contact_tel" value="" />
				</div>
      </div>
      <div class="control-group">
        <label for="sendLogin" class="control-label">Create User and send Login info?</label>
        <div class="controls">
          <input type="checkbox" name="sendLogin" id="sendLogin" checked="checked" value="true" />
        </div>
      </div>
    </fieldset>
    </cfif>
    <fieldset>
      <legend>Compay Contact Information</legend>
      <cfif rc.company.id neq "">
      <div class="control-group">
        <label for="email" class="control-label">Default Contact</label>
        <div class="controls">
	        <select name="contact_id">
	          <option value="0">None</option>
	          <cfloop query="rc.contacts">
	          <option #vm(id,rc.company.contact_id)# value="#id#">#first_name# #surname#</option>
	          </cfloop>
	        </select>
				</div>
      </div>
      </cfif>
      <div class="control-group">
        <label class="control-label" for="known_as">Phone</label>
        <div class="controls">
        	<input size="50" type="text" name="company_phone" id="company_phone" value="#rc.company.company_phone#"/>
				</div>
      </div>
      <div class="control-group">
        <label class="control-label" for="phoneAlternate">Phone Alt.</label>
        <div class="controls">
        	<input size="15" type="text" name="company_phone_2" id="company_phone_2" value="#rc.company.company_phone_2#" />
				</div>
      </div>
      <div class="control-group">
        <label class="control-label" for="known_as">Fax</label>
        <div class="controls">
        	<input size="50" type="text" name="company_fax" id="company_fax" value="#rc.company.company_fax#"/>
				</div>
      </div>
      <div class="control-group">
        <label class="control-label" for="known_as">Email</label>
        <div class="controls">
        	<input size="50" type="text" name="company_email" id="company_email" value="#rc.company.company_email#"/>
				</div>
      </div>
      <div class="control-group">
        <label class="control-label" for="known_as">Website</label>
        <div class="controls">
          <input size="50" type="text" name="company_website" id="company_website" value="#rc.company.company_website#"/>
				</div>
      </div>
    </fieldset>
    <fieldset>
      <legend>&nbsp; Building Vine&trade; integration &nbsp;</legend>
      <div class="control-group">
        <label for="buildingVine" class="control-label">In Building Vine?</label>
        <div class="controls">
        	<input type="checkbox" id="inbuildingVine" name="inbuildingVine" value="true" #IIF(isBoolean(rc.company.buildingVine) AND rc.company.buildingVine,"'checked=checked'","''")# />
				</div>
      </div>
      <div class="control-group">
        <label for="bvsiteid" class="control-label">Building Vine Site ID</label>
        <div class="controls">
        	<select name="bvsiteid">
	          <option value="">--select--</option>
	          <cfloop array="#rc.bvSites#" index="s">
	          <option #vm(s.shortName,rc.company.bvsiteid)# value="#s.shortName#">#s.title#</option>
	          </cfloop>
	        </select>
        </div>
      </div>
    </fieldset>
    <cfif request.eGroup.datasource neq "">
      
    
    <fieldset>
      <legend>&nbsp; eGroup Integration &nbsp;</legend>
      <div class="control-group">
        <label for="eGroup_id" class="control-label">eGroup ID</label>
        <div class="controls">
        	<select name="eGroup_id">
	          <option value="0">--select--</option>
	          <cfloop query="rc.eGroupCompanies">
	          <option #vm(id,rc.company.eGroup_id)# value="#id#">#name#</option>
	          </cfloop>
	        </select>
				</div>
      </div>
    </fieldset>
    </cfif>
    <fieldset>
      <legend>&nbsp; Social Networking Integration &nbsp;</legend>
      <div class="control-group">
        <label for="twitter_username" class="control-label">Twitter Username</label>
        <div class="controls">
        	<input type="text" value="#rc.company.twitter_username#" name="twitter_username" id="twitter_username" />
				</div>
      </div>
    </fieldset>
    <input type="submit" class="btn btn-success" value="<cfif rc.id eq 0>Create New<cfelse>Edit</cfif> Company" />
  </form>
</cfoutput>
