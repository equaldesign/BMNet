<cfset getMyPlugin(plugin="jQuery").getDepends("form,validate","shop/checkout","#request.siteID#/checkout")>
<div id="checkout">
<cfoutput>
#renderView("shop/checkout/stages")#
	<form class="form-horizontal" id="checkout" action="/mxtra/shop/checkout" method="post">
  	 <fieldset>
  	   <legend>Payment Details</legend>
    	<cfif isDefined('rc.error') and ArrayLen(rc.error.message) neq 0>
      <div class="alert alert-error">
        <strong>Sorry. There was a problem with some of the information you submitted:</strong>
        <ul>
        <cfloop array="#rc.error.message#" index="i">
          <li>#i#</li>
        </cfloop>
        </ul>
      </div>
      </cfif>
  		<div class="control-group #isErrorField('mxtra.order.card.cardType')#">
  		  <label class="control-label">Card type<em>*</em></label>
  		  <div class="controls">
					 <cfset ccType = "Switch,Mastercard,Visa">
	  	     <select id="mxtra.order.card.cardType" class="nice #isErrorField('mxtra.order.card.cardType')#" name="mxtra.order.card.cardType">
	  	     <option value="" style="color: ##555;">Select a card type</option>
	  	     <cfloop list="#ccType#" index="c">
	  	      <option value="#c#" <cfif request.mxtra.order.card.cardType EQ c>selected</cfif>>#c#</option>
	  	     </cfloop>
  	       </select>
			  </div>
  		</div>
  		<div class="control-group #isErrorField('mxtra.order.card.name')#">
  		  <label class="control-label" for="mxtra.order.card.name">Name on Card<em>*</em></label>
  		  <div class="controls">
				  <input type="text" name="mxtra.order.card.name" size="20" class="nice #isErrorField('mxtra.order.card.name')#" value="#request.mxtra.order.card.name#">
				</div>
  		</div>
      <div class="control-group #isErrorField('mxtra.order.card.cardNumber')#">
        <label class="control-label" for="mxtra.order.card.cardNumber">Card Number<em>*</em></label>
        <div class="controls">
				  <input type="text" name="mxtra.order.card.cardNumber" size="16" class="nice #isErrorField('mxtra.order.card.cardNumber')#" value="#request.mxtra.order.card.cardNumber#">
			  </div>
      </div>
  		<div class="control-group hidden #isErrorField('mxtra.order.card.validFrom')#" id="div_startDate">
  		  <label class="control-label" for="dP">Start date<em>*</em></label>
  		  <div class="controls">
				  <select class="span1 #isErrorField('mxtra.order.card.validFrom')# nice" name="pSM">
	  		      <option value=""></option>
	  		    <cfloop from="1" to="12" index="i">
	  		      <option value="#i#" <cfif DateFormat(request.mxtra.order.card.validFrom,"MM") EQ i>selected</cfif>>#i#</option>
	  		    </cfloop>
	  		  </select> /
	  		  <select name="pSY" class="span1 #isErrorField('mxtra.order.card.validFrom')# nice">
	  		    <cfoutput>
	  		      <option value=""></option>
	  		    <cfloop from="#YEAR(now())-10#" to="#Year(now())#" index="i">
	  		      <option value="#i#" <cfif DateFormat(request.mxtra.order.card.validFrom,"YYYY") EQ i>selected</cfif>>#i#</option>
	  		    </cfloop>
	  		    </cfoutput>
	  		  </select>
				</div>
  		</div>
  		<div class="control-group #isErrorField('mxtra.order.card.validTo')#">
  		  <label class="control-label" for="dM">Expiry date<em>*</em></label>
  		  <div class="controls">
					<select name="pEM" class="span1 #isErrorField('mxtra.order.card.validTo')# nice">
	          <option value=""></option>
	  		    <cfloop from="1" to="12" index="i">
	  		      <option value="#i#" <cfif DateFormat(request.mxtra.order.card.validTo,"MM") EQ i>selected</cfif>>#i#</option>
	  		    </cfloop>
	  		  </select> /
	  		  <select name="pEY" class="span1 #isErrorField('mxtra.order.card.validTo')# nice">
	  		      <option value=""></option>
	  		    <cfloop from="#YEAR(now())#" to="#Year(now())+10#" index="i">
	  		      <option value="#i#" <cfif DateFormat(request.mxtra.order.card.validTo,"YYYY") EQ i>selected</cfif>>#i#</option>
	  		    </cfloop>
	  		  </select>
				</div>
  		</div>
  		<div class="control-group #isErrorField('mxtra.order.card.issueNumber')#" id="div_issueNumber">
  		  <label for="mxtra.order.card.issueNumber"  class="control-label">Issue Number<em>*</em></label>
  		  <div class="controls">
				  <input type="text" name="mxtra.order.card.issueNumber" size="2"  class="#isErrorField('mxtra.order.card.issueNumber')# input-mini" value="#request.mxtra.order.card.issueNumber#">
				</div>
  		</div>
      <div class="control-group #isErrorField('mxtra.order.card.securityCode')#">
        <label class="control-label" for="pSC">Security Code<em>*</em></label>
        <div class="controls">
				  <input type="text" name="mxtra.order.card.securityCode" size="3" class="input-mini helptip #isErrorField('mxtra.order.card.securityCode')# nice" title="This is the three digits that can be found on the reverse of your card" value="#request.mxtra.order.card.securityCode#">
				</div>
      </div>
			<div class="form-actions">
        <a class="btn btn-danger" href="/mxtra/shop/checkout?stage=2">Back</a>&nbsp;<button type="submit" class="btn btn-success">Continue</button>
      </div>
  		</fieldset>
  		<input type="hidden" name="stage" value="4" />
  	</form>

</div>
</cfoutput>