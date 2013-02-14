<form class="form-horizontal" id="register" method="post" action="/eunify/company/doEdit">
<fieldset>
  <legend>New Users</legend> 
  <div class="control-group">
    <label class="control-label" for="default_contact_firstname">First Name<em>*</em></label>
    <div class="controls">
     <input type="text" id="default_contact_firstname" name="default_contact_firstname" size="20" class="" value="">
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="default_contact_surname">Surname<em>*</em></label>
    <div class="controls">
     <input type="text" id="default_contact_surname" name="default_contact_surname" size="20" class="" value="">
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="name">Company Name</label>
    <div class="controls">
     <input type="text" id="name" name="name" size="20" class="" value="">
    </div>
  </div>
  <div class="control-group"> 
    <label class="control-label" for="company_address_1">Address 1<em>*</em></label>
    <div class="controls">
      <input type="text" id="company_address_1" name="company_address_1" size="20" class="" value="">
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="company_address_2">Address 2</label>
    <div class="controls">
      <input type="text" id="company_address_2" name="company_address_2" size="20" class="" value="">
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="company_address_3">Address 3</label>
    <div class="controls">
      <input type="text" id="company_address_3" name="company_address_3" size="20" class="" value="">
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="company_address_4">Town<em>*</em></label>
    <div class="controls">
      <input type="text" id="company_address_4" name="company_address_4" size="20" class="" value="">
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="company_address_5">County</label>
    <div class="controls">
      <input type="text" id="company_address_5" name="company_address_5" size="20" class="" value="">
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="postcode">Postcode<em>*</em></label>
    <div class="controls">
      <div class="input-prepend">
        <span class="add-on"><i class="icon-postcode"></i></span>
        <input type="text" id="postcode" name="postcode" size="10" class="input-small">
      </div>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="company_phone">Phone number<em>*</em></label>
    <div class="controls">
      <div class="input-prepend">
        <span class="add-on"><i class="icon-phone"></i></span>
        <input type="text" id="company_phone" name="company_phone" size="20" class="input-small">
      </div>      
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="default_contact_mobile">Mobile number</label>
    <div class="controls">
      <div class="input-prepend">
        <span class="add-on"><i class="icon-mobile"></i></span>
        <input type="text" name="default_contact_mobile" size="20" class="input-small" value="">
      </div>      
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="default_contact_email">Email Address<em>*</em></label>
    <div class="controls">
      <div class="input-prepend">
        <span class="add-on"><i class="icon-email"></i></span>
        <input type="text" id="default_contact_email" name="default_contact_email" size="20" class="">
      </div>      
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="password">Password <em>*</em></label>
    <div class="controls">
      <div class="input-prepend">
        <span class="add-on"><i class="icon-lock"></i></span>
        <input id="password" type="password" size="15" class="" name="password" />
      </div>
    </div>
  </div>
  <div class="control-group">
    <label class="control-label" for="password2">Confirm Password <em>*</em></label>
    <div class="controls">
      <div class="input-prepend">
        <span class="add-on"><i class="icon-lock"></i></span>
        <input id="password2" type="password" size="15"class="" name="password2" />
      </div>
    </div>
  </div>
  <div class="form-actions">
    <button type="submit" class="btn btn-info">Continue &raquo;</button> 
  </div>
</fieldset>
<input type="hidden" name="type_id" value="2" />
<input type="hidden" name="sendLogin" value="true" />
<input type="hidden" name="eGroup_id" value="0" />
<input type="hidden" name="doBuildingVine" value="false">
</form>  