<cfset arrangement = getModel("psa")>
<cfset element = getRebateElement(arrangement.getPSA(rc.figuresPeriod.psaID).getDealData(),xmlID)>
<cfset dFrom = rc.figuresPeriod.periodFrom>
 <cfset dTo = rc.figuresPeriod.periodTo>
 <cfset inputTypeSource = getUnitType2(arrangement.getFiguresEntryElementsFromList(element.inputSources.xmlattributes.id).inputTypeID)>
 <cfset inputTypePayable = getUnitType2(arrangement.getFiguresEntryElementsFromList(element.outputsources.xmlattributes.id).inputTypeID)>
 <cfset outputType = getUnitType2(element.outputtype.XmlText)>
 <cfoutput>
          <table class="v tableCloth">
            <thead>
              <tr>
        <th>#getSetting('groupName')# Member</th>
        <th class="tc">Turnover</th>
        <th class="tc">Rebate</th>
        <th class="tc">Paid</th>
        <th class="tc">Payable</th>
        <th class="tc">#outputtype.name#</th>
        <th class="tc">Est. Turnover</th>
        <th class="tc">Est. Rebate</th>
        <th class="tc">Est. #outputtype.name#</th>
      </tr>
      </thead>
      <tbody>
    <cfset throughputTotal = 0>
    <cfset rebateTotal = 0>
    <cfset payableTotal = 0>
        <cfset OTETotal = 0>
        <cfset OTErebateTotal = 0>
        <cfloop query="rc.figuresPeriod">

        <tr class="#IIF(memberID eq rc.sess.eGroup.companyID,"'highlightMember'","''")#">
        <td nowrap>#left(known_as,20)#</td>
        <td class="tr" nowrap="nowrap"><cfif inputTypeSource.showBefore eq 1>#inputTypeSource.name#</cfif>#Trim(NumberFormat(throughput,"999,999,999.00"))#<cfif inputTypeSource.showBefore eq 0>#inputTypeSource.name#</cfif></td>
        <td class="tr" nowrap="nowrap">
          <cfif outputtype.isPer eq 0>
            <!--- we need the input type --->
            <cfif inputTypePayable.showBefore eq 1>#inputTypePayable.name#</cfif>#Trim(NumberFormat(rebateAmount,"999,999,999.00"))#<cfif inputTypePayable.showBefore eq 0>#inputTypePayable.name#</cfif>
          <cfelse>
            <cfif outputtype.showBefore eq 1>#outputtype.name#</cfif>#Trim(NumberFormat(rebateAmount,"999,999,999.00"))#<cfif outputtype.showBefore eq 0>#outputtype.name#</cfif>
          </cfif>
        </td>
        <td class="tr" nowrap="nowrap"><cfif DateCompare(now(),dTo) gte 1 AND memberID eq rc.sess.eGroup.companyID and paramVal('element.payableTo.xmlText','group') eq "member"><input type="checkbox" class="markpaid" rel="#id#" #vm('true',paid,"checkbox")# /><cfelse><cfif paid eq "true"><img class="tooltip" title="Member has been paid" src="/images/icons/152.png"><cfelseif paid eq "holding"><img class="tooltip" title="Supplier has paid" src="/images/icons/154.png"><cfelse><img class="tooltip" title="Supplier has not paid" src="/images/icons/151.png"></cfif></cfif></td>
        <td class="tr" nowrap="nowrap">
          <cfif outputtype.isPer eq 0>
            <cfif inputTypePayable.showBefore eq 1>#inputTypePayable.name#</cfif>#Trim(NumberFormat(rebatePayable,"999,999,999.00"))#<cfif inputTypePayable.showBefore eq 0>#inputTypePayable.name#</cfif>
          <cfelse>
            <cfif outputtype.showBefore eq 1>#outputtype.name#</cfif>#Trim(NumberFormat(rebatePayable,"999,999,999.00"))#<cfif outputtype.showBefore eq 0>#outputtype.name#</cfif>
          </cfif>
        </td>
        <td class="tr" nowrap="nowrap"><cfif outputType.showBefore eq 1>#outputType.name#</cfif>#Trim(NumberFormat(rebateValue,"999,999,999.00"))#<cfif outputType.showBefore eq 0>#outputType.name#</cfif></td>
        <td class="tr" nowrap="nowrap"><cfif inputTypeSource.showBefore eq 1>#inputTypeSource.name#</cfif>#Trim(NumberFormat(OTETHROUGHPUT,"999,999,999.00"))#<cfif inputTypeSource.showBefore eq 0>#inputTypeSource.name#</cfif></td>
        <td class="tr" nowrap="nowrap">
          <cfif outputtype.isPer eq 0>
            <cfif inputTypePayable.showBefore eq 1>#inputTypePayable.name#</cfif>#Trim(NumberFormat(OTEPayable,"999,999,999.00"))#<cfif inputTypePayable.showBefore eq 0>#inputTypePayable.name#</cfif>
          <cfelse>
            <cfif outputtype.showBefore eq 1>#outputtype.name#</cfif>#Trim(NumberFormat(OTEPayable,"999,999,999.00"))#<cfif outputtype.showBefore eq 0>#outputtype.name#</cfif>
          </cfif>
        </td>
        <td class="tr" nowrap="nowrap"><cfif outputType.showBefore eq 1>#outputType.name#</cfif>#Trim(NumberFormat(OTEValue,"999,999,999.00"))#<cfif outputType.showBefore eq 0>#outputType.name#</cfif></td>
        </tr>
        <cfset throughputTotal = throughputTotal + throughput>
        <cfset rebateTotal = rebateTotal + rebateAmount>
        <cfset payableTotal = payableTotal + rebatePayable>
        <cfset OTETotal = OTETotal + OTETHROUGHPUT>
        <cfset OTErebateTotal = OTErebateTotal + OTEPayable>
      </cfloop>
      </tbody>
      <tfoot>
      <tr>
          <th class="tr">TOTAL</th>
        <th class="tr" nowrap="nowrap"><cfif inputTypeSource.showBefore eq 1>#inputTypeSource.name#</cfif>#Trim(NumberFormat(throughputTotal,"999,999,999.00"))#<cfif inputTypeSource.showBefore eq 0>#inputTypeSource.name#</cfif></th>
        <th class="tr" nowrap="nowrap">
          <cfif outputtype.isPer eq 0>
            <cfif inputTypePayable.showBefore eq 1>
                #inputTypePayable.name#
            </cfif>
            #Trim(NumberFormat(rebateTotal,"999,999,999.00"))#
            <cfif inputTypePayable.showBefore eq 0>
                #inputTypePayable.name#
            </cfif>
          <cfelse>
            <cfif outputType.showBefore eq 1>
                #outputType.name#
            </cfif>
            #Trim(NumberFormat(rebateTotal,"999,999,999.00"))#
            <cfif outputType.showBefore eq 0>
                #outputType.name#
            </cfif>
          </cfif>
        </th>
        <th><cfif DateCompare(now(),dTo) gte 1 AND paramVal('element.payableTo.xmlText','group') eq "group"><input type="checkbox" class="markpaid" value="psaID_#rc.psaID#-xmlID_#xmlID#-periodName_#periodName#" <cfif paid eq "true" OR paid eq "holding">checked="checked"</cfif> /></cfif></th>
        <th class="tr" nowrap="nowrap">
        <cfif outputtype.isPer eq 0>
          <cfif inputTypePayable.showBefore eq 1>#inputTypePayable.name#</cfif>#Trim(NumberFormat(payableTotal,"999,999,999.00"))#<cfif inputTypePayable.showBefore eq 0>#inputTypePayable.name#</cfif>
        <cfelse>
            <cfif outputtype.showBefore eq 1>#outputtype.name#</cfif>#Trim(NumberFormat(payableTotal,"999,999,999.00"))#<cfif outputtype.showBefore eq 0>#outputtype.name#</cfif>
          </cfif>
        </th>

              <th class="tr">EST.</th>
              <th class="tr" nowrap="nowrap"><cfif inputTypeSource.showBefore eq 1>#inputTypeSource.name#</cfif>#Trim(NumberFormat(OTETotal,"999,999,999.00"))#<cfif inputTypeSource.showBefore eq 0>#inputTypeSource.name#</cfif></th>
              <th class="tr" nowrap="nowrap" >
                <cfif outputtype.isPer eq 0>
                  <cfif inputTypePayable.showBefore eq 1>
                      #inputTypePayable.name#
                  </cfif>
                  #Trim(NumberFormat(OTErebateTotal,"999,999,999.00"))#
                  <cfif inputTypePayable.showBefore eq 0>
                      #inputTypePayable.name#
                  </cfif>
                <cfelse>
                   <cfif outputType.showBefore eq 1>
                      #outputType.name#
                  </cfif>
                  #Trim(NumberFormat(OTErebateTotal,"999,999,999.00"))#
                  <cfif outputType.showBefore eq 0>
                      #outputType.name#
                  </cfif>
                </cfif>
              </th>
              <th></th>
      </tr>
      </tfoot>
        </table>
</cfoutput>