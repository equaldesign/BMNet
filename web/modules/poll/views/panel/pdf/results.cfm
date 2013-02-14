<cfdocument fontembed="true"  localurl="false" orientation="portrait"  bookmark="yes" pagetype="A4" format="PDF" margintop="1.2" marginbottom="0.8">
<cfdocumentitem type="header">
<cfoutput>#renderView("poll/panel/pdf/pdf_header")#</cfoutput>
  <h1 class="page-header"><cfoutput>#renderView("poll/panel/pdf/pdf_logo")#</cfoutput><cfoutput>#rc.poll.name#</cfoutput> Results </h1>
<cfoutput>#renderView("poll/panel/pdf/pdf_footer")#</cfoutput>
</cfdocumentitem>
    <cfoutput></cfoutput>
	<cfif rc.resultList.recordCount neq 0>
    <cfdocumentsection name="Pollable Answers">
    <cfoutput>#renderView("poll/panel/pdf/pdf_header")#</cfoutput>
    <!--- pollable answers --->
    <cfoutput query="rc.resultList" group="name">
	  <h3 class="page-header">#name#</h3>
      <cfoutput group="label">
        <h4 class="page-header">#label#</h4>
        <table width="100%" border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td valign="top" width="50%">
                <cfset cValues = "">
                <cfset cLabels = "">
                <cfoutput>
                  <cfset cValues = ListAppend(cValues,optionCount)>
                  <cfset cLabels= ListAppend(cLabels,optionLabel)>
                </cfoutput>
                <cfset curl = 'http://chart.googleapis.com/chart?chs=300x225&cht=p3&chco=1C9900|FF0000|3399CC|80C65A|FF9900|990066|C2BDDD&chd=t:#UrlEncodedFormat(cValues)#&chdl=#URLENcodedFormat(ListChangeDelims(cLabels, "|"))#&chp=0&chdlp=b'>
                <img src="#curl#" width="300" height="225" alt="" />

            </td>
            <td valign="top">
               <table width="100%" border="0" cellspacing="0" cellpadding="0" class="table table-condensed table-striped table-rounded">
                 <thead>
                   <tr>
					<cfif rc.poll.allowMultipleResponses>
                      <th>Name</th>
					</cfif>
                      <th>Company</th>
                      <th>Answer</th>
                   </tr>
                 </thead>
                 <tbody>
                <cfset answerList = getModel("poll").getQuestionResponses(id)>
                   <cfloop query="answerList">
                     <tr>
						<cfif rc.poll.allowMultipleResponses>
                       <td>#first_name# #surname#</td>
					</cfif>
                       <td>#known_as#</td>
                       <td>
						<cfif optionLabel eq "Yes">
						<img src="https://d25ke41d0c64z1.cloudfront.net/images/icons/tick-circle-frame.png">
						<cfelseif optionLabel eq "no">
						<img src="https://d25ke41d0c64z1.cloudfront.net/images/icons/cross-circle-frame.png">
						<cfelse>#optionLabel#</cfif>
						</td>
                     </tr>
                   </cfloop>
                 </tbody>
               </table>
            </td>
            </tr>
          </table>
	<cfif currentRow neq recordCount>
       <cfdocumentitem type="pagebreak"></cfdocumentitem>
	</cfif>
      </cfoutput>
    </cfoutput>
    <cfoutput>#renderView("poll/panel/pdf/pdf_footer")#</cfoutput>
    </cfdocumentsection>
	</cfif>
  <cfif rc.stepperList.recordCount neq 0>
    <cfdocumentsection name="BBO results">
      <cfoutput>#renderView("poll/panel/pdf/pdf_header")#</cfoutput>
      <cfoutput query="rc.stepperList" group="groupName">
        <h3 class="page-header">#groupName#</h3>
        <cfoutput group="label">
          <h4 class="page-header">#label# @ &pound;#fieldName# ea.</h4>

          <table width="100%" border="0" cellspacing="0" cellpadding="0" class="table table-condensed table-striped">
            <thead>
              <tr>
                <th>Partner</th>
                <th>Quantity</th>
                <th>Total</th>
              </tr>
            </thead>
            <cfset thisTotal = 0>
            <cfset thisValue = 0>
            <tbody>
              <cfoutput>
                <tr>
                  <td>#known_as#</td>
                  <td>#value# </td>
                  <td>&pound;#value*fieldName#</td>
                </tr>
                <cfset thisTotal +=value>
                <cfset thisValue += value*fieldName>
              </cfoutput>
            </tbody>
            <tfoot>
              <tr>
                <th>Total</th>
                <th>#thisTotal#</th>
                <th>&pound;#thisValue#</th>
              </tr>
            </tfoot>
          </table>
        </cfoutput>
      </cfoutput>
    <cfoutput>#renderView("poll/panel/pdf/pdf_footer")#</cfoutput>
    </cfdocumentsection>
  </cfif>

    <!--- users invited and who has completed --->
    <cfdocumentsection name="Users Invited / Completed">
    <cfoutput>#renderView("poll/panel/pdf/pdf_header")#</cfoutput>
    <h3 class="page-header">Users Invited/Completed</h3>
    <cfoutput>#renderView("poll/panel/pdf/invitations")#</cfoutput>
    <cfoutput>#renderView("poll/panel/pdf/pdf_footer")#</cfoutput>
    </cfdocumentsection>
	<cfif rc.sumList.recordCount neq 0>
    <cfdocumentsection name="Numeric Answers">
    <cfoutput>#renderView("poll/panel/pdf/pdf_header")#</cfoutput>
    <!--- numeric answers only --->
    <cfoutput query="rc.sumList" group="groupName">
      <h3 class="page-header">#groupName#</h3>
      <cfoutput group="label">
        <h4>#label#</h4>
        <dl class="dl-horizontal">
        <cfoutput>
          <dt>Total</dt>
          <dd>&pound;#DecimalFormat(value)#</dd>
          <dt>Average</dt>
          <dd>&pound;#DecimalFormat(average)#</dd>
        </cfoutput>
        </dl>
        <cfset rc.answers = getModel("poll").getQuestionResponses(id)>
        <cfset f = getModel("figures")>
        <cfset c = getModel("company")>
        <cfset p = getModel("psa")>
          <cfif rc.poll.relatedID neq 0 and rc.poll.relatedTo eq "arrangement">
            <cfset psa = p.getPSA(rc.poll.relatedID)>
            <cfset yearsInDeal = dateDiff("yyyy",psa.period_from,psa.period_to)+1>
            <cfset monthsInDeal = dateDiff("m",psa.period_from,psa.period_to)+1>
            <cfset nextInputDate = f.getNextInputDate(rc.poll.relatedID)>
            <cfset monthsCompleted = dateDiff("m",psa.period_from,nextInputDate)>
            <cfif compare>
            <h4>Related to <a style="text-decoration:none; color:##006699; font-weight:bold;"  href="http://#cgi.HTTP_HOST#/psa/index/id/#psa.id#">#psa.name#</a> with <a style="text-decoration:none; color:##006699; font-weight:bold;"  href="http://#cgi.http_host#/company/index/id/#psa.company_id#">#c.getCompany(psa.company_id).name#</a></h4>
            <h5>#monthsCompleted# months of turnover completed</h5>
            </cfif>
          </cfif>
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="table table-condensed table-striped">
          <thead>
            <tr>
              <th>Partner</th>
              <th>Response</th>
              <cfif compare AND (rc.poll.relatedID neq 0 and rc.poll.relatedTo eq "arrangement")>
              <th>Spend to date</th>
              <th>Performance</th>
              </cfif>
            </tr>
          </thead>
          <tbody>
            <cfset totalResponse = 0>
            <cfset totalSpend = 0>
            <cfloop query="rc.answers">

              <tr>
                <td>#name#</td>
                <td><cfif isNumeric(value)>&pound;#NumberFormat(value,"9,999,999")#<cfelse>#value#</cfif></td>
                <cfif rc.answers.compare AND (rc.poll.relatedID neq 0 and rc.poll.relatedTo eq "arrangement")>
                  <cfset thisTurnover = getModel("figures").getTotalMemberThroughPut(rc.poll.relatedID,companyID)>
                  <cfif thisTurnover.total neq "">
                    <cfset totalSpend+=thisTurnover.total>
                    <cfset totalTurnover = value*yearsInDeal>
                    <cfset totalResponse +=totalTurnover>
                    <cfset avg = thisTurnover.total/#monthsCompleted#>
                    <cfset est = avg*monthsInDeal>
                    <!---<small>(avg: #numberFormat(avg,"9,999")#, est: #numberFormat(est,"9,999")#, declared: #numberFormat(totalTurnover,"9,999")#)</small>--->
                    </cfif>
                <td>&pound;#numberFormat(thisTurnover.total,"9,999")#</td>
                <td>
               <cfif thisTurnover.total neq "">
                  <cfif est lt totalTurnover/100*90 AND (est neq 0 and totalTurnover neq 0)>
                    <span class="label label-important tooltip" title="avg per month: &pound;#numberFormat(avg,"9,999")#, est over agreement period: &pound;#numberFormat(est,"9,999")#, declared for agreement period: &pound;#numberFormat(totalTurnover,"9,999")#">#numberFormat((est/totalTurnover)*100,"9,999")#%</span>
                  <cfelseif est gt totalTurnover>
                    <span class="label label-success tooltip" title="avg per month: &pound;#numberFormat(avg,"9,999")#, est over agreement period: &pound;#numberFormat(est,"9,999")#, declared for agreement period: &pound;#numberFormat(totalTurnover,"9,999")#">#numberFormat((est/totalTurnover)*100,"9,999")#%</span>
                  <cfelse>
                    <span class="label tooltip" title="avg per month: &pound;#numberFormat(avg,"9,999")#, est over agreement period: &pound;#numberFormat(est,"9,999")#, declared for agreement period: &pound;#numberFormat(totalTurnover,"9,999")#"><cfif est neq 0 and totalTurnover neq 0>#numberFormat((est/totalTurnover)*100,"9,999")#%</cfif></label>
                  </cfif>
                </td>
                </cfif>
              </cfif>
              </tr>
            </cfloop>
          </tbody>

          <tfoot>
            <tr>
              <th class="">Total</th>
              <cfif compare AND (rc.poll.relatedID neq 0 and rc.poll.relatedTo eq "arrangement")>
              <th>&pound;#numberFormat(totalResponse,"9,999,999")#</th>
              <th>&pound;#numberFormat(totalSpend,"9,999,999")#</th>
              <th></th>
              <cfelse>
              <th>&pound;#value#</th>
              </cfif>
            </tr>
          </tfoot>
        </table>
				<cfif currentRow neq recordCount>
		        <cfdocumentitem type="pagebreak"></cfdocumentitem>
				</cfif>
      </cfoutput>

    </cfoutput>
    <cfoutput>#renderView("poll/panel/pdf/pdf_footer")#</cfoutput>
    </cfdocumentsection>
	</cfif>
	<cfif rc.answerList.recordCount neq 0>
	<cfdocumentsection name="Other Questions">
	<cfoutput>#renderView("poll/panel/pdf/pdf_header")#</cfoutput>
	<cfoutput query="rc.answerList" group="groupName">
	  <h3 class="page-header">#groupName#</h3>
	  <cfoutput group="label">
	    <div>
	      <h4 class="page-header">#label#</h4>
	      <cfoutput>
	        <div class="currentUser">
	          <h5>#first_name# #surname# (#known_as#)</h5>
	          <p>#value#</p>
	        </div>
	      </cfoutput>
	    </div>
	    <cfif currentRow neq recordCount>
	    <cfdocumentitem type="pagebreak"></cfdocumentitem>
	    </cfif>
	  </cfoutput>

	</cfoutput>

	<cfoutput>#renderView("poll/panel/pdf/pdf_footer")#</cfoutput>
	</cfdocumentsection>
	</cfif>

<cfoutput>#renderView("poll/panel/pdf/pdf_footer")#</cfoutput>
<cfdocumentitem type= "footer">
<cfoutput>#renderView("poll/panel/pdf/pdf_header")#</cfoutput>
  <p class="page-header">
    <span><cfoutput>#rc.poll.name#</cfoutput></span>
    <span class="pull-right"><cfoutput>Page #cfdocument.currentpagenumber# of
    #cfdocument.totalpagecount#</cfoutput></span></p>
<cfoutput>#renderView("poll/panel/pdf/pdf_footer")#</cfoutput>
     </cfdocumentitem>
</cfdocument>