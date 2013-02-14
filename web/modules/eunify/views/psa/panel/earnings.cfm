<cfset getMyPlugin(plugin="jQuery").getDepends("","psa/earnings,psa/payments")>
<cfset arrangement = getModel("psa")>
<cfset showRecalc = true>

<cfif rc.layout neq "PDFview">
  <cfif isDate(rc.panelData.calcStatus.timestarted)>

    <cfif DateDiff("n",rc.panelData.calcStatus.timestarted,DateConvert('local2utc',now())) gt 1>
      <cfoutput>
      <div class="Aristo ui-widget">
        <div style="margin: 10px 0px; padding: 0pt 0.7em;" class="ui-state-error ui-corner-all">
          <p>
          <span class="ui-icon ui-icon-alert" style="float: left; margin-right: .3em;"></span><strong>Error!: a calculation job was started for this agreement, and it hasn't updated for #DateDiff("s",rc.panelData.calcStatus.timestarted,now())# seconds (it reached #rc.panelData.calcStatus.percent#% completion).</strong>
          </p>
          <p>This is an excessive calculation lag time, and therefore it is likely an error occurred trying to calculate the rebates.</p>
          <p>If some rebate elements were calculated correctly, they have been displayed below.</p>
          <p>Rebate calculations are done in cronalogical order, so the problem rebate element will be the one AFTER the last succesfully calculated rebate element.</p>
          <p>You will need to modify thisrebate element and try recalculating.
          </p>
        </div>
      </div>
      </cfoutput>
    </cfif>
  </cfif>
  <div class="Aristo ui-widget">
    <div style="margin: 10px 0px; padding: 0pt 0.7em;" class="ui-state-highlight ui-corner-all">
      <cfoutput><br />
      <cfif NOT isDate(rc.panelData.calcStatus.timestarted) or DateDiff("n",rc.panelData.calcStatus.timestarted,DateConvert('local2utc',now())) gt 1>
      <a id="#rc.psaID#" class="noAjax recalculate" href="##"><img hspace="3" border="0" align="left" src="/images/icons/calculator--plus.png"/> recalculate figures</a>
      <br class="clear" /><br />
      <cfelse>
      <span class="ui-icon ui-icon-alert" style="float: left; margin-right: .3em;"></span><strong>Calculation in progress! a calculation is already in progress which was last updated <span id="timeUpdated">#DateDiff("s",rc.panelData.calcStatus.timestarted,now())#</span> seconds ago.</strong>
      <cfset getMyPlugin(plugin="jQuery").getDepends("","figures/calculation")>
      <div style="margin:10px;" id="progressBar" rel="#rc.psaID#"></div>
      </cfif>
      </cfoutput>
    </div>
  </div>
</cfif>
<div id="earnings" class="Aristo tclothtable">
<cftry>
<cfoutput query="rc.panelData.turnover" group="xmlID">
    <cfset element = getRebateElement(rc.panelData.xml,xmlID)>
     <cfquery name="co" dbtype="query">select periodName from rc.panelData.c where xmlID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#xmlID#"></cfquery>
		<cfset titleLen = 90 - len(element.title.xmlText)>
		<cfif titleLen lte 0>
			<cfset titleLen = 1>
		</cfif>
		<h3><a href="##">#UCase(element.title.xmlText)# <span class="light"><cfif element.details.xmlText neq "">(#UCase(left(element.details.xmlText,titleLen))# #IIF(len(element.details.xmlText) gt titleLen,"'...'","''")#)</cfif> </span>(#element.id.xmlText#)</a></h3>
    <div>
      <div class="Aristo accordion">

        <cfset PCount = 1>

    <cfoutput group="periodName">

        <cfset dFrom = periodFrom>
        <cfset dTo = periodTo>


      <cftry>
        <cfset inputTypeSource = getUnitType2(arrangement.getFiguresEntryElementsFromList(element.inputSources.xmlattributes.id).inputTypeID)>
        <cfset inputTypePayable = getUnitType2(arrangement.getFiguresEntryElementsFromList(element.outputsources.xmlattributes.id).inputTypeID)>
        <cfset outputType = getUnitType2(element.outputtype.XmlText)>
        <cfif co.recordCount gt 1>
          <h5><a href="##">#periodFormat(element.period.xmlText,dFrom,dTo)#</a></h5>
          <div>
        <cfelse>
          <h4>#periodFormat(element.period.xmlText,dFrom,dTo)#</h4>
          <cfif element.details.xmlText neq "" AND len(element.details.xmlText) gte titleLen>
            <div style="padding: 0pt 0.7em;" class="ui-state-highlight ui-corner-all">
  				    <p><span style="float: left; margin-right: 0.3em;" class="ui-icon ui-icon-alert"></span>
	   			    <strong>Info</strong> #element.details.xmlText#</p>
			      </div>
			      <br />
		      </cfif>
		    </cfif>
        <div class="small">
          <table class="v tableCloth">
            <thead>
              <tr>
        <th>#rc.moduleSettings.eGroup.settings.groupName# Member</th>
        <th class="tr">Turnover</th>
        <th class="tr">Rebate</th>
        <th class="tr">Paid</th>
        <th class="tr">Payable</th>
        <th class="tr">#outputtype.name#</th>
        <cfif DateCompare(now(),dTo) lt 1>
        <th class="tr">Est. Turnover</th>
		    <th class="tr">Est. Rebate</th>
        <th class="tr">Est. #outputtype.name#</th>
        <cfelseif element.inputSources.xmlattributes.id neq element.outputSources.xmlattributes.id>
        <th class="tr">Rebateable Turnover</th>
        </cfif>
      </tr>
     	</thead>
			<tbody>
    <cfset throughputTotal = 0>
    <cfset rebateablethroughputTotal = 0>
    <cfset rebateTotal = 0>
    <cfset payableTotal = 0>
        <cfset OTETotal = 0>
        <cfset OTErebateTotal = 0>
        <cfoutput>

        <tr class="#IIF(memberID eq rc.sess.eGroup.companyID,"'highlightMember'","''")#">
        <td nowrap>#left(known_as,20)#</td>
        <td class="tr" nowrap="nowrap"><cfif inputTypeSource.showBefore eq 1>#inputTypeSource.name#</cfif>#Trim(DecimalFormat(throughput))#<cfif inputTypeSource.showBefore eq 0>#inputTypeSource.name#</cfif></td>
        <td class="tr" nowrap="nowrap">
          <cfif outputtype.isPer eq 0>
            <!--- we need the input type --->
            <cfif inputTypePayable.showBefore eq 1>#inputTypePayable.name#</cfif>#Trim(DecimalFormat(rebateAmount))#<cfif inputTypePayable.showBefore eq 0>#inputTypePayable.name#</cfif>
          <cfelse>
            <cfif outputtype.showBefore eq 1>#outputtype.name#</cfif>#Trim(DecimalFormat(rebateAmount))#<cfif outputtype.showBefore eq 0>#outputtype.name#</cfif>
          </cfif>
        </td>
        <td class="tr" nowrap="nowrap">
            <cfif isUserInRole("figures") AND DateCompare(now(),dTo) gte 1 AND memberID eq rc.sess.eGroup.companyID and (paramVal('element.payableTo.xmlText','group') eq "member" OR paid eq "holding" )>
            <select class="markpaid" rel="#id#">
              <option value="false" #vm('false',paid)#>no</option>
              <option value="incorrect" #vm('incorrect',paid)#>part</option>
              <option value="true" #vm('true',paid)#>yes</option>
            </select>
            <cfelse>
              <cfif paid eq "true">
                <img class="tooltip" title="Member has been paid" src="/images/icons/152.png">
              <cfelseif paid eq "incorrect">
                <img class="tooltip" title="Supplier paid incorrect amount" src="/images/icons/157.png">
              <cfelseif paid eq "holding">
                <img class="tooltip" title="Supplier has paid" src="/images/icons/154.png">
              <cfelse>
                <img class="tooltip" title="Supplier has not paid" src="/images/icons/151.png">
              </cfif>
            </cfif>
            <cfset commentList = getModel("comment").getComments(id,"rebatePayments")>
            <cfif commentList.recordCount neq 0>
            <a href="/comment/list?relatedID=#id#&relatedType=rebatePayments" class="noAjax showcomments"><img border="0" class="tooltip" title="There are comments relating to this rebate payment" src="/images/icons/balloon-quotation.png"></a>
            </cfif>
        </td>
        <td class="tr" nowrap="nowrap">
          <cfif outputtype.isPer eq 0>
            <cfif inputTypePayable.showBefore eq 1>#inputTypePayable.name#</cfif>#Trim(DecimalFormat(rebatePayable))#<cfif inputTypePayable.showBefore eq 0>#inputTypePayable.name#</cfif>
          <cfelse>
            <cfif outputtype.showBefore eq 1>#outputtype.name#</cfif>#Trim(DecimalFormat(rebatePayable))#<cfif outputtype.showBefore eq 0>#outputtype.name#</cfif>
          </cfif>
        </td>
        <td class="tr" nowrap="nowrap"><cfif outputType.showBefore eq 1>#outputType.name#</cfif>#Trim(DecimalFormat(rebateValue))#<cfif outputType.showBefore eq 0>#outputType.name#</cfif></td>
        <cfif DateCompare(now(),dTo) lt 1>
          <td class="tr" nowrap="nowrap"><cfif inputTypeSource.showBefore eq 1>#inputTypeSource.name#</cfif>#Trim(DecimalFormat(OTETHROUGHPUT))#<cfif inputTypeSource.showBefore eq 0>#inputTypeSource.name#</cfif></td>
          <td class="tr" nowrap="nowrap">
            <cfif outputtype.isPer eq 0>
              <cfif inputTypePayable.showBefore eq 1>#inputTypePayable.name#</cfif>#Trim(DecimalFormat(OTEPayable))#<cfif inputTypePayable.showBefore eq 0>#inputTypePayable.name#</cfif>
            <cfelse>
              <cfif outputtype.showBefore eq 1>#outputtype.name#</cfif>#Trim(DecimalFormat(OTEPayable))#<cfif outputtype.showBefore eq 0>#outputtype.name#</cfif>
            </cfif>
          </td>
          <td class="tr" nowrap="nowrap"><cfif outputType.showBefore eq 1>#outputType.name#</cfif>#Trim(DecimalFormat(OTEValue))#<cfif outputType.showBefore eq 0>#outputType.name#</cfif></td>
          </tr>
          <cfset OTETotal = OTETotal + OTETHROUGHPUT>
          <cfset OTErebateTotal = OTErebateTotal + OTEPayable>
        <cfelseif element.inputSources.xmlattributes.id neq element.outputSources.xmlattributes.id>
        <td class="tr" nowrap="nowrap"><cfif inputTypePayable.showBefore eq 1>#inputTypePayable.name#</cfif>#Trim(DecimalFormat(throughputRebateable))#<cfif inputTypePayable.showBefore eq 0>#inputTypePayable.name#</cfif></td>
        </cfif>

        <cfset throughputTotal = throughputTotal + throughput>
        <cfif  isNumeric(throughputRebateable)>
          <cfset rebateablethroughputTotal = rebateablethroughputTotal + throughputRebateable>
       </cfif>

        <cfset rebateTotal = rebateTotal + rebateAmount>
        <cfset payableTotal = payableTotal + rebatePayable>
      </cfoutput>
			</tbody>
      <tfoot>
			<tr>
          <th class="tr">TOTAL</th>
        <th class="tr" nowrap="nowrap"><cfif inputTypeSource.showBefore eq 1>#inputTypeSource.name#</cfif>#Trim(DecimalFormat(throughputTotal))#<cfif inputTypeSource.showBefore eq 0>#inputTypeSource.name#</cfif></th>
        <th class="tr" nowrap="nowrap">
          <cfif outputtype.isPer eq 0>
            <cfif inputTypePayable.showBefore eq 1>
                #inputTypePayable.name#
            </cfif>
            #Trim(DecimalFormat(rebateTotal))#
            <cfif inputTypePayable.showBefore eq 0>
                #inputTypePayable.name#
            </cfif>
          <cfelse>
            <cfif outputType.showBefore eq 1>
                #outputType.name#
            </cfif>
            #Trim(DecimalFormat(rebateTotal))#
            <cfif outputType.showBefore eq 0>
                #outputType.name#
            </cfif>
          </cfif>
        </th>
        <th>
          <cfif isUserInRole("edit") AND DateCompare(now(),dTo) gte 1 AND paramVal('element.payableTo.xmlText','group') eq "group">
            <select class="markpaid" rel="psaID_#rc.psaID#-xmlID_#xmlID#-periodName_#periodName#">
              <option value="false" #vm('false',paid)#>no</option>
              <option value="incorrect" #vm('incorrect',paid)#>part</option>
              <option value="holding" #vm('holding',paid)#>paid to group</option>
              <option value="true" #vm('true',paid)#>paid to member</option>
            </select>
          </cfif>
        </th>
        <th class="tr" nowrap="nowrap">
        <cfif outputtype.isPer eq 0>
          <cfif inputTypePayable.showBefore eq 1>#inputTypePayable.name#</cfif>#Trim(DecimalFormat(payableTotal))#<cfif inputTypePayable.showBefore eq 0>#inputTypePayable.name#</cfif>
        <cfelse>
            <cfif outputtype.showBefore eq 1>#outputtype.name#</cfif>#Trim(DecimalFormat(payableTotal))#<cfif outputtype.showBefore eq 0>#outputtype.name#</cfif>
          </cfif>
        </th>

              <th class="tr"> <cfif DateCompare(now(),dTo) lt 1>EST.<cfelseif element.inputSources.xmlattributes.id neq element.outputSources.xmlattributes.id>TOTAL</cfif></th>
              <cfif DateCompare(now(),dTo) lt 1>
              <th class="tr" nowrap="nowrap"><cfif inputTypeSource.showBefore eq 1>#inputTypeSource.name#</cfif>#Trim(DecimalFormat(OTETotal))#<cfif inputTypeSource.showBefore eq 0>#inputTypeSource.name#</cfif></th>
              <th class="tr" nowrap="nowrap" >
                <cfif outputtype.isPer eq 0>
                  <cfif inputTypePayable.showBefore eq 1>
                      #inputTypePayable.name#
                  </cfif>
                  #Trim(DecimalFormat(OTErebateTotal))#
                  <cfif inputTypePayable.showBefore eq 0>
                      #inputTypePayable.name#
                  </cfif>
                <cfelse>
                   <cfif outputType.showBefore eq 1>
                      #outputType.name#
                  </cfif>
                  #Trim(DecimalFormat(OTErebateTotal))#
                  <cfif outputType.showBefore eq 0>
                      #outputType.name#
                  </cfif>
                </cfif>
              </th>
              <th></th>
              <cfelseif element.inputSources.xmlattributes.id neq element.outputSources.xmlattributes.id>
              <th>
                <cfif inputTypePayable.showBefore eq 1>#inputTypePayable.name#</cfif>#Trim(DecimalFormat(rebateablethroughputTotal))#<cfif inputTypePayable.showBefore eq 0>#inputTypePayable.name#</cfif>
              </th>
              </cfif>
      </tr>
			</tfoot>
        </table>
        </div>
        <cfcatch type="any">
        <h2>Error</h2>
        <p>Input/output sources not defined correctly?</p>
        <cfif isUserInRole("ebiz")>
          <cfdump var="#cfcatch#">
        </cfif>
        </cfcatch>
        </cftry>
        <cfif co.recordCount gt 1></div></cfif>
        <cfset PCount = pCount + 1>
    </cfoutput>
    </div>
  </div>
</cfoutput>
</div>
<cfif rc.layout neq "PDFview">
  <div style="padding-top: 20px;">
  <cfoutput>
  <a target="_blank" class="pdf" href="/psa/view/panel/earnings?psaID=#rc.psaID#&layout=PDFview"><h3>View as PDF</h3></a>
  </cfoutput>
  </div>
</cfif>
 <cfcatch type="any"><h2>Calculation error</h2></cfcatch>

</cftry>
<cfif isUserInRole("ebiz")>
  <cfoutput>
  <a href="/figures/showReport/psaID/#rc.psaID#" target="_blank">show report</a>
  </cfoutput>
</cfif>