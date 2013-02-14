<cfoutput>
<h2><cfif rc.company.getNodeRef() eq "">New<cfelse>Edit</cfif> #rc.type#</h2>
<div class="form">
  <form action="/bv/customers/doEdit" method="post" id="createCustomer">
    <input type="hidden" name="type" value="#rc.type#" />
    <input type="hidden" name="nodeRef" value="#rc.company.getNodeRef()#" />
     <input type="hidden" name="qualified" value="true" />
    <input type="hidden" name="siteID" value="#rc.siteID#" />
    <fieldset>
      <legend>Details</legend>
      <div>
        <label for="companyID">ID<em>*</em></label>
        <cfif rc.company.getcompanyID() eq "">
          <cfset companyID = createUUID()>
        <cfelse>
          <cfset companyID = rc.company.getcompanyID()>
        </cfif>
        <input size="35" type="text" name="companyID" id="companyID" value="#companyID#" />
      </div>
      <div>
        <label for="name">Company Name<em>*</em></label>
        <input size="50" type="text" name="name" id="name" value="#rc.company.getname()#"/>
      </div>
      <div>
        <label for="phone">Description</label>
        <textarea name="description" id="phone">#rc.company.getdescription()#</textarea>
      </div>
      <div>
        <label for="employees">No. of Employees</label>
        <input size="5" type="text" name="employees" id="employees" value="#rc.company.getemployees()#" />
      </div>
      <div>
        <label for="industry">Industry</label>
        <input size="30" type="text" name="industry" id="industry" value="#rc.company.getindustry()#" />
      </div>
      <div>
        <label for="annualRevenue">Annual Revenue</label>
        <input type="text" name="annualRevenue" id="annualRevenue" value="#rc.company.getannualRevenue()#" />
      </div>
    </fieldset>
    <fieldset>
      <legend>Contact Information</legend>
      <div>
        <label for="phone">Phone</label>
        <input size="15" type="text" name="phone" id="phone" value="#rc.company.getphone()#" />
      </div>
      <div>
        <label for="fax">Fax</label>
        <input size="15" type="text" name="fax" id="fax" value="#rc.company.getfax()#" />
      </div>
      <div>
        <label for="phoneAlternate">Phone Alt.</label>
        <input size="15" type="text" name="phoneAlternate" id="phoneAlternate" value="#rc.company.getphoneAlternate()#" />
      </div>
      <div>
        <label for="companyEmail">Email</label>
        <input size="30" type="text" name="companyEmail" id="companyEmail" value="#rc.company.getcompanyEmail()#" />
      </div>
      <div>
        <label for="website">website</label>
        <input size="30" type="text" name="website" id="website" value="#rc.company.getwebsite()#" />
      </div>
    </fieldset>
    <fieldset>
      <legend>Billing Information</legend>
      <div>
        <label for="billingName">Billing Name</label>
        <input type="text" name="billingName" id="billingName" value="#rc.company.getwebsite()#" />
      </div>
      <div>
        <label for="billingAddress1">Billing Address 1</label>
        <input type="text" name="billingAddress1" id="billingAddress1" value="#rc.company.getbillingAddress1()#" />
      </div>
      <div>
        <label for="billingAddress2">Billing Address 2</label>
        <input type="text" name="billingAddress2" id="billingAddress2" value="#rc.company.getbillingAddress2()#" />
      </div>
      <div>
        <label for="billingAddress3">Billing Address 3</label>
        <input type="text" name="billingAddress3" id="billingAddress3" value="#rc.company.getbillingAddress3()#" />
      </div>
      <div>
        <label for="billingTown">Billing Town</label>
        <input type="text" name="billingTown" id="billingTown" value="#rc.company.getbillingTown()#" />
      </div>
      <div>
        <label for="billingCounty">Billing County</label>
        <input type="text" name="billingCounty" id="billingCounty" value="#rc.company.getbillingCounty()#" />
      </div>
      <div>
        <label for="billingPostCode">Billing PostCode</label>
        <input size="10" type="text" name="billingPostCode" id="billingPostCode" value="#rc.company.getbillingPostCode()#" />
      </div>
      <div>
        <label for="billingCountry">Billing Country</label>
        <input type="text" name="billingCountry" id="billingCountry" value="#rc.company.getbillingCountry()#" />
      </div>
    </fieldset>
    <fieldset>
      <legend>Delivery Information</legend>
      <div>
        <label for="deliveryName">Delivery Name</label>
        <input type="text" name="deliveryName" id="deliveryName" value="#rc.company.getdeliveryName()#" />
      </div>
      <div>
        <label for="deliveryddress1">Delivery Address 1</label>
        <input type="text" name="deliveryAddress1" id="deliveryAddress1" value="#rc.company.getdeliveryAddress1()#" />
      </div>
      <div>
        <label for="deliveryAddress2">Delivery Address 2</label>
        <input type="text" name="deliveryAddress2" id="deliveryAddress2" value="#rc.company.getdeliveryAddress2()#" />
      </div>
      <div>
        <label for="deliveryAddress3">Delivery Address 3</label>
        <input type="text" name="deliveryAddress3" id="deliveryAddress3" value="#rc.company.getdeliveryAddress3()#" />
      </div>
      <div>
        <label for="deliveryTown">Delivery Town</label>
        <input type="text" name="deliveryAddressTown" id="deliveryAddressTown" value="#rc.company.getdeliveryAddressTown()#" />
      </div>
      <div>
        <label for="deliveryCounty">Delivery County</label>
        <input type="text" name="deliveryAddressCounty" id="deliveryAddressCounty" value="#rc.company.getdeliveryAddressCounty()#" />
      </div>
      <div>
        <label for="deliveryPostCode">Delivery PostCode</label>
        <input size="10" type="text" name="deliveryAddressPostCode" id="deliveryAddressPostCode" value="#rc.company.getdeliveryAddressPostCode()#" />
      </div>
      <div>
        <label for="deliveryCountry">Delivery Country</label>
        <input type="text" name="deliveryAddressCountry" id="deliveryAddressCountry" value="#rc.company.getdeliveryAddressCountry()#" />
      </div>
    </fieldset>
    <input type="submit" class="button" value="<cfif rc.company.getNodeRef() eq "">Create New<cfelse>Edit</cfif> customer" />
  </form>
</div>
</cfoutput>
