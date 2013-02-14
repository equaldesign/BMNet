<cfset getMyPlugin(plugin="jQuery").getDepends("validate,form,lightbox","sites/3/signup","jQuery/lightbox/style",false)>
<cfoutput>
<div id="content" class="row">
  <div class="span8">
    <div class="wht">
      <h2 class="page-heading">Get started with a 30-day free trial!</h2>
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
      <form action="/signup/do" class="form form-horizontal" method="post">
        <fieldset>
          <div class="media">
            <a class="pull-left" href="##" style="color: rgb(0, 85, 128); text-decoration: underline; outline: 0px; margin-right: 10px;"><img class="media-object" src="http://d25ke41d0c64z1.cloudfront.net/images/icons/bonus/icons-32/stage1.png"></a>
            <div class="media-body">
              <h4 class="media-heading">Buying Group Integration</h4>
              <p>Are you a member or supplier of CEMCO, The CBA Group, NBG or the h&amp;b Group? If so, you can <i><strong>optionally</strong></i> enter your username and password and select your buying group, and we can integrate your two accounts. We can also populate the below fields with your information automatically to save you some time.</p>
            </div>
            <div class="alert alert-info">
              <button class="close" data-dismiss="alert">&times;</button>
              <p>If you are not a member of the above buying groups, you can skip to the next section.</p>
            </div>
            <div class="control-group">
              <label class="control-label" for="web">Buying Group</label>
              <div class="controls">
                <select id="eGroup_datasource" name="eGroup_datasource">
                  <option value="">--choose your buying group--</option>
                  <option value="eGroup_cemco">The CEMCO Merchant Network</option>
                  <option value="eGroup_cbagroup">The CBA Group</option>
                  <option value="eGroup_nbg">The National Buying Group</option>
                  <option value="eGroup_handbgroup">The h&amp;b Group</option>
                </select>
              </div>
            </div>
            <div class="control-group">
              <label class="control-label" for="web">Buying Group Username</label>
              <div class="controls">
                <input type="text" name="eGroup_username" id="eGroup_username" value="">
              </div>
            </div>
            <div class="control-group">
              <label class="control-label" for="web">Buying Group Password</label>
              <div class="controls">
                <input type="password" name="eGroup_password" id="eGroup_password" value=""><br />
              </div>
            </div>
            <div class="form-actions">
              <button type="button" id="getBuyingGroupInfo" class="btn btn-success"><i class="icon-magnifier"></i> Lookup my information</button>
            </div>
          </div>
          <hr />
        </fieldset>
        <fieldset>
          <div class="media">
            <a class="pull-left" href="##" style="color: rgb(0, 85, 128); text-decoration: underline; outline: 0px; margin-right: 10px;"><img class="media-object" src="http://d25ke41d0c64z1.cloudfront.net/images/icons/bonus/icons-32/stage2.png"></a>
            <div class="media-body">
              <h4 class="media-heading">Your information</h4>
              <p>In this section, please tell us about yourself. We are genuinely interested, but in fact we really need it to create your administrator account.<br>
            </div>
          </div>
          <hr />
          <div class="control-group">
            <label class="control-label #isErrorField('first_name')#">First Name <em>*</em></label>
            <div class="controls">
              <input class="#isErrorField('first_name')#" value="#paramValue('rc.first_name','')#" type="text" id="first_name" name="Full_name" placeholder="please enter your first name" />
            </div>
          </div>
          <div class="control-group">
            <label class="control-label #isErrorField('surname')#">Surname <em>*</em></label>
            <div class="controls">
              <input class="#isErrorField('surname')#" value="#paramValue('rc.surname','')#" type="text" id="surname" name="surname" placeholder="please enter your surname" />
            </div>
          </div>
          <div class="control-group">
            <label class="control-label #isErrorField('email')#">Your Email Address <em>*</em></label>
            <div class="controls">
              <input type="text" id="email" value="#paramValue('rc.email','')#" class="#isErrorField('email')#"  name="email" placeholder="you@yourdomain.com" />
            </div>
          </div>
          <div class="control-group">
            <label class="control-label #isErrorField('password')#">Password <em>*</em></label>
            <div class="controls">
              <input type="password"  value="#paramValue('rc.password','')#" class="#isErrorField('password1')#"  id="password" name="password" placeholder="Create a password" />
            </div>
          </div>
          <div class="control-group">
            <label class="control-label #isErrorField('password')#">Password confirmation <em>*</em></label>
            <div class="controls">
              <input type="password" value="#paramValue('rc.password2','')#" id="password2" class="#isErrorField('password')#"  name="password2" placeholder="Repeat your new password" />
            </div>
          </div>
        </fieldset>
        <fieldset>
          <div class="media">
            <a class="pull-left" href="##" style="color: rgb(0, 85, 128); text-decoration: underline; outline: 0px; margin-right: 10px;"><img class="media-object" src="http://d25ke41d0c64z1.cloudfront.net/images/icons/bonus/icons-32/stage3.png"></a>
            <div class="media-body">
              <h4 class="media-heading">Business Details</h4>
              <p>In this section, please tell us about your business.
            </div>
          </div>
          <hr />
          <div class="control-group">
            <label class="control-label #isErrorField('business_name')#">Business Name <em>*</em></label>
            <div class="controls">
              <input type="text" value="#paramValue('rc.business_name','')#" id="company_name" class="#isErrorField('business_name')#"  name="business_name" placeholder="Your business name" />
            </div>
          </div>
          <div class="control-group">
            <label class="control-label #isErrorField('sitename')#">Custom URL <em>*</em></label>
            <div class="controls">
              <div class="input-append">
                <input type="text" value="#paramValue('rc.sitename','')#"  id="siteName" name="siteName" placeholder="Your custom URL" class="input-medium class="#isErrorField('sitename')#"" />
                <span class="add-on">.buildersmerchant.net</span>
              </div>
              <p class="help-block">Your will be given a temporary BuildersMerchant.net URL, in the format http://<i>yoursite</i>.buildersmerchant.net. This must be a single word, without any special characters.
            </div>
          </div>
          <div class="control-group">
            <label class="control-label" for="companyAddress">Company Address</label>
            <div class="controls">
              <textarea name="companyAddress" id="companyAddress">#paramValue('rc.companyAddress','')# </textarea>
            </div>
          </div>
          <div class="control-group">
            <label class="control-label #isErrorField('postcode')#" for="postcode">ZIP/Postal Code <em>*</em></label>
            <div class="controls">
              <input class="helptip" value="#paramValue('rc.postcode','')#"  type="text" name="postcode" id="postcode" original-title="Company Postcode">
            </div>
          </div>
          <div class="control-group">
            <label class="control-label" for="companyType">Company Type <em>*</em></label>
            <div class="controls">
              <select name="companyType" id="companyType">
                <option value="">--choose--</option>
                <option value="Merchant">Merchant</option>
                <option value="Supplier">Supplier</option>
                <option value="BuyingGroup">Buying Group</option>
                <option value="Federation">Federation</option>
                <option value="Other">Other</option>
              </select>
            </div>
          </div>
          <div class="control-group">
            <label class="control-label" for="web">Website</label>
            <div class="controls">
              <input type="text" name="web" id="web" value="#paramValue('rc.web','')#" >
            </div>
          </div>
          <div class="control-group">
            <label class="control-label" for="switchboard">Telephone</label>
            <div class="controls">
              <input type="text" name="switchboard" id="switchboard" value="#paramValue('rc.switchboard','')#" >
            </div>
          </div>
        </fieldset>
        <fieldset>
          <div class="media">
            <a class="pull-left" href="##" style="color: rgb(0, 85, 128); text-decoration: underline; outline: 0px; margin-right: 10px;"><img class="media-object" src="http://d25ke41d0c64z1.cloudfront.net/images/icons/bonus/icons-32/stage4.png"></a>
            <div class="media-body">
              <h4 class="media-heading">Layout and data</h4>
              <p>Your free trial will be setup with an example layout. Please pick your favourite below</p>
            </div>
            <div class="control-group">
              <label class="control-label">
                Template
              </label>
              <div class="controls" id="examples">
                <div class="media">
                  <a class="pull-left lightbox" href="https://www.buildingvine.com/api/i?size=550&nodeRef=dba07c69-a8ed-4409-a89a-00920963126d"><img src="https://www.buildingvine.com/api/i?size=150&nodeRef=dba07c69-a8ed-4409-a89a-00920963126d" class="img-polaroid media-object" /></a>
                  <div class="media-body">
                    <label class="radio"><input type="radio" name="template" value="demo1" checked="true"><h4 class="media-heading">Demo Template 1</h4></label>
                    <p><a target="_blank" href="http://demo1.buildersmerchant.net">Visit example website <i class="icon-applications"></i></a></p>
                    <p>High Impact ecommerce site</p>
                  </div>
                </div>
                <div class="media">
                  <a class="pull-left lightbox" href="https://www.buildingvine.com/api/i?size=550&nodeRef=47e95028-3795-48aa-a454-52b0630ed572"><img src="https://www.buildingvine.com/api/i?size=150&nodeRef=47e95028-3795-48aa-a454-52b0630ed572" class="img-polaroid media-object" /></a>
                  <div class="media-body">
                    <label class="radio"><input type="radio" name="template" value="demo2"><h4 class="media-heading">Demo Template 2</h4></label>
                    <p><a target="_blank" href="http://demo2.buildersmerchant.net">Visit example website <i class="icon-applications"></i></a></p>
                    <p>
                      Corporate ecommerce website
                    </p>
                  </div>
                </div>
                <div class="media">
                  <a class="pull-left lightbox" href="https://www.buildingvine.com/api/i?size=550&nodeRef=dba07c69-a8ed-4409-a89a-00920963126d"><img src="https://www.buildingvine.com/api/i?size=150&nodeRef=dba07c69-a8ed-4409-a89a-00920963126d" class="img-polaroid media-object" /></a>
                  <div class="media-body">
                    <label class="radio"><input type="radio" name="template" value="demo3"><h4 class="media-heading">Demo Template 3</h4></label>
                    <p><a target="_blank" href="http://demo3.buildersmerchant.net">Visit example website <i class="icon-applications"></i></a></p>
                    <p>
                      Stylish non-ecommerce website
                    </p>
                  </div>
                </div>
              </div>
            </div>
            <div class="control-group">
              <label class="control-label" for="web">Data population</label>
              <div class="controls">
                <label class="checkbox">
                  <input type="checkbox" name="populate" value="pages" checked="true">
                  Create some example pages
                </label>
                <label class="checkbox">
                  <input type="checkbox" name="populate" value="eunify" checked="true">
                  Populate the system with example data
                </label>
              </div>
            </div>
            <div class="control-group">
              <label class="control-label" for="web">Security:</label>
              <div class="controls">
                <cf_recaptcha theme="white" privateKey="6LcuftoSAAAAAGgL4xMKrrJATSUOZTPQXQZMdAxb" publicKey="6LcuftoSAAAAAHbm13T0QpzfN8tjgkeeyGbBsN8s">
              </div>
            </div>
          </div>
        </fieldset>
        <div class="form-actions">
          <button class="btn btn-success" type="submit">Start my free Trial!</button>
        </div>
      </form>
    </div>
  </div>
  <div class="span4">
    <div class="alert alert-success">
      <h3 class="alert-heading">How does the 30-day free trial work?</h3>
      <p>You can cancel a business or enterprise account within 30 days of signing up you won't be charged a thing. If you do choose to cancel your account in the future you will never be charged again, but you are responsible for charges already incurred up until your cancellation. Refunds can not be issued after your initial 30 day trial and we don't prorate for partial months.</p>
      <h3 class="alert-heading">Are there per-user fees?</h3>
      <p>No. The business account, and enterprise account you see above are all inclusive. For example, the Business account is £990/year for up to 30 users. That means you pay &pound;990/year total no matter how many users you have as long as it's 30 or less.</p>
      <h3 class="alert-heading">What types of payment do you accept?</h3>
      <p>Currently we accept Visa, Mastercard, and American Express. We do not accept PayPal. We're also happy to invoice you (but you have to pay by BACs - no cheques), and we'll take payment over the phone.</p>
    </div>
  </div>
</div>
</cfoutput>