<cfoutput>
<div class="realtd">
  <div class="psaObjectID">#UCase(rc.component.id.XmlText)#</div><div class="psaObjectKey">#UCase(rc.component.title.XmlText)#&nbsp;</div>
  <div class="psaObjectValue">
      <div>
      <cfif rc.component.XmlAttributes.type  eq "meta">
        <!--- it's just meta --->
        #fixBullets(rc.component.details.XmlText)#
      <cfelse>
        #fixBullets(rc.component.details.XmlText)#
        <!--- it's a rebate of some kind --->
			  <cfset isStepped = false>
			  <cftry>
        <cfif (ListFind("individual,individualgrowth,groupgrowth,stepped",rc.component.rebateType.xmlAttributes.name) neq 0 OR (StructKeyExists(rc.component,"step") AND IsXmlElem(rc.component.step)))>
			    <cfset isStepped = true>
			  </cfif>
			  <cfcatch type="any"></cfcatch>
			  </cftry>
        <cfif isStepped>
        <cfif NOT isDefined('rc.component.inputsources.xmlAttributes.id')>
		      <cfset inputSource = 0>
		    <cfelse>
		      <cfset inputSource = rc.component.inputsources.xmlAttributes.id>
		    </cfif>
        <cfset inputStruct = getModel("psa").getFiguresEntryElementsFromList(inputSource)>
		    <cfset inputUnitType = getUType(inputStruct.inputTypeID,rc.component.rebateType.xmlAttributes.name)>
		    <cfset outputUnitType = getUnitType2(rc.component.outputtype.XmlText)>
        <cfif isDefined('rc.component.step')>
          <cfset steps = rc.component.step>
        <cfelse>
          <cfset steps = []>
        </cfif>
          <cfif inputStruct.recordCount gte 1 AND ArrayLen(steps) gt 0>
          <table>
            <tr>
              <th class="rightalign">From</th>
              <th class="rightalign">To</th>
              <th class="rightalign">Value</th>
            </tr>
            <cfloop from="1" to="#ArrayLen(steps)#" index="st">
              <cftry>
              <tr>
                <td class="rightalign" nowrap="nowrap" width="100"><cfif inputUnitType.showBefore eq 1>#inputUnitType.name# <span>#NumberFormatIfNumber(steps[st].from.XmlText,"9,999,999")#</span><cfelse><span  >#NumberFormatIfNumber(steps[st].from.XmlText,"9,999,999")#</span>#inputUnitType.name# </cfif></td>
                <td class="rightalign" nowrap="nowrap" width="100"><cfif inputUnitType.showBefore eq 1>#inputUnitType.name# <span>#NumberFormatIfNumber(steps[st].to.XmlText,"9,999,999")#</span><cfelse><span >#NumberFormatIfNumber(steps[st].to.XmlText,"9,999,999")#</span>#inputUnitType.name# </cfif></td>
                <td class="rightalign" nowrap="nowrap" width="75"><cfif outputUnitType.showBefore eq 1>#outputUnitType.name# <span>#steps[st].value.XmlText#</span><cfelse><span  >#steps[st].value.XmlText#</span> #outputUnitType.name#</cfif></td>
              </tr>
              <cfcatch type="any">
              <tr>
                <td colspan="3"></td>
              </tr>
              </cfcatch>
              </cftry>
            </cfloop>
          </table>
          </cfif>
        </cfif>
      </cfif>
      </div>
    </form>
  </div>
  <div class="clearer"></div>
</div>
</cfoutput>