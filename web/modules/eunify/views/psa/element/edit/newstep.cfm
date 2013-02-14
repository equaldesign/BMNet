<cfoutput>
  <cfif NOT isDefined('rc.element.inputsources.xmlAttributes.id')>
          <cfset inputSource = 0>
        <cfelse>
          <cfset inputSource = rc.element.inputsources.xmlAttributes.id>
        </cfif>
<tr id="tr_#fixdot(rc.id)#_#ArrayLen(rc.element.step)#">
  <td nowrap="nowrap" valign="top"><a href="##" class="tooltip deleteStep" title="Delete this Step"><img src="/images/icons/cross-circle-frame.png" border="0" /></a><a href="##" class="tooltip editStep" title="Edit this Step"><img src="/images/icons/blog--pencil.png" border="0" /></a></td>
  <td class="rightalign" nowrap="nowrap" width="100"><cfif #getUnitType2(getModel("psa").getFiguresEntryElementsFromList(inputSource).inputTypeID).name# eq "&pound;">#getUnitType2(getModel("psa").getFiguresEntryElementsFromList(inputSource).inputTypeID).name# <span rel="#rc.step.from.XmlText#" class="from">#NumberFormatIfNumber(rc.step.from.XmlText,"9,999,999")#</span><cfelse><span rel="#rc.step.from.XmlText#" class="from">#NumberFormatIfNumber(rc.step.from.XmlText,"9,999,999")#</span>#getUnitType2(getModel("psa").getFiguresEntryElementsFromList(inputSource).inputTypeID).name# </cfif></td>
  <td class="rightalign" nowrap="nowrap" width="100"><cfif #getUnitType2(getModel("psa").getFiguresEntryElementsFromList(inputSource).inputTypeID).name# eq "&pound;">#getUnitType2(getModel("psa").getFiguresEntryElementsFromList(inputSource).inputTypeID).name# <span rel="#rc.step.to.XmlText#" class="to">#NumberFormatIfNumber(rc.step.to.XmlText,"9,999,999")#</span><cfelse><span rel="#rc.step.to.XmlText#" class="to">#NumberFormatIfNumber(rc.step.to.XmlText,"9,999,999")#</span>#getUnitType2(getModel("psa").getFiguresEntryElementsFromList(inputSource).inputTypeID).name# </cfif></td>
  <td class="rightalign" nowrap="nowrap" width="75"><cfif #getUnitType2(rc.element.outputtype.XmlText).name# eq "&pound;">#getUnitType2(rc.element.outputtype.XmlText).name# <span rel="#rc.step.value.XmlText#"  class="value">#rc.step.value.XmlText#</span><cfelse><span rel="#rc.step.value.XmlText#" class="value">#rc.step.value.XmlText#</span> #getUnitType2(rc.element.outputtype.XmlText).name#</cfif></td>
  <td class="editStepButtonTD"></td>
</tr>
</cfoutput>