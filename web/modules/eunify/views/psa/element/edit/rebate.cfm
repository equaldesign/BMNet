<cfoutput>#getMyPLugin("jQuery").getDepends("tipsy,validate","psa/editElement")#</cfoutput>
<div class="form-signUp">
<cfform id="elementForm" action="#bl('psa.editElementDo')#" method="post">
<cfoutput>
<cfinput type="hidden" name="index" value="#rc.index#" />
<cfinput type="hidden" name="funct" value="#iif(paramVal('rc.element.title.xmlText',0) eq 0,"'add'","'edit'")#" />
<cfinput type="hidden" name="psaID" value="#rc.psaID#" />
<cfinput type="hidden" name="cgroup" value="#rc.cgroup#" />
<cfinput type="hidden" id="cType" name="cType" value="#rc.element.xmlAttributes.type#" />
	<fieldset>
		<legend>Basic Information</legend>
		<div>
			<label rel="#bl('help','topic=uniqueID')#" class="o">ID <em>*</em></label>
			<cfinput class="helptip" title="The ID of this element. It's important to make sure this is unique" id="cid" size="4" value="#paramVal('rc.element.id.xmlText','')#" type="text" name="cid" />
		</div>
		<div>
			<label class="o" rel="#bl('help','topic=name')#">Title <em>*</em></label>
			<cfinput class="helptip" title="The name of this rebate element (eg. Annual rebate, or Quarterly Rebate)" id="ctitle" value="#paramVal('rc.element.title.xmlText','')#" type="text" name="ctitle" />
		</div>
		<div>
			<label class="o" rel="#bl('help','topic=description')#">Description</label>
			<div class="extracontainer">
				<cftextarea cols="10" class="helptip ckeditor" title="A description on this rebate element - add in here any additional informaiton about this particular rebate element that users may find useful"  name="details">#paramVal('rc.element.details.xmlText','')#</cftextarea>
			</div>
		</div>
	</fieldset>
  <fieldset>
    <legend>Rebate Information</legend>
      <div>
          <label class="o">Rebate type</label>
          <cfselect name="rebateType" id="rebateType">
            <option id="type_standard" #vmb(paramVal('rc.element.rebateType.xmlAttributes.name','standard'),"standard","select")# value="standard">Guaranteed</option>
            <option id="type_standard" #vmb(paramVal('rc.element.rebateType.xmlAttributes.name','standard'),"stepped","select")# value="stepped">Stepped/Targetted</option>
            <option id="type_individual" #vmb(paramVal('rc.element.rebateType.xmlAttributes.name','standard'),"individual","select")# value="individual">Individual Target</option>
            <option id="type_groupgrowth" #vmb(paramVal('rc.element.rebateType.xmlAttributes.name','standard'),"groupgrowth","select")# value="groupgrowth">Group Growth</option>
            <option id="type_individualgrowth" #vmb(paramVal('rc.element.rebateType.xmlAttributes.name','standard'),"individualgrowth","select")# value="individualgrowth">Individual Growth</option>
          </cfselect>
      </div>
      <div id="rebate_target_psa" style="#IIf(paramVal('rc.element.rebateType.xmlAttributes.name','') eq "groupgrowth" OR paramVal('rc.element.rebateType.xmlAttributes.name','') eq "individualgrowth","'display: block'","'display: none'")#">
        <cfif isDefined('rc.element.rebateType.target') AND (rc.element.rebateType.xmlAttributes.name eq "groupgrowth" OR rc.element.rebateType.xmlAttributes.name eq "individualgrowth")>
          <cfif isDefined('rc.element.rebateType.target.xmlAttributes.Name')>
            <cfset targetName = rc.element.rebateType.target.xmlAttributes.name>
          <cfelse>
            <cfset targetName = "">
          </cfif>
          <cfset targetID = rc.element.rebateType.target.xmlAttributes.id>
          <cfif targetID eq "">
            <cfset targetID = 0>
          </cfif>
          <cfset targetElements = rc.element.rebateType.target.xmlAttributes.figures>
          <cfset targetElementPossibilities = rc.psaOb.getFiguresEntryElements(targetID)>
          <cfset targetFrom = rc.element.rebateType.target.xmlAttributes.dateFrom>
          <cfset targetTo = rc.element.rebateType.target.xmlAttributes.dateTo>
        <cfelse>
          <cfset targetID = "">
          <cfset targetElements = "">
          <cfset targetElementPossibilities = QueryNew("id, inputTypeID, inputName, description, display")>
          <cfset targetFrom = "">
          <cfset targetName = "">
          <cfset targetTo = "">
        </cfif>
        <div>
          <label class="o">Target Deal</label>
          <cfinput class="helptip" title="The agreement on which to base the growth" type="hidden" id="targetID" name="targetID" value="#targetID#" />
          <cfinput class="helptip" title="The agreement on which to base the growth" type="text" id="targetName" name="targetName" value="#targetName#" />
        </div>
        <div>
          <label class="o">Target Input Streams</label>
          <cfselect multiple="true" name="targetElements" id="targetElements">
            <cfloop query="targetElementPossibilities">
              <option value="#id#" #vml(targetElements,id)#>#inputName#</option>
            </cfloop>
          </cfselect>
        </div>
        <div>
          <label class="o">Date From</label>
          <cfinput class="datePicker" value="#targetFrom#" type="text" id="growthDateFrom" name="growthDateFrom" />
        </div>
        <div>
          <label class="o">Date To</label>
          <cfinput class="datePicker" value="#targetTo#" type="text" id="growthDateTo" name="growthDateTo" />
        </div>
      </div>
      <div>
          <label class="o">Payable To</label>
          <cfselect name="payableTo" id="payableTo">
            <option id="payable_group" #vmb(paramVal('rc.element.payableTo.xmlText','group'),"group","select")# value="group">Group</option>
            <option id="payable_member" #vmb(paramVal('rc.element.payableTo.xmlText','group'),"member","select")# value="member">Member</option>
          </cfselect>
      </div>
  </fieldset>
	<fieldset>
		<legend>Rebate Calculations</legend>
				<div id="rebatevaluediv" style="#IIf(paramVal('rc.element.rebateType.xmlAttributes.name','standard') eq "standard","'display: block'","'display: none'")#">
					<label class="o" rel="#bl('help','topic=rebatevalue')#">Rebate Value</label>
					<cfinput id="value" class="psa_id" value="#paramVal('rc.element.value.xmlText','')#" type="text" name="value" />
				</div>
				<div>
					<label class="o" rel="#bl('help','topic=nonretrospective')#">Non Retrospective?</label>
					<cfinput id="nonretrospective" name="nonretrospective" type="checkbox" checked="#vmb(paramVal('rc.element.nonretrospective.xmlText',''),"true","checkbox")#" value="true" />
				</div>
			<div>
				<label class="o" rel="#bl('help','topic=outputtype')#">Output Type</label>
				<cfset Ots = getTypes()>
				<cfselect id="outputtype" name="outputtype">
				<cfloop query="Ots">
					<option #vmb(paramVal('rc.element.outputtype.xmlText','6'),id)# value="#id#">#type#</option>
				</cfloop>
				</cfselect>
			</div>
			<div>
				<label class="o" rel="#bl('help','topic=calculate')#">Calculate</label>
				<div class="extracontainer">
					<div>
						<cfinput id="calculateY" checked="#vmb(paramVal('rc.element.calculate.xmlText','true'),'true','checkbox')#" type="radio" name="calculate" value="true" />
						<label>Yes</label>
					</div>
					<div>
						<cfinput id="calculateN" checked="#vmb(paramVal('rc.element.calculate.xmlText',''),'false','checkbox')#" type="radio" name="calculate" value="false" />
						<label>No</label>
					</div>
				</div>
			</div>

			<div>
	      <label class="o">Input Stream</label>
	      <div class="extracontainer">
	        <div>
	          <cfselect multiple="true" name="inputSource" id="inputSource">

	            <cfloop query="rc.fe">
	              <option value="#id#" #vml(paramVal('rc.element.inputSources.xmlAttributes.id',''),id)#>#inputName# (#display#)<cfif streamPSAID neq rc.psaID> | #Year(period_from)#-#streamPSAID#</cfif></option>
	            </cfloop>
	          </cfselect>
	        </div>
	      </div>
      </div>
			<div>
        <label class="o">Payable on</label>
        <div class="extracontainer">
          <div>
            <cfselect multiple="true" name="outputSource" id="outputSource">
              <cfloop query="rc.fe">
                <option value="#id#" #vml(paramVal('rc.element.outputSources.xmlAttributes.id',''),id)#>#inputName# (#display#)<cfif streamPSAID neq rc.psaID> | #Year(period_from)#-#streamPSAID#</cfif></option>
              </cfloop>
            </cfselect>
          </div>
        </div>
      </div>
			<div>
				<label class="o">Compound?</label>
				<div class="extracontainer">
					<div>
						<cfinput onclick="showCompounds(false);" checked="#vmb(paramVal('rc.element.compound.xmlText','false'),"false","checkbox")#" type="radio" name="compound" value="false" />
						<label class="d" rel="#bl('help','topic=standalone')#">False <span class="help">(Rebate payments are not effected by other rebates)</span>:</label>
					</div>
					<div>
						<cfinput onclick="showCompounds(true);" checked="#vmb(paramVal('rc.element.compound.xmlText','false'),"true","checkbox")#" type="radio" name="compound" value="true" />
						<label class="d" rel="#bl('help','topic=compound')#">True <span class="help">(Rebate payments from the selected elements below, should be taken away from this payment)</span>:</label>
					</div>
					<div>
						<cfscript>
	              xpathExp = "//component[calculate='true']";
	              rebateNodes = XMLSearch(rc.xml,xpathExp);
	          </cfscript>
						<cfselect multiple="true" name="compoundAgainst" id="compoundAgainst">
							<cfif isDefined('rc.element.compound.XmlAttributes.compoundAgainst')>
								<cfset compoundAgainst = rc.element.compound.XmlAttributes.compoundAgainst>
								<cfelse>
								<cfset compoundAgainst = 0>
							</cfif>
							<cfloop from="1" to="#ArrayLen(rebateNodes)#" index="i">
								<cfset xmlID = "#rebateNodes[i].id.XmlText#">
								<cfset xmlTtitle = "#rebateNodes[i].title.XmlText#">
								<option #vml(compoundAgainst,xmlID)# value="#xmlID#">#xmlID#:#xmlTtitle#</option>
							</cfloop>
						</cfselect>
					</div>
				</div>
			</div>
      <div>
        <label class="o">Strung?</label>
        <div class="extracontainer">
          <div>
            <cfselect name="strung" id="strung">
                #vmb(paramVal('rc.element.rebateType.xmlAttributes.name','standard'),"standard","select")#
                <option #vmb(paramVal('rc.element.strung.xmlText','false'),"false","select")# value="false">False</option>
                <option #vmb(paramVal('rc.element.strung.xmlText','false'),"input","select")# value="input">Input Turnover</option>
                <option #vmb(paramVal('rc.element.strung.xmlText','false'),"output","select")# value="output">Output Turnover</option>
                <option #vmb(paramVal('rc.element.strung.xmlText','false'),"both","select")# value="both">Input &amp; Output Turnover</option>
            </cfselect>
          </div>
          <div>
            <label class="d" rel="#bl('help','topic=compound')#">Strung against:</label>
          </div>
          <div>
            <cfscript>
                xpathExp = "//component[calculate='true']";
                rebateNodes = XMLSearch(rc.xml,xpathExp);
            </cfscript>
            <cfselect multiple="true" name="strungAgainst" id="strungAgainst">
              <cfif isDefined('rc.element.strung.XmlAttributes.strungAgainst')>
                <cfset strungAgainst = rc.element.strung.XmlAttributes.strungAgainst>
                <cfelse>
                <cfset strungAgainst = 0>
              </cfif>
              <cfloop from="1" to="#ArrayLen(rebateNodes)#" index="i">
                <cfset xmlID = "#rebateNodes[i].id.XmlText#">
                <cfset xmlTtitle = "#rebateNodes[i].title.XmlText#">
                <option #vml(strungAgainst,xmlID)# value="#xmlID#">#xmlID#:#xmlTtitle#</option>
              </cfloop>
            </cfselect>
          </div>
        </div>
      </div>
      <cfif NOT isDefined('rc.element.XmlAttributes.editable') OR rc.element.XmlAttributes.editable eq "true">
			<div>
				<label class="o" rel="#bl('help','topic=period')#">Payment period</label>
				<div class="extracontainer">
					<div>
						<cfinput checked="#vmb(paramVal('rc.element.period.xmlText','monthly'),"monthly","checkbox")#" type="radio" name="paymentperiod" value="monthly" />
						<label>Monthly</label>
					</div>
          <div>
            <cfinput checked="#vmb(paramVal('rc.element.period.xmlText','bimonthly'),"bimonthly","checkbox")#" type="radio" name="paymentperiod" value="bimonthly" />
            <label>Two Monthly</label>
          </div>
					<div>
						<cfinput checked="#vmb(paramVal('rc.element.period.xmlText',''),"quarterly","checkbox")#" type="radio" name="paymentperiod" value="quarterly" />
						<label>Quarterly</label>
					</div>
					<div>
						<cfinput checked="#vmb(paramVal('rc.element.period.xmlText',''),"sixmonth","checkbox")#" type="radio" name="paymentperiod" value="sixmonth" />
						<label>Six Monthly</label>
					</div>
					<div>
						<cfinput checked="#vmb(paramVal('rc.element.period.xmlText',''),"annual","checkbox")#" type="radio" name="paymentperiod" value="annual" />
						<label>Annually</label>
					</div>
					<div>
						<cfinput checked="#vmb(paramVal('rc.element.period.xmlText',''),"biannual","checkbox")#" type="radio" name="paymentperiod" value="biannual" />
						<label>2 Yearly</label>
					</div>
				</div>
			</div>
      </cfif>
		</fieldset>
		<fieldset>
			<legend>Rebate Restrictions</legend>
			<div>
				<label class="o" rel="#bl('help','topic=dateresdiviction')#">Date Restriciton?</label>
				<cfinput id="dateRange" name="dateRange" type="checkbox" checked="#vmb(paramVal('rc.element.dateRange.xmlText',''),"true","checkbox")#" value="true" />
				<div>
					<label class="o">Date From</label>
					<cfinput id="dateFrom" class="datePicker" value="#DateFormat(paramVal('rc.element.dateRange.XmlAttributes.dateFrom',''),'DD/MM/YYYY')#" type="text" name="dateFrom" />
				</div>
				<div>
					<label class="o">Date To</label>
					<cfinput id="dateTo" class="datePicker" value="#DateFormat(paramVal('rc.element.dateRange.XmlAttributes.dateTo',''),'DD/MM/YYYY')#" type="text" name="dateTo" />
				</div>
			</div>
			<div>
				<label class="o" rel="/help?topic=memberrestriction">Member Restriciton?</label>
				<cfinput id="memberRestrictions" name="memberRestrictions" type="checkbox" checked="#vmb(paramVal('rc.element.memberRestrictions.xmlText',''),"true","checkbox")#" value="true" />
			</div>
			<div>
				<label class="o">Members Participating</label>
				<cfselect size="5" multiple="true" name="membersParticipating" id="membersParticipating">
				<cfloop query="rc.memberList">
					<option value="#id#" #IIf(listFind(paramVal('rc.element.memberRestrictions.XmlAttributes.MEMBERSPARTICIPATING',''),id) gte 1,"selected='selected'","")#>#name#</option>
				</cfloop>
				</cfselect>
			</div>

		</fieldset>
		<fieldset>
			<legend>Access</legend>
			<div>
				<label class="o" rel="#bl('help','topic=permissions')#">Permissions</label>
				<cfselect id="permissions" name="permissions">
					<option selected="#vmb(paramVal('rc.element.XmlAttributes.permissions','none'),"none")#" value="none">--all--</option>
					<cfset gL = rc.groups.fullGroupList(rc.sess.eGroup.companyID)>
					<cfloop query="gL">
						<option #vmb(paramVal('rc.element.XmlAttributes.permissions','rebates'),"#name#")# value="#name#"> #name# </option>
					</cfloop>
				</cfselect>
			</div>
		</fieldset>
		</cfoutput>
	  <div class="controlset">
	    <div>
	    <cfinput name="submit" class="doIt" type="submit" value="Save Element" />
	    </div>
	  </div>
	</cfform>
</div>

