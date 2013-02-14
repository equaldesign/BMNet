 
<h2>Answers</h2>
<div class="form-signUp">
  <form>
<cfoutput query="rc.sumList" group="groupName">
  <fieldset>
  <legend>#groupName#</legend>
  <cfoutput group="label">
    <div>
      <h3>#label#</h3>
      <cfoutput>
        <h4 style="color:black">Total: #DecimalFormat(value)#</h4>
				<h4 style="color:black">Average: #DecimalFormat(average)#</h4>          
      </cfoutput>
    </div>
  </cfoutput>
  </fieldset>
</cfoutput>
</form>
</div>