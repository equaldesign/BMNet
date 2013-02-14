<cfset getMyPlugin(plugin="jQuery").getDepends("validate","psa/email2supplier")>
<cfoutput>
<div class="form-signUp">
  <h2>Send agreement to supplier</h2>
  <form class="form" id="send2supplier" method="post" action="#bl('psa.emailDealDo')#">
  <input type="hidden" name="psaid" value="#rc.psaID#">
  <p>Required fields are are denoted by <em>*</em></p>
    <fieldset>
      <legend>Email Details</legend>
      <div>
        <label for="recipient" class="o">To <em>*</em></label>
        <input size="30" type="text" name="recipient" id="recipient" value="#rc.panelData.suppliercontact.email#" />
      </div>
      <div>
        <label for="Cc" class="o">Copy To</label>
        <input size="30" type="text" name="Cc" id="Cc" value="#rc.panelData.contact.getemail()#" />
      </div>
      <div>
        <label for="subject" class="o">Subject<em>*</em></label>
        <input size="30" type="text" name="subject" id="subject" value="Agreement #Year(rc.panelData.psa.period_from)#-#rc.psaID# for #rc.panelData.company.getName()#" />
      </div>
      <div>
        <label for="from_name" class="o">From Name<em>*</em></label>
        <input size="30" type="text" name="from_name" id="from_name" value="#rc.panelData.contact.getfirst_name()# #rc.panelData.contact.getsurname()#" />
      </div>
      <div>
        <label for="from_email" class="o">From Email<em>*</em></label>
        <input size="30" type="text" name="from_email" id="from_email" value="#rc.panelData.contact.getemail()#" />
      </div>
      <div>
        <label for="message" class="o">Message</label>
        <textarea name="message" id="message">#rc.message#</textarea>
      </div>
    </fieldset>

    <fieldset>
      <legend>Attachments</legend>

      <cfif rc.dealdocuments.recordCount neq 0>
      <div style="padding: 0pt 0.7em;" class="Aristo ui-state-highlight ui-corner-all">
        <p><span style="float: left; margin-right: 0.3em;" class="ui-icon ui-icon-alert"></span>
        You can choose to optionally attach the following documents.</p>
      </div>
      </cfif>
      <cfloop query="rc.dealdocuments">
        <div>
          <input type="checkbox" value="#id#" name="dmsattach" />
          <label for="attachement_#id#" class="o">#name#</label>
        </div>
      </cfloop>
      <div style="padding: 0pt 0.7em;" class="Aristo ui-state-highlight ui-corner-all">
        <p><span style="float: left; margin-right: 0.3em;" class="ui-icon ui-icon-alert"></span>
        <strong>Agreement PDF</strong></p>
        <p>A PDF copy of the agreement will be automatically attached and sent with this email. You can view this PDF <a class="bold red" target="_blank" href="#bl('psa.view/panel/psa','psaID=#rc.psaID#&layout=PDF')#">by clicking here</a>.</p>
      </div>
    </fieldset>
    <div class="rightControlSet">
      <div>
      <input class="doIt" type="submit" value="Send agreement to supplier" />
      </div>
    </div>
  </form>
</div>
</cfoutput>