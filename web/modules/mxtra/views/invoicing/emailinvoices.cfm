<cfoutput>
  <form class="form-horizontal" action="/mxtra/account/doSendInvoices">
    <fieldset>
      <legend>Email Invoices / PODs</legend>
      
      <div class="control-group">
        <label class="control-label" for="fromEmail">From Email:</label>
        <div class="controls">
        	<input size="30" type="text" name="fromEmail" id="fromEmail" value="#rc.sess.BMnet.username#" />
				</div>
      </div>
      <div class="control-group">
        <label class="control-label" for="fromName">From Name:</label>
        <div class="controls">
        	<input size="30" type="text" name="fromName" id="fromName" value="#rc.sess.BMnet.name#"  />
				</div>
      </div>
      <div class="control-group">
        <label class="control-label" for="toEmail">Email To:</label>
        <div class="controls">
        	<input size="30" type="text" name="toEmail" id="toEmail" />
				</div>
      </div>
      <div class="control-group">
        <label class="control-label" for="toName">To Name:</label>
        <div class="controls">
        	<input size="30" type="text" name="toName" id="toName" />
				</div>
      </div>
      <div class="control-group">
        <label class="control-label" for="whattoInclude">Include:</label>
        <div class="controls">
        	<select id="whattoInclude" name="whattoInclude">
	          <option value="both">Invoice(s) and POD(s)</option>
	          <option value="invoices">Invoice(s) only</option>
	          <option value="PODs">PODs only</option>
	        </select>
				</div>
      </div>
      <div class="control-group">
        <label class="control-label" for="message">Message:</label>        
				<div class="controls">
					<textarea rows="10" cols="30" name="message" id="message">Please find attached your invoice(s) and POD(s) recently prepared by Turnbull 24-7.</textarea>
				</div>
      </div>
      <div class="form-actions">
        <button type="submit" class="btn btn-primary">Send Email</button>      
      </div>
			<input type="hidden" name="invoice_numbers" value="#rc.invoiceNumbers#">
    </fieldset>
  </form>
</cfoutput>