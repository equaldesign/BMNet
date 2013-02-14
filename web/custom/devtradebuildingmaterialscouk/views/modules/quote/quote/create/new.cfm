 <cfset getMyPlugin(plugin="jQuery").getDepends("","sites/#request.siteID#/search","")>
<cfoutput>
<form id="doQuote" action="/quote/do/finish" class="form form-horizontal" method="post">
<div id="overviewpage" class="row"> 
	<div class="span8">
		<div id="stage1">
			<div class="faq-icon">
        <div class="circle-icon faq-circle-icon">
          <div>1</div>
        </div>
      </div>
			<button id="cont" type="button" class="addProducts pull-right btn btn-success hide">Continue and ammend your details &raquo;</button>			
      <div class="faq-text">        
				<h2>Stage 1 of 2</h2>
				
      </div>
		  <div class="alert alert-info">
        <a href="##" class="close" data-dismiss="alert">&times;</a>
				<h3 class="alert-heading">Let's get started!</h3>
        <p>First, we need to know about the products you need. You can search over 180,000 product lines using the search below.</p>
				<p>If we can't find the products you need after you have searched - don't worry, you can add products manually as well!</p>
      </div>
			<fieldset>
        <legend>Products Required</legend>              
        <div class="control-group">
          <label class="control-label">Product Search</label>
          <div class="controls">
            <div class="input-prepend input-append">
              <span class="add-on">
                <i class="icon-search"></i>
              </span>
              <input type="text" name="sname" id="searchQuery" placeholder="i.e cement" />     
              <button id="doSearch" class="btn btn-success" type="button">Search over 180,000 products</button>              
							<p class="help-block">Start typing a product name, Bar code or part code, and we'll search as you type.</p>   
            </div>
          </div>    
        </div>
				<div id="unitsQuantities" class="hide control-group">
          <label class="control-label">Quantity Required</label>
          <div class="controls">
            <input id="quantity" type="text" class="input-mini" name="quantity" value="1" />
            <select class="input-small" id="unit" name="unit">
              <cfset uTypes = getModel('eunify.ProductService').getUnitTypes()> 
              <cfloop query="uTypes">
               <option value="#type#">#display#</option>
              </cfloop>   
            </select>
          </div>
        </div> 
      </fieldset> 
			<div id="searchResults">
			</div>
			<div id="actions" class="hide form-actions">
        <button disabled="disabled" type="button" class="continue addProducts btn btn-info disabled">Continue &raquo;</button>
      </div>			
		</div>
		<div class="hide" id="stage2">
      
      <div class="faq-icon">
        <div class="circle-icon faq-circle-icon">
          <div>2</div>
        </div>
      </div>
      <button id="backToRequirements" type="button" class="pull-right btn btn-warning">&laquo; Go back and choose more products</button>
      <div class="faq-text">
        <h2>Stage 2 of 2</h2>
      </div>
      <div class="alert alert-info">
        <a href="##" class="close" data-dismiss="alert">&times;</a>
        <p>First, we need to take some details down regarding your order.</p>
      </div>

      <fieldset id="overview">
        <legend>Overview</legend>
        <div class="control-group">
          <label class="control-label" for="reference">Your Reference<em>*</em></label>
          <div class="controls">
            <input type="text" name="reference" id="reference" placeholder="i.e driveway project" />
            <p class="help-block">Please enter a reference or name for your quotation request.</p>
          </div>
        </div>        
        <div class="control-group">
          <label class="control-label" for="deadline">Deadline<em>*</em></label>
          <div class="controls">
            <div class="input-prepend">
              <span class="add-on"><i class="icon-date"></i></span>
              <input class="ddate input-small" type="text" name="deadline" id="deadline" value="#DateFormat(DateAdd("d",3,now()),"DD/MM/YYYY")#" />
              <p class="help-block">Specify a deadline for merchants to return their quotation.</p>
            </div>
          </div>
        </div>        
      </fieldset>     
      <fieldset id="delivery">
        <legend>Delivery Details</legend>
        <div class="control-group">
          <label class="control-label" for="bPC">Delivered?</label>
          <div class="controls">
            <label class="radio">
              <input class="del" type="radio" name="delivered" value="true" checked>
              I need this order delivered
            </label>
            <label class="radio">
              <input class="del" type="radio" name="delivered" value="false">
              I'm happy to collect my order
            </label>
          </div>
        </div>
        <div id="deliveryDate" class="control-group">
          <label class="control-label" for="deliverydate">Delivery Date</label>
          <div class="controls">
            <div class="input-prepend">
              <span class="add-on"><i class="icon-date"></i></span>
              <input class="ddate input-small" type="text" name="deliverydate" id="deliverydate" value="#DateFormat(DateAdd("d",7,now()),"DD/MM/YYYY")#" />
            </div>
          </div>
        </div>
				<div class="control-group">
          <label class="control-label" for="companyName">Company Name</label>
          <div class="controls">
            <input type="text" id="companyName" name="companyName" class="" value="#rc.customer.name#">
          </div>
        </div>
        <div class="control-group">
          <label class="control-label" for="Contact">Contact Name<em>*</em></label>
          <div class="controls">
            <input type="text" id="contact" name="contact" class="" value="">
          </div>
        </div>
        <div class="control-group">
          <label class="control-label" for="deliveryAddress"><span id="field_deliveryAddress">Delivery Address</span><em>*</em></label>
          <div class="controls">
            <textarea id="deliveryAddress" cols="40" rows="7" name="deliveryAddress">#rc.customer.company_address_1##chr(13)#
              #rc.customer.company_address_2##chr(13)#
              #rc.customer.company_address_3##chr(13)#
              #rc.customer.company_address_4##chr(13)#
            </textarea>
          </div>
        </div>
        <div class="control-group">
          <label class="control-label" for="postcode"><span id="field_deliverPostCode">Delivery Postcode</span><em>*</em></label>
          <div class="controls">
            <input type="text" id="postcode" name="postcode" size="10" class="input-small" value="#rc.customer.company_postCode#">
          </div>
        </div>
        <div id="collectionRadius" class="hidden control-group">
          <label class="control-label" for="postcode">Collection Radius</label>
          <div class="controls">
            <select class="input-small" name="collectionradius">
              <option value="5">5 miles</option>
              <option value="10">10 miles</option>
              <option value="15" selected="selected">15 miles</option>
              <option value="20">20 miles</option>
              <option value="50">50 miles</option>
            </select>           
            <p class="help-block">How many miles are you prepared to travel to collect your order?</p>
          </div>
        </div>
        <div class="control-group">
          <label class="control-label"  for="email">Email Address<em>*</em></label>
          <div class="controls">
            <input type="text" name="email" size="20" value="#rc.customer.company_email#">
          </div>
        </div>				
        <div class="control-group">
          <label class="control-label"  for="phone">Phone number<em>*</em></label>
          <div class="controls">
            <input type="text" name="phone" id="phone" size="20" class="input-small" value="#rc.customer.company_phone#">
          </div>
        </div>
      </fieldset>
			<cfif request.BMNet.contactID eq "">
      <fieldset>
      	<legend>Your login information</legend>
        <div class="control-group">
          <label class="control-label"  for="password">Enter a password<em>*</em></label>
          <div class="controls">
            <input type="password" id="password" name="password" size="20" value="">
          </div>
        </div>
        <div class="control-group">
          <label class="control-label" for="password2">Confirm your password<em>*</em></label>
          <div class="controls">
            <input type="password" id="password2" name="password2" size="20" value="">
          </div>
        </div>
			</fieldset>
      </cfif>   
      <fieldset>
      	<legend>Optional additional information</legend>
				<div class="control-group">
          <label class="control-label" for="tradesetup">Trade account</label>
          <div class="controls">
            <label class="checkbox">
            	<input type="checkbox" name="tradesetup" id="tradesetup" value="true">
							Do you already have a trade account with any existing merchants, or would you be interested in creating one?						
						</label>						
          </div>
        </div> 
				<div class="control-group">
          <label class="control-label" for="bestQuote">Existing Quote</label>
          <div class="controls">
            <input type="text" name="bestQuote" id="bestQuote" size="20" placeholder="i.e. &pound;1,400" class="input-small" value="" />
						<p class="help-block">Have you had a quotation already? If so, what is the best price you've had? (Be honest!)</p>
          </div>
        </div>
      </fieldset>
			<div class="form-actions">
        <button type="submit" class="btn btn-success btn-large">Finish &amp; Confirm &raquo;</button>
      </div>
    </div>
	</div>
	<div class="span4">
		<div class="span4" id="list">
			<div class="widget widget-table">
	      <div class="widget-header">
          <i class="icon-shopping-list"></i>
          <h3>Your Shopping List</h3> 
	      </div>
	      <div class="widget-content">
	      	<table id="shoppingList" class="table table-striped table-bordered">
	          <thead>
	            <tr>
	              <th>Quantity</th>
	              <th>Unit</th>
	              <th>Name</th>
	              <th>Remove</th>
	            </tr>
	          </thead>
	          <tbody>
	            
	          </tbody>
	        </table>
				</div>				     
	    </div>						
			<div class="row">
			<div class="span4" id="submitSpan">
        <input disabled="disabled" type="button" class="finishconfirm pull-right disabled btn btn-info" value="Continue &raquo;" />
			</div>      
			</div>
			<br />
			<div class="alert alert-success">      
	      <h3 class="alert-heading">How it works...</h3>
	      <ol class="faq-list">
	      	<li id="faq-1">
	      		<div class="faq-icon">
      			  <div class="circle-icon faq-circle-icon">
      			  	<div>1</div>
							</div>
						</div>
						<div class="faq-text">
							 <h4>Detail Your Requirments</h4>
							 <p>You enter the products you need, your details and where your want your goods delivered.</p>
            </div>
					</li>
					<li id="faq-2">
            <div class="faq-icon">
              <div class="circle-icon faq-circle-icon">
                <div>2</div>
              </div>
            </div>
            <div class="faq-text">
            	<h4>We find you the best deals</h4>
              <p>We submit your requirements to independent merchants close to your location.</p>
            </div>
          </li>
					<li id="faq-3">
            <div class="faq-icon">
              <div class="circle-icon faq-circle-icon">
                <div>3</div>
              </div>
            </div>
            <div class="faq-text">
            	<h4>You choose the deal that suits</h4>
              <p>You get your quotes delivered via email, which you can act upon and complete direct with the merchants</p>
            </div> 
          </li>
				</ol>	      	
        <h4>It couldn't be any simpler!</h4>

	    </div>		
			</div>
	</div>
</div>
</form>
</cfoutput>   