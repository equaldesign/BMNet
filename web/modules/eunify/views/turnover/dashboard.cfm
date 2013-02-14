<cfset getMyPlugin(plugin="jQuery").getDepends("form,fusioncharts,dataTables","tableNoPage,turnover/dashboard,charts/turnoverDashboard","tables")>
<div id="turnoverChart"></div>
<div id="tsort">
  <table id="figs" class="dataTable">
    <thead>
		  <tr>
        <th><input type="checkbox" id="checkAll" /></th>
		    <th>psaID</th>
		    <th>Supplier</th>
		    <th>Late</th>
		    <th>Start</th>
		    <th>End</th>
		  </tr>
    </thead>
    <tbody>
      <cfoutput query="rc.deals">

        <cfif lastDate neq "">
          <cfif DateCompare(period_to,now()) gte 1>
	         <!--- the deal hasn't ended --->
	          <cfset monthsLate = DateDiff("m",lastDate,now())-1>
	        <cfelse>
	          <cfset monthsLate = DateDiff("m",lastDate,period_to)>
	         </cfif>
        <cfelse>
          <cfif DateCompare(period_to,now()) gte 1>
           <!--- the deal hasn't ended --->
           <cfset monthsLate = DateDiff("m",period_from,now())-1>
          <cfelse>
           <cfset monthsLate = DateDiff("m",period_from,period_to)>
           </cfif>

        </cfif>
       <cfif monthsLate gte 1>
       <tr>
        <td><input class="sendEmail" type="checkbox" name="psaID" value="#id#" /></td>
        <td>#id#</td>
        <td><a class="tooltip" title="#name#" href="#bl('psa.index','psaid=#id#')#">#capFirstTitle(known_as)#</a></td>
        <td>
          #monthsLate#
          <cfset comments = getModel("comment").getComments(id,"arrangement","note")>
          <cfif comments.recordCount gte 1>
            <span class="comments">#comments.recordCount#</span>
          </cfif>
        </td>
        <td>#DateFormat(period_from,"DD/MM/YYYY")#</td>
        <td>#DateFormat(period_to,"DD/MM/YYYY")#</td>
       </tr>
       </cfif>
      </cfoutput>
    </tbody>
  </table>
</div>
<cfif isUserInRole("admin")>
<cfoutput>
<div class="form-signUp">
  <h2>Remind the suppliers</h2>
  <form class="form" id="remindSuppliers" method="post" action="/email/manualReminder">
    <fieldset>
      <legend>&nbsp; Email Information &nbsp;</legend>
      <div>
        <label for="fromname" class="o">From Name <em>*</em></label>
        <input size="30" type="text" name="fromname" id="fromname" value="#rc.sess.eGroup.name#" />
      </div>
      <div>
        <label for="from_email" class="o">From Email <em>*</em></label>
        <input size="30" type="text" name="from_email" id="from_email" value="#rc.sess.eGroup.username#" />
      </div>
      <div>
        <label for="message" class="o">Message</label>
        <textarea  name="message" id="message">Dear [contactname],

You seem to be behind on your turnover figures on the #getSetting("siteTitle")# Intranet.

We'd appreciate it if you could login and update your figures at your earliest convinience.

Many Thanks,

#rc.sess.eGroup.name#</textarea>
      </div>
    <div class="rightControlSet">
      <div>
      <input class="doIt" type="submit" value="Send Reminders" />
      </div>
    </div>
  </form>
</div>
</cfoutput>
</cfif>
