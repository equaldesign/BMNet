<cfoutput>
<h1>Welcome #getModel("eunify.ContactService").getContact(request.BMNet.contactID,3,request.siteID).first_name#</h1>
</cfoutput>
<div class="widget big-stats-container">

      <div class="widget-content">

        <div id="big_stats" class="cf">
      <div class="stat">
        <h4>Pending Quotations</h4>
        <span class="value"><a href="/quote/home/pending"><cfoutput>#rc.pendingQuotations.recordCount#</cfoutput></a></span>
      </div> <!-- .stat -->

      <div class="stat">
        <h4>Open Quotations</h4>
        <span class="value"><a href="/quote/home/open"><cfoutput>#rc.openQuotations.recordCount#</cfoutput></a></span>
      </div> <!-- .stat -->
      <!---
      <div class="stat">
        <h4>Successful Quotations</h4>
        <span class="value"><a href="/quote/home/success"><cfoutput>#rc.successfulQuotations.recordCount#</cfoutput></a></span>
      </div> <!-- .stat -->
      
      <div class="stat">
        <h4>Rejected Quotations</h4>
        <span class="value"><a href="/quote/home/rejected"><cfoutput>#rc.rejectedQuotations.recordCount#</cfoutput></a></span>
      </div> <!-- .stat -->
      --->
    </div>

  </div> <!-- /widget-content -->

</div>
