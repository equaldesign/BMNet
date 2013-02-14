<cfoutput>#getMyPLugin("jQuery").getDepends("tipsy,validate","psa/editElement")#</cfoutput>
<div class="form-signUp">
<cfoutput>
<form id="elementForm" action="#bl('psa.editElementDo')#" method="post">
<input type="hidden" name="index" value="#rc.index#" />
<input type="hidden" name="funct" value="#rc.funct#" />
<input type="hidden" name="psaID" value="#rc.psaID#" />
<input type="hidden" id="cType" name="cType" value="#rc.element.xmlAttributes.type#" />
<input type="hidden" id="cGroup" name="cGroup" value="#rc.cgroup#" />
  <fieldset>
    <legend>Basic Information</legend>
    <div>
      <label rel="#bl('help','topic=uniqueID')#" class="o">ID <em>*</em></label>
      <input class="helptip" title="The ID of this element. It's important to make sure this is unique" id="cid" size="4" value="#paramVal('rc.element.id.xmlText','')#" type="text" name="cid" />
    </div>
    <div>
      <label class="o" rel="#bl('help','topic=name')#">Title <em>*</em></label>
      <input class="helptip" title="The name of this rebate element (eg. Annual rebate, or Quarterly Rebate)" id="ctitle" value="#paramVal('rc.element.title.xmlText','')#" type="text" name="ctitle" />
    </div>
    <div>
      <label class="o" rel="#bl('help','topic=description')#">Description</label>
      <div class="extracontainer">
        <textarea cols="10" class="helptip ckeditor" title="A description on this rebate element - add in here any additional informaiton about this particular rebate element that users may find useful"  name="details">#paramVal('rc.element.details.xmlText','')#</textarea>
      </div>
    </div>
  </fieldset>
  <fieldset>
      <legend>Access</legend>
      <div>
        <label class="o" rel="#bl('help','topic=permissions')#">Permissions</label>
        <select id="permissions" name="permissions">
          <option #vm(paramVal('rc.element.XmlAttributes.permissions','none'),"none")# value="none">--all--</option>
          <cfset gL = rc.groups.fullGroupList(rc.sess.eGroup.companyID)>
          <cfloop query="gL">
            <option #vm(paramVal('rc.element.XmlAttributes.permissions','view'),"#name#")# value="#name#"> #name# </option>
          </cfloop>
        </select>
      </div>
    </fieldset>
    <div class="controlset">
      <div>
      <input class="doIt" type="submit" value="Save Element" name="submit" />
      </div>
    </div>
  </form>
</div>
    </cfoutput>