<cfset getMyPlugin(plugin="jQuery").getDepends("form","home/cemco","public/home/signup,public/home/signupcemco,secure/form",true)>
<div class="sixtyReverse">
  <div class="w" id="ajaxMain">
    <div class="cemcoIntro">
      <h3>You're just a moment away from creating your Building Vine&trade; account.</h3>
      <img src="/includes/images/cemco.png" align="left" style="margin: 5px 6px 8px 0px;" alt="CEMCO" />
      <p>We've partnered with CEMCO to give you a 50% discount - and direct integration into the CEMCO intranet. Just fill in your details below and you'll be setup in just a minute. Required fields are indicated with <b style="color: red;">*</b>.
      </p>
    </div>

    <form id="signUpForm" action="/signup/doCEMCO" method="post" enctype="multipart/form-data">
      <input type="hidden" name="companyType" value="Supplier" />
      <input type="hidden" value="cemco" name="group" />
      <input type="hidden" value="" name="cemcosupplierID" />
      <input type="hidden" value="" name="cemcocontactID" />
      <cfoutput><input type="hidden" id="captcha_check" name="captcha_check" value="#rc.captcha_check#" /></cfoutput>
      <div class="formmessage"></div>
      <cfoutput>
      <div class="signUp form roundCorners">
        <h2 class="stage1">Primary login information</h2>
        <h4>Please ensure your email is valid, you'll need to verify it before you can login to Building Vine&trade;.</h4>
        <div>
          <label for="first_name">First Name<em>*</em></label>
          <input size="50" class="helptip" title="Your first Name" type="text" name="first_name" id="first_name" value="">
        </div>
        <div>
          <label for="surname">Surname<em>*</em></label>
          <input size="50" class="helptip" title="Your Last Name" type="text" name="surname" id="surname" value="">
        </div>
        <div>
          <label for="email">Email Address<em>*</em></label>
          <input size="50" class="helptip" title="Your email Address" type="text" name="email" id="email" value="">
        </div>
        <div>
          <label for="password">Password<em>*</em></label>
          <input class="helptip" title="Create a password" type="password" name="password1" id="password1" value="">
        </div>
        <div>
          <label for="password2">Password (again)<em>*</em></label>
          <input class="helptip" title="Repeat your password" type="password" name="password2" id="password2" value="">
        </div>
      </div>

      <div id="stage2" class="signUp form roundCorners">
        <h2 class="stage2">Company Information</h2>
        <div>
          <label for="companyName">Company Name<em class="show">*</em></label>
          <input size="50" class="helptip" title="The Full name of your company" value="" type="text" name="companyName" id="companyName">
        </div>
        <div>
          <label for="companyName">Company Logo</label>
          <input class="helptip" title="Upload your company logo!" type="file" name="companyLogo" id="companyLogo">
        </div>
        <div>
          <label for="companyAddress">Company Address</label>
          <textarea name="companyAddress" id="companyAddress"></textarea>
        </div>
        <div>
          <label for="postcode">ZIP/Postal Code<em class="show">*</em></label>
          <input class="helptip" title="Company Postcode" type="text" name="postcode" id="postcode" value="">
        </div>
        <div>
          <label class="o" for="web">Website<em class="show">*</em>:</label>
          <input size="50" type="text" name="web" id="web" value="" />
        </div>
        <div>
          <label class="o" for="switchboard">Telephone<em class="show">*</em>:</label>
          <input type="text" name="switchboard" id="switchboard" value="" />
        </div>
        <!---
        <div>
          <label class="o" for="cba">CBA Supplier Too?</label>
          <div class="confirmGroup">
            <div class="confirmCheck">
              <input type="checkbox" value="cba" name="group" id="cba" />
            </div>
            <div class="confirmtext">If you supply the CBA Group, tick this box and we'll integrate your data into the CBA Group Intranet.</div>
          </div>
          <br class="clear" />
        </div>
        <div>
          <label class="o" for="handb">h&amp;b Supplier Too?</label>
          <div class="confirmGroup">
            <div class="confirmCheck">
              <input type="checkbox" value="handb" name="group" id="handb" />
            </div>
            <div class="confirmtext">If you supply the h&b Group, tick this box and we'll integrate your data into the h&amp;b Group Intranet.</div>
          </div>
          <br class="clear" />

        </div>
        --->
      </div>
      <div class="signUp form roundCorners">
        <h2 class="stage3">Additional Users</h2>
        <h4>You can setup up to four additional users/managers - they'll get an automatically generated password and an introduction email. <a href="##" class="show" rel="additionalUsers">I'd like to setup additional users &raquo;</a></h4>
        <div id="additionalUsers" class="hidden">
          <fieldset>
            <legend>User 1</legend>
            <div>
              <label for="first_name1">First Name</label>
              <input size="50" class="helptip" title="User 1 first Name" type="text" name="first_name1" id="first_name1">
            </div>
            <div>
              <label for="last_name1">Last Name</label>
              <input size="50" class="helptip" title="User 1 last Name" type="text" name="last_name1" id="last_name1">
            </div>
            <div>
              <label for="email1">Email Address</label>
              <input size="50" class="helptip" title="User 1 email address" type="text" name="email1" id="email1">
            </div>
          </fieldset>
          <fieldset>
            <legend>User 2</legend>
            <div>
              <label for="first_name2">First Name</label>
              <input size="50" class="helptip" title="User 2 first Name" type="text" name="first_name2" id="first_name2">
            </div>
            <div>
              <label for="last_name2">Last Name</label>
              <input size="50" class="helptip" title="User 2 last Name" type="text" name="last_name2" id="last_name2">
            </div>
            <div>
              <label for="email2">Email Address</label>
              <input size="50" class="helptip" title="User 2 email address" type="text" name="email2" id="email2">
            </div>
          </fieldset>
          <fieldset>
            <legend>User 3</legend>
            <div>
              <label for="first_name3">First Name</label>
              <input size="50" class="helptip" title="User 3 first Name" type="text" name="first_name3" id="first_name3">
            </div>
            <div>
              <label for="last_name3">Last Name</label>
              <input size="50" class="helptip" title="User 3 last Name" type="text" name="last_name3" id="last_name3">
            </div>
            <div>
              <label for="email3">Email Address</label>
              <input size="50" class="helptip" title="User 3 email address" type="text" name="email3" id="email3">
            </div>
          </fieldset>
          <fieldset>
            <legend>User 4</legend>
            <div>
              <label for="first_name4">First Name</label>
              <input size="50" class="helptip" title="User 4 first Name" type="text" name="first_name4" id="first_name4">
            </div>
            <div>
              <label for="last_name4">Last Name</label>
              <input size="50" class="helptip" title="User 4 last Name" type="text" name="last_name4" id="last_name4">
            </div>
            <div>
              <label for="email4">Email Address</label>
              <input size="50" class="helptip" title="User 4 email address" type="text" name="email4" id="email4">
            </div>
          </fieldset>
        </div>
      </div>
      <div class="signUp form roundCorners">
        <h2 class="stage4">Confirmation</h2>
        <div>
            <label for="accept">Please Confirm<em>*</em></label>
            <div class="confirmGroup">
              <div class="confirmCheck">
                <input class="" title="" type="checkbox" name="termsconfirm" id="termsconfirm">
              </div>
              <div class="confirmtext">I agree to the cost of &pound;500 per annum (payable to CEMCO Merchant Network Limited), and have read and agree to the <a target="_blank" href="/pages/terms">terms and conditions</a> of use.</div>
            </div>
            <br class="clear" />
        </div>
        <div>
          <label for="captcha">Enter the code<em>*</em></label>
          <input type="text" class="helptip" title="Enter the code you see below" name="captcha" id="captcha" />
          <div class="captcha"><cfimage action="captcha" difficulty="low" width="250" height="50" fontsize="22" text="#rc.strCaptcha#" /></div>
          <br class="clear" />
        </div>
      </div>
      </cfoutput>
      <div id="formmessage" class="hidden error">
        <h3>Some errors occurred, which need to be resolved before we can setup your account.</h3>
      </div>
      <input type="submit" value="register now &raquo;" class="submit" />
    </form>
  </div>
</div>
<div class="fourtyReverse">
  <div id="siteList">
  <h2>Join these outstanding visionary companies!</h2>
  <cfquery name="newSites" datasource="bvine">select * from site where active = <cfqueryparam cfsqltype="cf_sql_varchar" value="true">;</cfquery>
  <cfoutput query="newSites">
    <cfset uImage = paramImage("companies/#shortName#/small.jpg","companies/generic.jpg")>
    <a href="/sites/#shortName#"><img title="#xmlFormat(title)#" class="tooltip glow" width="46" height="46" alt="#xmlFormat(title)#" src="/includes/images/#uImage#" /></a>
  </cfoutput>
  </div>
</div>
