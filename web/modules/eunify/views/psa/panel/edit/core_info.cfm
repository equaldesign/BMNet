<cfset getMyPlugin(plugin="jQuery").getDepends("","psa/edit")>
<cfset arrangement = getModel("psa")>
<cfoutput>

<!--- warning for confirmed agreements --->
<cfif rc.panelData.psa.PSA_status eq "confirmed">
	<div class="alert alert-danger">
		<a href="##" data-dismiss="alert" class="close">&times;</a>
		<strong>Alert:</strong> Warning! This Agreement is confirmed. Any changes could corrupt figures that have already been entered by suppliers!</p>
	</div>
</cfif>

<div class="alert">
	<a href="##" data-dismiss="alert" class="close">&times;</a>
	<cfswitch expression="#rc.panelData.psa.originated_from#">
		<cfcase value="blank">
		This Agreement was created from a blank (advanced) template.</p>
		</cfcase>
		<cfcase value="clone">
			<cfset clone_a = arrangement.getArrangement(rc.panelData.psa.originating_id)>
			This Agreement was clone from <a href="/psa/index/id/#clone_a.id#">#clone_a.id# #clone_a.name#.</a></p>
		</cfcase>
		<cfcase value="template">
	    <cfset temp_a = arrangement.getTemplate(rc.panelData.psa.originating_id)>
	    This Agreement was created using the #temp_a.name# template.</p>
		</cfcase>
	</cfswitch>
</div>

<form id="coreInfo" class="form form-horizontal" action="/psa/edit/psaID/#rc.panelData.psa.id#" method="post">
<p>Required fields are are denoted by <em>*</em></p>

<!--- core information --->
<fieldset>
	<legend>Core Information</legend>

	<!--- agreement ID --->
	<div class="control-group">
  	<label class="control-label" for="id">Agreement ID <em>*</em></label>
		<div class="controls">
		 <input id="id" class="helptip input-mini" title="You shouldn't need to change this value" type="text" name="id" value="#rc.panelData.psa.id#" />
		</div>
	</div>

	<!--- private agreement only --->
	<div class="control-group">
		<label class="control-label" for="memberID">#rc.sess.eGroup.companyknown_as# only</label>
    <div class="controls">
    	<label class="checkbox">
			 <input class="tooltip" title="check this box if this deal if for your company only" type="checkbox" #vm(rc.sess.eGroup.companyID,rc.panelData.psa.memberID,"checkbox")# name="memberID" value="#rc.sess.eGroup.companyID#" />
			 Check this box if this deal is private (i.e for your company only).
		  </label>
		</div>
  </div>

	<!--- email follow up comments? --->
	<div class="control-group">
    <label class="control-label">Email follow ups</label>
    <div class="controls">
    	<label class="checkbox">
    	  <input type="checkbox" name="notify" value="true" #vm(getModel("subscriptions").subscriptionExists(getModel("subscriptions").getSubscriptionID(rc.panelData.psa.id,"arrangement"),rc.sess.eGroup.contactID),true,"checkbox")#" />
			  Should the negotiator be sent emails when people discuss this agreement?
		  </label>
		</div>
  </div>

	<!--- supplier --->
	<div class="control-group">
		<label class="control-label" for="company_id">Supplier<em>*</em></label>
		<div class="controls">
			<select name="company_id" id="company_id">
				<cfset compList = rc.panelData.supplierList>
				<option value="">-- Choose a company --</option>
				<cfloop query="compList">
					<option #vm(id,rc.panelData.psa.company_id)# value="#id#">#UCASE(left(name,40))#</option>
				</cfloop>
			</select>
		</div>
		<!--- <input id="newSupplier" type="button" value="new &raquo;" /><input id="refreshSuppliers" type="button" class="hidden" value="refresh &raquo;" /> --->
	</div>

	<!--- negotiator --->
	<div class="control-group">
		<label class="control-label" for="">Negotiator <em>*</em></label>
		<div class="controls">
				<select name="contact_id" id="contact_id">
				<cfset contacts = rc.panelData.MemberContacts>
				<cfloop query="contacts">
					<option #vm(id,rc.panelData.psa.contact_id)# value="#id#">#first_name# #surname#</option>
				</cfloop>
			</select>
		</div>
	</div>

	<!--- current status of agreement --->
	<div class="control-group">
		<label class="control-label" for="psa_status">Agreement Status</label>
		<div class="controls">
			<select name="psa_status" id="psa_status">
				<option #vm('negotiator',rc.panelData.psa.PSA_status)# value="negotiator" > -- with negotiator --</option>
				<option #vm('moderator',rc.panelData.psa.PSA_status)# value="moderator" > -- with moderator --</option>
				<option #vm('supplier',rc.panelData.psa.PSA_status)# value="supplier" > -- with supplier --</option>
				<option #vm('confirmed',rc.panelData.psa.PSA_status)# value="confirmed" > -- confirmed --</option>
			</select>
		</div>
	</div>

	<!--- category the agreement should belong to (multiple is ok) --->
	<div class="control-group">
		<label class="control-label" for="buyingTeamID">PSA Category <em>*</em></label>
		<div class="controls">
				<select multiple="true" name="buyingTeamID" id="buyingTeamID">
				<!--- TODO <cfset buyingTeam = arrangement.getBuyingTeam('building')> --->
				<option value="">-- choose a PSA category --</option>
				<cfset groups = getModel("groupService")>
				<cfset bTeams = groups.getCommittees(true)>
				<cfloop query="bTeams">
					<cfif IsUserInAnyRole("egroup_admin,egroup_edit,egroup_#name#")>
						<option #vml(valueList(rc.panelData.psaCategories.categoryID),id)# value="#id#">#name#</option>
					</cfif>
				</cfloop>
			</select>
		</div>
	</div>

	<!--- Notice required for price changes - this goes into the automatically generated Terms and conditions --->
	<div class="control-group">
		<label class="control-label" for="priceperiod">Price Change Notice</label>
    <div class="controls">
	    <select name="priceperiod" class="span1" id="priceperiod">
		    <option #vm(30,rc.panelData.psa.priceperiod)# value="30">30</option>
		    <option #vm(60,rc.panelData.psa.priceperiod)# value="60">60</option>
		    <option #vm(90,rc.panelData.psa.priceperiod)# value="90">90</option>
		    <option #vm(120,rc.panelData.psa.priceperiod)# value="120">120</option>
	    </select>
			<p class="help-block">The price change notice is the amount of notice (in days) the supplier must provide the group before changing prices. This variable is used in the automatically generated terms and conditions for the agreement</p>
		</div>
	</div>
</fieldset>
#renderView(view="security/permissions",args={permissions=rc.permissions})#
#renderView(view="tags/create",args={relationship="arrangement",id="#rc.psaid#",delete=true})#
<!--- signed by etc --->
<cfif rc.panelData.psa.PSA_status eq "confirmed"> <!--- only show this information once the agreement is confirmed --->
<fieldset>
	<legend>Signatory Information</legend>

	<!--- supplier signatory --->
	<div class="control-group">
		<label class="control-label" for="signedbysupplier">Supplier Signatory</label>
		<div class="controls">
			<input title="Who from the supplier's company has signed this agreement off?" class="helptip" type="text" name="signedbysupplier" value="#rc.panelData.psa.signedbysupplier#" />
		</div>
	</div>

	<!--- supplier signatory position --->
	<div class="control-group">
		<label class="control-label" for="signedbyposition">Supplier Signatory Position</label>
		<div class="controls">
			<input class="helptip" title="What is the position of the person that signed this deal off from the supplier's company?" type="text" name="signedbyposition" value="#rc.panelData.psa.signedbyposition#" />
		</div>
	</div>

	<!--- date supplier signed the agreement --->
  <div class="control-group">
		<label class="control-label" for="signedbysupplierdate">Supplier Signatory Date</label>
		<div class="controls">
			<div class="input-prepend">
				<span class="add-on"><img src="https://d25ke41d0c64z1.cloudfront.net/images/icons/calendar.png"></span><input type="text" id="signedbysupplierdate" name="signedbysupplierdate" size="10" class="input-small date" value="#DateFOrmat(rc.panelData.psa.signedbysupplierdate,"DD/MM/YYYY")#" />
			</div>
		</div>
	</div>

	<!--- who signed the agreement from the group --->
	<div class="control-group">
		<label class="control-label" for="signedbygroup">#getSetting('groupName')# Signatory</label>
		<div class="controls">
			<input type="text" name="signedbygroup" value="#rc.panelData.psa.signedbygroup#" />
		</div>
	</div>
</fieldset>
</cfif>

<!--- product information and keywords --->
<fieldset>
	<legend>Product details</legend>

	<!--- product range this agreement covers --->
	<div class="control-group">
		<label class="control-label" for="name">Product Range<em>*</em></label>
		<div class="controls">
			<textarea class="helptip" title="The products covered in this deal - if the deal covers all products from this supplier, then say that" name="name" id="name">#rc.panelData.psa.name#</textarea>
		</div>
	</div>

	<!--- keywords for search purposes --->
	<div class="control-group">
		<label class="control-label" for="keywords">Keywords</label>
		<div class="controls">
			<textarea class="helptip" title="any words that may not come under the product range above that people may use to try and find this agreement" name="keywords" id="keywords">#rc.panelData.psa.keywords#</textarea>
		</div>
	</div>
</fieldset>

<!--- deal dates --->
<fieldset>
	<legend>Deal Duration and type</legend>
	<!--- type of agreement --->
	<div class="control-group">
		<label class="control-label" for="deal_type_id">Deal Type</label>
		<div class="controls">
			<select name="deal_type_id" id="deal_type_id">
			<cfloop query="rc.panelData.dealTypes">
				<option #vm(id,rc.panelData.psa.deal_type_id)# value="#id#">#desc#</option>
			</cfloop>
			</select>
		</div>
	</div>

	<!--- start date of the agreement --->
	<div class="control-group">
		<label class="control-label" for="period_from">Deal Start Date <em>*</em></label>
		<div class="controls">
      <div class="input-prepend">
      	<span class="add-on"><img src="https://d25ke41d0c64z1.cloudfront.net/images/icons/calendar.png" /></span><input id="period_from" type="text" name="period_from" class="input-small date" value="#DateFormat(rc.panelData.psa.period_from,"DD/MM/YYYY")#">
			</div>
		</div>
	</div>

	<!--- end date of the agreement --->
	<div class="control-group">
		<label class="control-label" for="period_to">Deal End Date <em>*</em></label>
		<div class="controls">
			<div class="input-prepend">
			 <span class="add-on"><img src="https://d25ke41d0c64z1.cloudfront.net/images/icons/calendar.png"></span><input id="period_to" type="text" name="period_to" class="input-small date" value="#DateFormat(rc.panelData.psa.period_to,"DD/MM/YYYY")#">
			</div>
		</div>
	</div>
</fieldset>

<!--- Participation --->
<fieldset>
	<legend>Participation</legend>

	<!--- participation type --->
	<div class="control-group">
		<label class="control-label" for="participation">Participation</label>
		<div class="controls">
      <select class="span1" name="participation">
        <option #vm(rc.panelData.psa.participation,"all")# value="all">All</option>
        <option #vm(rc.panelData.psa.participation,"inclusive")# value="inclusive">Inclusive (Includes only the following members)</option>
        <option #vm(rc.panelData.psa.participation,"exclusive")# value="exclusive">Exclusive (Excludes the following members)</option>
      </select>
	  </div>
	</div>

	<!--- who can / cannot participate --->
	<div class="control-group">
		<label class="control-label" for="membersParticipating">Members</label>
		<div class="controls">
			<select style="width:387px;" name="membersParticipating" multiple="multiple">
				<cfloop query="rc.panelData.memberList">
					<option value="#id#" #arrangement.isInParticipatingList(id,rc.panelData.participatingMembers)#>#name#</option>
				</cfloop>
			</select>
		</div>
	</div>
</fieldset>
<div class="form-actions">
  <input class="btn btn-success" type="submit" value="Save PSA &raquo;" />

</div>
</form>
</cfoutput>
