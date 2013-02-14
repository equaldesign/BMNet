<cfset getMyPlugin(plugin="jQuery").getDepends("form","sites/#request.siteID#/checkout","#request.siteID#/checkout")>
<div id="checkout">
  <div class="page-header">
	 <h1>Checkout</h1>
  </div>
  <div id="checkOutStage">
    <ul class="breadcrumb">
      <li class="active"><a href="/mxtra/shop/checkout">1. Login or guest</a><span class="divider">/</span></li>
      <li class="active"><a href="/mxtra/shop/checkout?stage=1">2. Billing</a><span class="divider">/</span></li>
      <li class="active"><a href="/mxtra/shop/checkout?stage=2">3. Delivery</a<span class="divider">/</span></li>
      <li class="active"><a href="/mxtra/shop/checkout?stage=3">4. Payment Information</a><span class="divider">/</span></li>
      <li>5. Confirmation</li>
    </ul>
  </div>
  <cfif isUserInRole("trade")>
  <div class="notice Aristo ui-state-highlight ui-corner-all">
    <p><span style="float: left; margin-right: 0.3em;" class="ui-icon ui-icon-alert"></span>
    <strong>Quote or buy?</strong> You can choose to either buy online now securely, or let us quote for your order.</p>
  </div>
  </cfif>
    <cfif isUserInRole("trade")>
    <form class="form-horiztonal" action="/mxtra/shop/checkout/quote" method="post">
    <fieldset>
      <legend>Quote me</legend>
      <p>If you want us to quote for your basket instead of paying now, you can continue below.</p>
      <p>Quotes may take a day or so to compile, but we may be able to reduce the cost or your order when trade terms have been applied by one of our staff</p>
      <div class="buttonrow">
        <input type="submit" value="Quote me &raquo;" class="doIt">
      </div>
    </fieldset>
    </form>
    </cfif>
  	<form class="form-horizontal id="checkout" action="/mxtra/shop/checkout" method="post">
  	 <fieldset>
  	   <legend>Pay Online Securely</legend>
  		<cfif isDefined('rc.error') and ArrayLen(rc.error.message) neq 0>
    <div class="alert alert-error">     
      <strong>Sorry. There was a problem with some of the information you submitted:</strong>
      <ul>
      <cfoutput>
      <cfloop array="#rc.error.message#" index="i">
        <li>#i#</li>
      </cfloop>
      </cfoutput>
      </ul>
    </div>
    </cfif>
      <cfoutput>
  		<div class="control-group #isErrorField('dNpT')#">
  		  <label class="control-label">Card type<em>*</em></label>
  		  <div class="controls">
					 <cfset ccType = "Switch,Mastercard,Visa">
	  	     <select id="pT" class="nice #isErrorField('pT')#" name="pT">
	  	     <option value="" style="color: ##555;">Select a card type</option>
	  	     <cfloop list="#ccType#" index="c">
	  	      <option value="#c#" <cfif rc.order.card.cardType EQ c>selected</cfif>>#c#</option>
	  	     </cfloop>
  	       </select>
			  </div>
  		</div>
  		<div class="control-group #isErrorField('dN')#">
  		  <label class="control-label" for="bA">Name on Card<em>*</em></label>
  		  <div class="controls">
				  <input type="text" name="pN" size="20" class="nice #isErrorField('pN')#" value="#rc.order.card.name#">
				</div>
  		</div>
      <div class="control-group #isErrorField('dN')#">
        <label class="control-label" for="bA">Card Number<em>*</em></label>
        <div class="controls">
				  <input type="text" name="pC" size="16" class="nice #isErrorField('pC')#" value="#rc.order.card.CARDNUMBER#">
			  </div>
      </div>
  		<div class="control-group hidden #isErrorField('dN')#" id="div_startDate">
  		  <label class="control-label" for="dP">Start date<em>*</em></label>
  		  <div class="controls">
				  <select class="span1 #isErrorField('pSD')# nice" name="pSM">
	  		    <cfoutput>
	  		      <option value=""></option>
	  		    <cfloop from="1" to="12" index="i">
	  		      <option value="#i#" <cfif DateFormat(rc.order.card.validFrom,"MM") EQ i>selected</cfif>>#i#</option>
	  		    </cfloop>
	  		    </cfoutput>
	  		  </select> /
	  		  <select name="pSY" class="span1 #isErrorField('pSD')# nice">
	  		    <cfoutput>
	  		      <option value=""></option>
	  		    <cfloop from="#YEAR(now())-10#" to="#Year(now())#" index="i">
	  		      <option value="#i#" <cfif DateFormat(rc.order.card.validFrom,"YYYY") EQ i>selected</cfif>>#i#</option>
	  		    </cfloop>
	  		    </cfoutput>
	  		  </select>
				</div>
  		</div>
  		<div class="control-group #isErrorField('dN')#">
  		  <label class="control-label" for="dM">Expiry date<em>*</em></label>
  		  <div class="controls">
					<select name="pEM" class="span1 #isErrorField('pED')# nice">
	          <cfoutput>
	          <option value=""></option>
	  		    <cfloop from="1" to="12" index="i">
	  		      <option value="#i#" <cfif DateFormat(rc.order.card.validTo,"MM") EQ i>selected</cfif>>#i#</option>
	  		    </cfloop>
	  		    </cfoutput>
	  		  </select> /
	  		  <select name="pEY" class="span1 #isErrorField('pED')# nice">
	  		    <cfoutput>
	  		      <option value=""></option>
	  		    <cfloop from="#YEAR(now())#" to="#Year(now())+10#" index="i">
	  		      <option value="#i#" <cfif DateFormat(rc.order.card.validTo,"YYYY") EQ i>selected</cfif>>#i#</option>
	  		    </cfloop>
	  		    </cfoutput>
	  		  </select>
				</div>
  		</div>
  		<div class="control-group #isErrorField('dN')#" id="div_issueNumber">
  		  <label for="pIN"  class="control-label">Issue Number<em>*</em></label>
  		  <div class="controls">
				  <input type="text" name="pIN" size="2"  class="#isErrorField('pIN')# nice" value="#rc.order.card.issueNumber#">
				</div>
  		</div>
      <div class="control-group #isErrorField('dN')#">
        <label class="control-label" for="pSC">Security Code<em>*</em></label>
        <div class="controls">
				  <input type="text" name="pSC" size="3" class="input-mini helptip #isErrorField('pSC')# nice" title="This is the three digits that can be found on the reverse of your card" value="#rc.order.card.securityCode#">
				</div>
      </div>
			<div class="form-actions">
        <button type="submit" class="btn btn-primary">Continue</button>      
      </div>
  		</fieldset>
      </cfoutput>  		
  	</form>

</div>