<cfoutput>
<div id="#rc.component.xmlAttributes.type#_#fixdot(rc.component.id.xmlText)#" class="realtd">
  <div id="psaObjectEditControls">
    <a name="#rc.component.xmlAttributes.type#_#fixdot(rc.component.id.xmlText)#"></a>
    <div class="psaObjectIcon">
      <cfif NOT isDefined('rc.component.XmlAttributes.editable') OR rc.component.XmlAttributes.editable eq "true">
        <img class="handle" title="move the element by dragging up or down" src="/images/icons/arrow-move.png" border="0" style="cursor: move;" />
      <cfelse>
       <img class="tooltip" title="you cannot move this element" src="/images/icons/arrow-move--disabled.png" border="0" style="cursor: disabled;" />
      </cfif>
    </div>
    <div class="psaObjectIcon">
      <cfif NOT isDefined('rc.component.XmlAttributes.editable') OR rc.component.XmlAttributes.editable eq "true">
        <a class="noAjax tooltip deleteComponent"  rel="#rc.component.id.xmlText#" href="javascript:void(0);" title="Delete this Element"><img src="/images/icons/cross-circle-frame.png" border="0" /></a>
      <cfelse>
        <img class="tooltip" title="You cannot delete this element" src="/images/icons/cross-circle-frame--disabled.png" border="0" />
      </cfif>
    </div>
    <div class="psaObjectIcon">
      <a class="noAjax tooltip editComponent" href="javascript:void(0);" rel="#rc.psaID#" rev="#rc.component.id.XmlText#" title="Edit this Element"><img src="/images/icons/blog--pencil.png" border="0" /></a>
    </div>
    <div class="psaObjectIcon">
      <a class="noAjax tooltip cloneComponent" href="javascript:void(0);" rel="#rc.psaID#" rev="#fixdot(rc.component.id.XmlText)#" title="Clone this Element"><img src="/images/icons/blogs.png" border="0" /></a>
    </div>
  </div>
  <div class="psaObjectID">#rc.component.id.XmlText#</div><div class="psaObjectKey">#rc.component.title.XmlText#</div>
  <div class="psaObjectValue">
<cfif rc.component.XmlAttributes.type  eq "meta">
  <!--- it's just meta --->
  #ParagraphFormat2(rc.component.details.XmlText)#
<cfelse>
  #ParagraphFormat2(rc.component.details.XmlText)#
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
    <cfif inputStruct.recordCount gte 1>
    <table>
      <tr>
        <th></th>
        <th class="rightalign">From</th>
        <th class="rightalign">To</th>
        <th class="rightalign">value</th>
        <th></th>
      </tr>
      <cfloop from="1" to="#ArrayLen(steps)#" index="st">

        <tr id="tr_#fixdot(rc.component.id.xmlText)#_#st#">
          <td nowrap="nowrap" valign="top"><a href="##" class="tooltip deleteStep" title="Delete this Step"><img src="/images/icons/cross-circle-frame.png" border="0" /></a><a href="##" class="tooltip editStep" title="Edit this Step"><img src="/images/icons/blog--pencil.png" border="0" /></a></td>
          <cftry>
          <td class="rightalign" nowrap="nowrap" width="100"><cfif inputUnitType.showBefore eq 1>#inputUnitType.name# <span rel="#steps[st].from.XmlText#" class="from">#NumberFormatIfNumber(steps[st].from.XmlText,"9,999,999.99")#</span><cfelse><span rel="#steps[st].from.XmlText#" class="from">#NumberFormatIfNumber(steps[st].from.XmlText,"9,999,999")#</span>#inputUnitType.name# </cfif></td>
          <td class="rightalign" nowrap="nowrap" width="100"><cfif inputUnitType.showBefore eq 1>#inputUnitType.name# <span rel="#steps[st].to.XmlText#" class="to">#NumberFormatIfNumber(steps[st].to.XmlText,"9,999,999.99")#</span><cfelse><span rel="#steps[st].to.XmlText#" class="to">#NumberFormatIfNumber(steps[st].to.XmlText,"9,999,999")#</span>#inputUnitType.name# </cfif></td>
          <td class="rightalign" nowrap="nowrap" width="75"><cfif outputUnitType.showBefore eq 1>#outputUnitType.name# <span rel="#steps[st].value.XmlText#"  class="value">#steps[st].value.XmlText#</span><cfelse><span rel="#steps[st].value.XmlText#" class="value">#steps[st].value.XmlText#</span> #outputUnitType.name#</cfif></td>
          <td class="editStepButtonTD"></td>
          <cfcatch type="any">
            <td colspan="4">No input/output selected</td>
          </cfcatch>
          </cftry>
        </tr>
      </cfloop>

      <tr id="tr_#fixdot(rc.component.id.xmlText)#">
        <td></td>
        <td>#getUnitType2(getModel("psa").getFiguresEntryElementsFromList(inputSource).inputTypeID).name# <input size="6" type="text" class="from" id="from_#fixdot(rc.component.id.xmlText)#" /></td>
        <td>#getUnitType2(getModel("psa").getFiguresEntryElementsFromList(inputSource).inputTypeID).name# <input size="6" type="text" class="to" id="to_#fixdot(rc.component.id.xmlText)#" /></td>
        <td><input type="text" size="3" class="value" id="value_#fixdot(rc.component.id.xmlText)#" />#getUnitType2(rc.component.outputtype.XmlText).name#</td>
        <td><a href="##" class="tooltip doAddStep" title="Add new step" ><img src="/images/icons/plus-circle-frame.png" border="0" /></a></td>
      </tr>
    </table>
    </cfif>

  </cfif>
</cfif>
  </div>
  <div class="clearer"></div>
</div>
</cfoutput>