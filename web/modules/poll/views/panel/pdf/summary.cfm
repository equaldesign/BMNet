<cfdocument fontembed="true"  localurl="false" orientation="portrait"  bookmark="yes" pagetype="A4" format="PDF" margintop="1.2" marginbottom="0.8">
<cfdocumentitem type="header">
<cfoutput>#renderView("poll/panel/pdf/pdf_header")#</cfoutput>
  <h1 class="page-header"><cfoutput>#renderView("poll/panel/pdf/pdf_logo")#</cfoutput><cfoutput><span>#rc.poll.name#</cfoutput> Summary </span></h1>
<cfoutput>#renderView("poll/panel/pdf/pdf_footer")#</cfoutput>
</cfdocumentitem>
  <cfif rc.resultList.recordCount neq 0>
    <cfdocumentsection name="Pollable Answers">
    <cfoutput>#renderView("poll/panel/pdf/pdf_header")#</cfoutput>
  <cfoutput><div class="alert alert-info"><p>The following results summarise the partner responses. A full version of this report is also available via the NBG intranet, and further retrospective anaylisis is possible within the system.</p>
    </cfoutput></div>
    <!--- pollable answers --->
    <cfoutput query="rc.resultList" group="name">
      <cfif name eq "Supplier Information">
       <cfset colList = {}>
       <cfoutput group="label">
       <cfset colList["#Replace(label,' ','_','all')#"] = 0>
       </cfoutput>
       <cfoutput>
        <cfset l = Replace(label,' ','_','all')>
         <cfif isNumeric(colList["#l#"])>
          <CFSET CURRL = colList["#L#"]>
         <cfelse>
           <cfset currL = 0>
         </cfif>

        <cfset colList["#l#"] = currL+(optionCount*ListFirst(optionLabel,"."))>
       </cfoutput>
       <cfset cLabels = {}>
          <cfoutput>
            <cfif StructKeyExists(cLabels,"#optionLabel#")>
              <cfset cLabels["#optionLabel#"] += optionCount>
            <cfelse>
              <cfset cLabels["#optionLabel#"] = optionCount>
            </cfif>
          </cfoutput>
          <cfset cValues = "">
          <cfset cLabelsL = "">
          <cfloop collection="#cLabels#" item="c">
            <cfset cValues = ListAppend(cValues,cLabels[c])>
            <cfset cLabelsL= ListAppend(cLabelsL,c)>
          </cfloop>
          <cfset curl = 'http://chart.googleapis.com/chart?chbh=a&chts=676767,7.5&chds=a&chs=290x220&cht=bvs&chco=1C9900|FF0000|3399CC|80C65A|FF9900|990066|C2BDDD&chd=t:#UrlEncodedFormat(cValues)#&chdl=#URLENcodedFormat(ListChangeDelims(cLabelsL, "|"))#&chp=0&chdlp=b'>
          <div class="chartDiv">
            <h4>#label#</h4>
            <img src="#curl#" width="290" height="220" alt="" />
          </div>
      </cfif>


      <cfoutput group="label">
        <cfif name eq "Supplier Information">
        <cfelseif label eq "Rebate Weighting" OR label eq "Price">
          <cfset cLabels = {}>
          <cfoutput>
            <cfif StructKeyExists(cLabels,"#optionLabel#")>
              <cfset cLabels["#optionLabel#"] += optionCount>
            <cfelse>
              <cfset cLabels["#optionLabel#"] = optionCount>
            </cfif>
          </cfoutput>
          <cfset cValues = "">
          <cfset cLabelsL = "">
          <cfloop collection="#cLabels#" item="c">
            <cfset cValues = ListAppend(cValues,cLabels[c])>
            <cfset cLabelsL= ListAppend(cLabelsL,c)>
          </cfloop>
          <cfset curl = 'http://chart.googleapis.com/chart?chbh=a&chts=676767,7.5&chds=a&chs=290x220&cht=bvs&chco=1C9900|FF0000|3399CC|80C65A|FF9900|990066|C2BDDD&chd=t:#UrlEncodedFormat(cValues)#&chdl=#URLENcodedFormat(ListChangeDelims(cLabelsL, "|"))#&chp=0&chdlp=b'>
          <div class="chartDiv">
            <h4>#label#</h4>
            <img src="#curl#" width="290" height="220" alt="" />
          </div>
        <cfelse>
          <cfset cValues = "">
          <cfset cLabels = "">
          <cfoutput>
            <cfset cValues = ListAppend(cValues,optionCount)>
            <cfset cLabels= ListAppend(cLabels,optionLabel)>
          </cfoutput>
          <cfset curl = 'http://chart.googleapis.com/chart?chts=676767,7.5&chs=290x220&cht=p3&chco=1C9900|FF0000|3399CC|80C65A|FF9900|990066|C2BDDD&chd=t:#UrlEncodedFormat(cValues)#&chdl=#URLENcodedFormat(ListChangeDelims(cLabels, "|"))#&chp=0&chdlp=b'>
          <div class="chartDiv">
            <h4>#label#</h4>
            <img src="#curl#" width="290" height="220" alt="" />
          </div>
        </cfif>
      </cfoutput>
    </cfoutput>
    <cfoutput>#renderView("poll/panel/pdf/pdf_footer")#</cfoutput>
    </cfdocumentsection>
  </cfif>
  <cfif rc.stepperList.recordCount neq 0>
    <cfdocumentsection name="BBO results">
      <cfset totalBBOValue=0>
      <cfoutput>#renderView("poll/panel/pdf/pdf_header")#</cfoutput>
      <cfoutput query="rc.stepperList" group="groupName">
        <h3 class="page-header">#groupName#</h3>
        <cfoutput group="label">
          <h3>#label# @ &pound;#fieldName# ea.</h3>
          <cfset thisTotal = 0>
          <cfset thisValue = 0>
          <cfoutput>
            <cfset thisTotal +=value>
            <cfset thisValue += value*fieldName>
            <cfset totalBBOValue+=thisValue>
          </cfoutput>
          <h4>Total: #thisTotal# items, value: &pound;#decimalFormat(thisValue)#</h4>
          <hr />
        </cfoutput>
      </cfoutput>
      <h2>Total BBO Value: <cfoutput>&pound;#decimalFormat(totalBBOValue)#</cfoutput></h2>
    <cfoutput>#renderView("poll/panel/pdf/pdf_footer")#</cfoutput>
    </cfdocumentsection>
  </cfif>
  <cfif rc.sumList.recordCount neq 0>
    <cfdocumentsection name="Numeric Answers">
    <cfoutput>#renderView("poll/panel/pdf/pdf_header")#</cfoutput>
    <!--- numeric answers only --->
    <cfoutput query="rc.sumList" group="groupName">
      <h3 class="page-header">#groupName#</h3>
      <cfset a = []>

      <cfoutput group="label">
        <cfif groupName neq "Partner Suggested Priorities">
          <cfset ArrayAppend(a,getModel("poll").getQuestionResponses(id))>
        </cfif>
      </cfoutput>
      <cfif groupName neq "Supplier Information" AND  groupName neq "Carriage Paid">
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
      </cfoutput>
      </CFIF>
     <cfif groupName eq "Partner Suggested Priorities" OR  groupName eq "Carriage Paid">
      <cfoutput group="label">
        <h4>#label#</h4>
        <dl class="dl-horizontal">
        <cfoutput>
          <dt>Average</dt>
          <dd>&pound;#DecimalFormat(average)#</dd>

        </cfoutput>
        </dl>
      </cfoutput>
      </CFIF>
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