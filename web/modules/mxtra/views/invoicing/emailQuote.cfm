<cfoutput>
  <form action="/mxtra/shop/quote/doEmail/id/#rc.id#" class="form form-horizontal">
    <fieldset>
      <legend>Save and Email this quotation</legend>			
      <div class="control-group">
        <label class="control-label" for="fromEmail">From Email:</label>
        <div class="controls">
        	<input size="30" type="text" name="fromEmail" id="fromEmail" value="#request.bmnet.username#" />
				</div>
      </div>
      <div class="control-group">
        <label class="control-label" for="fromName">From Name:</label>
        <div class="controls">
        	<input size="30" type="text" name="fromName" id="fromName" value="#request.bmnet.name#"  />
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
        <label class="control-label" for="overage">Overage/Markup %:</label>
        <div class="controls">
        	<input size="3" type="text" name="overage" id="overage" value="0" />
				</div>
      </div>
      <div class="control-group">
        <label class="control-label" for="message">Message:</label>
        <div class="controls">
        	<textarea rows="10" cols="30" name="message" id="message">Please find attached your quotation recently prepared by Turnbull 24-7.</textarea>
				</div>
      </div>
      <div class="form-actions"><input type="submit" class="btn btn-success" value="save and send email &raquo;">
    </fieldset>
  </form>
</cfoutput>