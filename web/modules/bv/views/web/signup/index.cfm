<cfset getMyPlugin(plugin="jQuery").getDepends("form,validate","home/signup","",true,"bv")>
<div class="row-fluid">
	  <div class="span8">
	  <h2>You are just a few moments away from creating your Building Vine account.</h2>
	  <p>We need to take some details from you, and required fields are indicated with <b style="color: red;">*</b>. 
    The other fields do not need to be entered, but we'd appreciate it if you did take the time to fill these in too.</p>
	  <form class="form form-horizontal" id="signUpForm" action="/signup/do" method="post">	    
         
	    <fieldset>
        <legend>Select an account type</legend>
	    	<div id="fdw-pricing-table" class="row-fluid">
          <label class="plan plan1 span4">
              <div class="header">Personal</div>
              <div class="price">Free</div>                
              <ul>
                <li><i class="icon-drill"></i>Access Product Data</li>
                <li><i class="icon-key-solid"></i>API (website integration) key</li>
                <li><i class="icon-tick-circle-frame"></i>No useage limits</li>
                <li><i class="icon-mail-send-receive"></i>Email updates</li>
                <li><i class="icon-network-cloud"></i>Network Drive Access</li>                
              </ul>
              <span class="label label-success hide">SELECTED!</span>
              <input id="access_personal" type="radio" name="access_type" class="hide access_type" value="personal" />              
          </label>
          <label class="plan plan2 popular-plan span4 selected">
              <div class="header">Business</div>
              <div class="price">&pound;490</div>
              <div class="monthly">per annum (plus VAT)</div>  
              <ul>
                <li><i class="icon-drill"></i>Access Product Data</li>
                <li><i class="icon-key-solid"></i>API (website integration) key</li>
                <li><i class="icon-tick-circle-frame"></i>No useage limits</li>
                <li><i class="icon-mail-send-receive"></i>Email updates</li>
                <li><i class="icon-network-cloud"></i>Network Drive Access</li>         
                <li><i class="icon-building"></i>Add your company information</li>         
                <li><i class="icon-newspaper"></i>Add company press releases</li>         
                <li><i class="icon-sitemap"></i>Intranet Integration</li>         
                <li><i class="icon-drill--plus"></i>Add product database</li>         
                <li><i class="icon-coins"></i>Add product price files</li>         
                <li><i class="icon-store"></i>Add secure promotions</li>         
                <li><i class="icon-mobile"></i>Telephone support</li>  
              </ul>
              <span class="label label-success hide">SELECTED!</span>
              <input id="access_merchant" checked="checked" type="radio" name="access_type" class="hide access_type" value="merchant" />              
          </label>
          <label class="plan plan3 span4">
              <div class="header">Basic</div>
              <div class="price">&pound;290</div>
              <div class="monthly">per annum (plus VAT)</div>
              <ul>
                <li><i class="icon-drill"></i>Access Product Data</li>
                <li><i class="icon-key-solid"></i>API (website integration) key</li>
                <li><i class="icon-tick-circle-frame"></i>No useage limits</li>
                <li><i class="icon-mail-send-receive"></i>Email updates</li>
                <li><i class="icon-network-cloud"></i>Network Drive Access</li>         
                <li><i class="icon-building"></i>Add your company information</li>         
                <li><i class="icon-newspaper"></i>Add company press releases</li>         
                <li><i class="icon-sitemap"></i>Intranet Integration</li>                         
                <li><i class="icon-mail"></i>Email support</li>  
              </ul>
              <span class="label label-success hide">SELECTED!</span>
              <input id="access_supplier" type="radio" name="access_type" class="hide access_type" value="supplier" />              
          </label>          
        </div>
		  </fieldset>           
      <fieldset id="stage3">
        <legend>Integration options</legend>   
        <div class="control-group">
          <label class="control-label" for="CEMCO">Buying Group Membership</label>
          <div class="controls">
            <label class="checkbox">
              <input type="checkbox" value="cemco" name="group" id="cemco" class="validateeGroup" />
              CEMCO Merchant Network              
            </label>
            <div class="loginInfo hide">
              <div class="input-append input-prepend">
                <input class="username input-medium" type="text" name="cemco.login" placeholder="CEMCO username" />
                <input class="password input-small" type="password" name="cemco.pass" placeholder="password" />
                <input type="button" class="btn checkCredentials" value="check credentials" data-for="eGroup_cemco"  />        
              </div>
              <p class="help-block">Enter your credentials above to verify integration</p>      
            </div>
            <label class="checkbox">
              <input type="checkbox" value="cba" name="group" id="cba" class="validateeGroup" />
              CBA Group              
            </label>
            <div class="loginInfo hide">
              <div class="input-append input-prepend">
                <input class="username input-medium" type="text" name="cemco_login"  placeholder="CBA username" />
                <input class="password input-small" type="password" id="cemco_pass"  placeholder="password" />
                <input type="button" class="btn checkCredentials" value="check credentials" data-for="eGroup_cbagroup" />
              </div>
              <p class="help-block">Enter your credentials above to verify integration</p>
            </div>
            <label class="checkbox">
              <input type="checkbox" value="handb" name="group" id="handb" class="validateeGroup" />
              h&amp;b Group              
            </label>
            <div class="loginInfo hide">
              <div class="input-append input-prepend">
                <input class="username input-medium" type="text" id="cemco_login" placeholder="h&amp;b username" />
                <input class="password input-small" type="password" id="cemco_pass" placeholder="password" />
                <input type="button" class="btn checkCredentials" value="check credentials" data-for="eGroup_handbgroup" />
              </div>
              <p class="help-block">Enter your credentials above to verify integration</p>
            </div>
            <label class="checkbox">
              <input type="checkbox" value="nbg" name="group" id="nbg" class="validateeGroup" />
              NBG (National Buying Group)              
            </label>
            <div class="loginInfo hide">
              <div class="input-append input-prepend">
                <input class="username input-medium" type="text" id="cemco_login" placeholder="NBG username" />
                <input class="password input-small" type="password" id="cemco_pass" placeholder="password" />
                <input type="button" class="btn checkCredentials" value="check credentials" data-for="eGroup_nbg" />
              </div>
              <p class="help-block">Enter your credentials above to verify integration</p>
            </div>
          </div>
          <div class="control-group">
            <label class="control-label">NMBS Merchant Pages</label>
            <div class="controls">
              <label class="radio">
                <input type="radio" name="nmbs" value="false" checked="checked" class="validateNMBS">
                We are not listed in NMBS Merchant Pages
                <div class="nmbs">
                  <label class="checkbox">
                    <input type="checkbox" name="nmbsSync" value="true" />
                    We'd like to create a <strong>free</strong> account in NMBS Merchant pages and synchronise data                    
                  </label>
                </div>
              </label>
              <label class="radio">
                <input type="radio" name="nmbs" value="true" class="validateNMBS">
                We are already listed in NMBS Merchant Pages
                <div class="nmbs hide">
                  <label class="checkbox">
                    <input type="checkbox" name="nmbsSync" value="true" />
                    We'd like to synchronise data between our Merchant Pages account and Building Vine
                  </label>
                  <div class="input-append">
                    <input type="text" class="input-medium" placeholder="NMBS Supplier Code" />
                    <input type="button" class="btn" id="checkNMBS" value="lookup" />
                  </div>
                  <p class="help-block">Enter your NMBS supplier A/C Number</p>   
                </div>
              </label>
            </div>
          </div>
        </div> 
      </fieldset>
      <fieldset>
        <legend>Login information</legend>
        <div class="control-group">         
          <label class="control-label" for="first_name">First Name<em>*</em></label>
          <div class="controls">
            <input class="helptip" title="Your first Name" type="text" name="first_name" id="first_name" />
          </div>
        </div>
        <div class="control-group">
          <label class="control-label" for="surname">Surname<em>*</em></label>
          <div class="controls">
            <input class="helptip" title="Your Last Name" type="text" name="surname" id="surname" />
          </div>
        </div>
        <div class="control-group">
          <label class="control-label" for="email">Email Address<em>*</em></label>
          <div class="controls">
            <input class="helptip" title="Your email Address" type="text" name="email" id="email" />
            <div class="help-block">Please ensure your email is valid, you'll need to verify it before you can login with Building Vine.</div>
          </div>
        </div>
        <div class="control-group">
          <label class="control-label" for="password">Password<em>*</em></label>
          <div class="controls">
            <input class="helptip" title="Create a password" type="password" name="password1" id="password1" />
          </div>
        </div>
        <div class="control-group">
          <label class="control-label" for="password2">Password (again)<em>*</em></label>
          <div class="controls">
            <input class="helptip" title="Repeat your password" type="password" name="password2" id="password2" />
          </div>
        </div>
      </fieldset>  
	    <fieldset id="stage4">
	    	<legend>Company Information</legend>	    
	      <div class="control-group">
	        <label class="control-label" for="companyName">Company Name </label>
	        <div class="controls">
	        	<input class="helptip" title="The Full name of your company" type="text" name="companyName" id="companyName">
					</div>
	      </div>
	      <div class="control-group">
	        <label class="control-label" for="companyAddress">Company Address</label>
	        <div class="controls">
	        	<textarea name="companyAddress" id="companyAddress"></textarea>
					</div>
	      </div>
	      <div class="control-group">
	        <label class="control-label" for="postcode">ZIP/Postal Code</label>
	        <div class="controls">
	        	<input class="helptip" title="Company Postcode" type="text" name="postcode" id="postcode">
					</div>
	      </div>
	      <div class="control-group hidden" id="m_subs">
	        <label class="control-label" for="subs">No. of members</label>
	        <div class="controls">
	        	<input class="helptip" title="How many members within your group?" size="5" type="text" name="subs" id="subs">
					</div>
	      </div>
	      <div class="control-group hidden" id="m_cost">
	        <label class="control-label" for="cost">Cost (GBP) per annum.</label>
	        <div class="controls">
	        	<input size="5" type="text" name="cost" id="cost">
					</div>
	      </div>
	      <div class="control-group">
	        <label class="control-label" for="companyType">Company Type</label>
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
	        <label class="control-label" for="country">Country</label>
	        <div class="controls">
		        <select id="country" name="Country">
              <option value="" selected="selected">Select Country</option>
              <option value="United States">United States</option>
              <option value="United Kingdom">United Kingdom</option>
              <option value="Afghanistan">Afghanistan</option>
              <option value="Albania">Albania</option>
              <option value="Algeria">Algeria</option>
              <option value="American Samoa">American Samoa</option>
              <option value="Andorra">Andorra</option>
              <option value="Angola">Angola</option>
              <option value="Anguilla">Anguilla</option>
              <option value="Antarctica">Antarctica</option>
              <option value="Antigua and Barbuda">Antigua and Barbuda</option>
              <option value="Argentina">Argentina</option>
              <option value="Armenia">Armenia</option>
              <option value="Aruba">Aruba</option>
              <option value="Australia">Australia</option>
              <option value="Austria">Austria</option>
              <option value="Azerbaijan">Azerbaijan</option>
              <option value="Bahamas">Bahamas</option>
              <option value="Bahrain">Bahrain</option>
              <option value="Bangladesh">Bangladesh</option>
              <option value="Barbados">Barbados</option>
              <option value="Belarus">Belarus</option>
              <option value="Belgium">Belgium</option>
              <option value="Belize">Belize</option>
              <option value="Benin">Benin</option>
              <option value="Bermuda">Bermuda</option>
              <option value="Bhutan">Bhutan</option>
              <option value="Bolivia">Bolivia</option>
              <option value="Bosnia and Herzegovina">Bosnia and Herzegovina</option>
              <option value="Botswana">Botswana</option>
              <option value="Bouvet Island">Bouvet Island</option>
              <option value="Brazil">Brazil</option>
              <option value="British Indian Ocean Territory">British Indian Ocean Territory</option>
              <option value="Brunei Darussalam">Brunei Darussalam</option>
              <option value="Bulgaria">Bulgaria</option>
              <option value="Burkina Faso">Burkina Faso</option>
              <option value="Burundi">Burundi</option>
              <option value="Cambodia">Cambodia</option>
              <option value="Cameroon">Cameroon</option>
              <option value="Canada">Canada</option>
              <option value="Cape Verde">Cape Verde</option>
              <option value="Cayman Islands">Cayman Islands</option>
              <option value="Central African Republic">Central African Republic</option>
              <option value="Chad">Chad</option>
              <option value="Chile">Chile</option>
              <option value="China">China</option>
              <option value="Christmas Island">Christmas Island</option>
              <option value="Cocos (Keeling) Islands">Cocos (Keeling) Islands</option>
              <option value="Colombia">Colombia</option>
              <option value="Comoros">Comoros</option>
              <option value="Congo">Congo</option>
              <option value="Congo, The Democratic Republic of The">Congo, The Democratic Republic of The</option>
              <option value="Cook Islands">Cook Islands</option>
              <option value="Costa Rica">Costa Rica</option>
              <option value="Cote D'ivoire">Cote D'ivoire</option>
              <option value="Croatia">Croatia</option>
              <option value="Cuba">Cuba</option>
              <option value="Cyprus">Cyprus</option>
              <option value="Czech Republic">Czech Republic</option>
              <option value="Denmark">Denmark</option>
              <option value="Djibouti">Djibouti</option>
              <option value="Dominica">Dominica</option>
              <option value="Dominican Republic">Dominican Republic</option>
              <option value="Ecuador">Ecuador</option>
              <option value="Egypt">Egypt</option>
              <option value="El Salvador">El Salvador</option>
              <option value="Equatorial Guinea">Equatorial Guinea</option>
              <option value="Eritrea">Eritrea</option>
              <option value="Estonia">Estonia</option>
              <option value="Ethiopia">Ethiopia</option>
              <option value="Falkland Islands (Malvinas)">Falkland Islands (Malvinas)</option>
              <option value="Faroe Islands">Faroe Islands</option>
              <option value="Fiji">Fiji</option>
              <option value="Finland">Finland</option>
              <option value="France">France</option>
              <option value="French Guiana">French Guiana</option>
              <option value="French Polynesia">French Polynesia</option>
              <option value="French Southern Territories">French Southern Territories</option>
              <option value="Gabon">Gabon</option>
              <option value="Gambia">Gambia</option>
              <option value="Georgia">Georgia</option>
              <option value="Germany">Germany</option>
              <option value="Ghana">Ghana</option>
              <option value="Gibraltar">Gibraltar</option>
              <option value="Greece">Greece</option>
              <option value="Greenland">Greenland</option>
              <option value="Grenada">Grenada</option>
              <option value="Guadeloupe">Guadeloupe</option>
              <option value="Guam">Guam</option>
              <option value="Guatemala">Guatemala</option>
              <option value="Guinea">Guinea</option>
              <option value="Guinea-bissau">Guinea-bissau</option>
              <option value="Guyana">Guyana</option>
              <option value="Haiti">Haiti</option>
              <option value="Heard Island and Mcdonald Islands">Heard Island and Mcdonald Islands</option>
              <option value="Holy See (Vatican City State)">Holy See (Vatican City State)</option>
              <option value="Honduras">Honduras</option>
              <option value="Hong Kong">Hong Kong</option>
              <option value="Hungary">Hungary</option>
              <option value="Iceland">Iceland</option>
              <option value="India">India</option>
              <option value="Indonesia">Indonesia</option>
              <option value="Iran, Islamic Republic of">Iran, Islamic Republic of</option>
              <option value="Iraq">Iraq</option>
              <option value="Ireland">Ireland</option>
              <option value="Israel">Israel</option>
              <option value="Italy">Italy</option>
              <option value="Jamaica">Jamaica</option>
              <option value="Japan">Japan</option>
              <option value="Jordan">Jordan</option>
              <option value="Kazakhstan">Kazakhstan</option>
              <option value="Kenya">Kenya</option>
              <option value="Kiribati">Kiribati</option>
              <option value="Korea, Democratic People's Republic of">Korea, Democratic People's Republic of</option>
              <option value="Korea, Republic of">Korea, Republic of</option>
              <option value="Kuwait">Kuwait</option>
              <option value="Kyrgyzstan">Kyrgyzstan</option>
              <option value="Lao People's Democratic Republic">Lao People's Democratic Republic</option>
              <option value="Latvia">Latvia</option>
              <option value="Lebanon">Lebanon</option>
              <option value="Lesotho">Lesotho</option>
              <option value="Liberia">Liberia</option>
              <option value="Libyan Arab Jamahiriya">Libyan Arab Jamahiriya</option>
              <option value="Liechtenstein">Liechtenstein</option>
              <option value="Lithuania">Lithuania</option>
              <option value="Luxembourg">Luxembourg</option>
              <option value="Macao">Macao</option>
              <option value="Macedonia, The Former Yugoslav Republic of">Macedonia, The Former Yugoslav Republic of</option>
              <option value="Madagascar">Madagascar</option>
              <option value="Malawi">Malawi</option>
              <option value="Malaysia">Malaysia</option>
              <option value="Maldives">Maldives</option>
              <option value="Mali">Mali</option>
              <option value="Malta">Malta</option>
              <option value="Marshall Islands">Marshall Islands</option>
              <option value="Martinique">Martinique</option>
              <option value="Mauritania">Mauritania</option>
              <option value="Mauritius">Mauritius</option>
              <option value="Mayotte">Mayotte</option>
              <option value="Mexico">Mexico</option>
              <option value="Micronesia, Federated States of">Micronesia, Federated States of</option>
              <option value="Moldova, Republic of">Moldova, Republic of</option>
              <option value="Monaco">Monaco</option>
              <option value="Mongolia">Mongolia</option>
              <option value="Montserrat">Montserrat</option>
              <option value="Morocco">Morocco</option>
              <option value="Mozambique">Mozambique</option>
              <option value="Myanmar">Myanmar</option>
              <option value="Namibia">Namibia</option>
              <option value="Nauru">Nauru</option>
              <option value="Nepal">Nepal</option>
              <option value="Netherlands">Netherlands</option>
              <option value="Netherlands Antilles">Netherlands Antilles</option>
              <option value="New Caledonia">New Caledonia</option>
              <option value="New Zealand">New Zealand</option>
              <option value="Nicaragua">Nicaragua</option>
              <option value="Niger">Niger</option>
              <option value="Nigeria">Nigeria</option>
              <option value="Niue">Niue</option>
              <option value="Norfolk Island">Norfolk Island</option>
              <option value="Northern Mariana Islands">Northern Mariana Islands</option>
              <option value="Norway">Norway</option>
              <option value="Oman">Oman</option>
              <option value="Pakistan">Pakistan</option>
              <option value="Palau">Palau</option>
              <option value="Palestinian Territory, Occupied">Palestinian Territory, Occupied</option>
              <option value="Panama">Panama</option>
              <option value="Papua New Guinea">Papua New Guinea</option>
              <option value="Paraguay">Paraguay</option>
              <option value="Peru">Peru</option>
              <option value="Philippines">Philippines</option>
              <option value="Pitcairn">Pitcairn</option>
              <option value="Poland">Poland</option>
              <option value="Portugal">Portugal</option>
              <option value="Puerto Rico">Puerto Rico</option>
              <option value="Qatar">Qatar</option>
              <option value="Reunion">Reunion</option>
              <option value="Romania">Romania</option>
              <option value="Russian Federation">Russian Federation</option>
              <option value="Rwanda">Rwanda</option>
              <option value="Saint Helena">Saint Helena</option>
              <option value="Saint Kitts and Nevis">Saint Kitts and Nevis</option>
              <option value="Saint Lucia">Saint Lucia</option>
              <option value="Saint Pierre and Miquelon">Saint Pierre and Miquelon</option>
              <option value="Saint Vincent and The Grenadines">Saint Vincent and The Grenadines</option>
              <option value="Samoa">Samoa</option>
              <option value="San Marino">San Marino</option>
              <option value="Sao Tome and Principe">Sao Tome and Principe</option>
              <option value="Saudi Arabia">Saudi Arabia</option>
              <option value="Senegal">Senegal</option>
              <option value="Serbia and Montenegro">Serbia and Montenegro</option>
              <option value="Seychelles">Seychelles</option>
              <option value="Sierra Leone">Sierra Leone</option>
              <option value="Singapore">Singapore</option>
              <option value="Slovakia">Slovakia</option>
              <option value="Slovenia">Slovenia</option>
              <option value="Solomon Islands">Solomon Islands</option>
              <option value="Somalia">Somalia</option>
              <option value="South Africa">South Africa</option>
              <option value="South Georgia and The South Sandwich Islands">South Georgia and The South Sandwich Islands</option>
              <option value="Spain">Spain</option>
              <option value="Sri Lanka">Sri Lanka</option>
              <option value="Sudan">Sudan</option>
              <option value="Suriname">Suriname</option>
              <option value="Svalbard and Jan Mayen">Svalbard and Jan Mayen</option>
              <option value="Swaziland">Swaziland</option>
              <option value="Sweden">Sweden</option>
              <option value="Switzerland">Switzerland</option>
              <option value="Syrian Arab Republic">Syrian Arab Republic</option>
              <option value="Taiwan, Province of China">Taiwan, Province of China</option>
              <option value="Tajikistan">Tajikistan</option>
              <option value="Tanzania, United Republic of">Tanzania, United Republic of</option>
              <option value="Thailand">Thailand</option>
              <option value="Timor-leste">Timor-leste</option>
              <option value="Togo">Togo</option>
              <option value="Tokelau">Tokelau</option>
              <option value="Tonga">Tonga</option>
              <option value="Trinidad and Tobago">Trinidad and Tobago</option>
              <option value="Tunisia">Tunisia</option>
              <option value="Turkey">Turkey</option>
              <option value="Turkmenistan">Turkmenistan</option>
              <option value="Turks and Caicos Islands">Turks and Caicos Islands</option>
              <option value="Tuvalu">Tuvalu</option>
              <option value="Uganda">Uganda</option>
              <option value="Ukraine">Ukraine</option>
              <option value="United Arab Emirates">United Arab Emirates</option>
              <option value="United Kingdom">United Kingdom</option>
              <option value="United States">United States</option>
              <option value="United States Minor Outlying Islands">United States Minor Outlying Islands</option>
              <option value="Uruguay">Uruguay</option>
              <option value="Uzbekistan">Uzbekistan</option>
              <option value="Vanuatu">Vanuatu</option>
              <option value="Venezuela">Venezuela</option>
              <option value="Viet Nam">Viet Nam</option>
              <option value="Virgin Islands, British">Virgin Islands, British</option>
              <option value="Virgin Islands, U.S.">Virgin Islands, U.S.</option>
              <option value="Wallis and Futuna">Wallis and Futuna</option>
              <option value="Western Sahara">Western Sahara</option>
              <option value="Yemen">Yemen</option>
              <option value="Zambia">Zambia</option>
              <option value="Zimbabwe">Zimbabwe</option>
            </select>	
					</div>
	      </div>

	      <div class="control-group">
	        <label class="control-label" for="web">Website</label>
	        <div class="controls">
	        	<input type="text" name="web" id="web" value="" />
					</div>
	      </div>
	      <div class="control-group">
	        <label class="control-label" for="switchboard">Telephone</label>
	        <div class="controls">
	        	<input type="text" name="switchboard" id="switchboard" value="" />
					</div>
	      </div>
	      	       
	    </fieldset>
      <fieldset id="stage5">
        <legend>Payment Information</legend>       
        <div class="alert alert-block">
          <button type="button" class="close" data-dismiss="alert">&times;</button>
          <h4 class="alert-heading">30 days free</h4>
          <p>Both Business and Basic accounts are free for 30 days. If you cancel before the 30 day period is up, you will not be charged</p>
        </div>         
        <div class="control-group">
          <label class="control-label" for="companyName">Name on card <em>*</em></label>
          <div class="controls">
            <input class="helptip" title="The Full name of your company" type="text" name="cardName" id="cardName">
          </div>
        </div>
        <div class="control-group">
          <label class="control-label" for="companyName">Card Number <em>*</em></label>
          <div class="controls">
            <input class="helptip" title="The Full name of your company" type="text" name="cardName" id="cardName">
          </div>
        </div>
        <div class="control-group">
          <label class="control-label" for="companyName">Security Code <em>*</em></label>
          <div class="controls">
            <input class="input-mini helptip" title="The Full name of your company" type="text" name="cardName" id="cardName">
          </div>
        </div>
      </fieldset>
	    <fieldset>
	    	<legend>Confirmation</legend>
				<div class="control-group">
          <label class="control-label" for="accept">Please Confirm<em>*</em></label>
					<div class="controls">
						<label class="checkbox">
							<input class="" title="" type="checkbox" name="termsconfirm" id="termsconfirm">
							I Agree
							<p class="help-block" id="confirmText">I/We agree to the charge(s) specified above (if applicable), payable to Building Vine Limited, and have read and understood the <a target="_blank" href="/html/terms-and-conditions.html">terms and conditions</a> of use.</p>
						</label>
	        </div>
				</div>
			</fieldset>
			<div class="form-actions">
				<input type="submit" class="btn btn-success btn-large" value="Sign me up!" />
	    </div>
	  </form>	
	</div>
	<div class="span4">	  
    <h3>Account Types</h3>
    <!---
    <div class="alert alert-block alert-info">
      <button type="button" class="close" data-dismiss="alert">&times;</button>
      <h4 class="alert-heading">Confused about our account types?</h4>
      <p>Then the table below should explain exactly what functionality each type of account recieves</p>
    </div>
    --->
    <table class="table table-striped table-bordered table-rounded">
      <thead>
        <tr>
          <th>Functionality</th>
          <th>Personal</th>
          <th>Basic</th>
          <th>Business</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>Access Product Data</td>
          <td class="ic"><i class="icon-tick-circle-frame"></i></td>
          <td class="ic"><i class="icon-tick-circle-frame"></i></td>
          <td class="ic"><i class="icon-tick-circle-frame"></i></td>
        </tr>
        <tr>
          <td>API (website integration)</td>
          <td class="ic"><i class="icon-tick-circle-frame"></i></td>
          <td class="ic"><i class="icon-tick-circle-frame"></i></td>
          <td class="ic"><i class="icon-tick-circle-frame"></i></td>
        </tr>
        <tr>
          <td>Get updates emailed automatically</td>
          <td class="ic"><i class="icon-tick-circle-frame"></i></td>
          <td class="ic"><i class="icon-tick-circle-frame"></i></td>
          <td class="ic"><i class="icon-tick-circle-frame"></i></td>
        </tr>
        <tr>
          <td>Network Drive Access</td>
          <td class="ic"><i class="icon-tick-circle-frame"></i></td>
          <td class="ic"><i class="icon-tick-circle-frame"></i></td>
          <td class="ic"><i class="icon-tick-circle-frame"></i></td>
        </tr>
        <tr>
          <td>Add company Information</td>
          <td class="ic"><i class="icon-cross-circle-frame"></i></td>
          <td class="ic"><i class="icon-tick-circle-frame"></i></td>
          <td class="ic"><i class="icon-tick-circle-frame"></i></td>
        </tr>
        <tr>
          <td>Add Press Releases</td>
          <td class="ic"><i class="icon-cross-circle-frame"></i></td>
          <td class="ic"><i class="icon-tick-circle-frame"></i></td>
          <td class="ic"><i class="icon-tick-circle-frame"></i></td>
        </tr>
        <tr>
          <td>Integration into Intranets</td>
          <td class="ic"><i class="icon-cross-circle-frame"></i></td>
          <td class="ic"><i class="icon-tick-circle-frame"></i></td>
          <td class="ic"><i class="icon-tick-circle-frame"></i></td>
        </tr>
        <tr>
          <td>Add Product Information</td>
          <td class="ic"><i class="icon-cross-circle-frame"></i></td>
          <td class="ic"><i class="icon-cross-circle-frame"></i></td>
          <td class="ic"><i class="icon-tick-circle-frame"></i></td>
        </tr>
        <tr>
          <td>Add Secure Pricing Information</td>
          <td class="ic"><i class="icon-cross-circle-frame"></i></td>
          <td class="ic"><i class="icon-cross-circle-frame"></i></td>
          <td class="ic"><i class="icon-tick-circle-frame"></i></td>
        </tr>
        <tr>
          <td>Add secure Promotions</td>
          <td class="ic"><i class="icon-cross-circle-frame"></i></td>
          <td class="ic"><i class="icon-cross-circle-frame"></i></td>
          <td class="ic"><i class="icon-tick-circle-frame"></i></td> 
        </tr>

        
      </tbody>
    </table>
   <div class="row-fluid">

   </div>
   <h2>Join these outstanding visionary companies!</h2>
	 <div class="thumbnails homeintro">
	  <cfquery name="newSites" datasource="bvine">select * from site where active = <cfqueryparam cfsqltype="cf_sql_varchar" value="true"></cfquery>
      <cfoutput query="newSites">
        <cfset uImage = paramImage2("/modules/bv/includes/images/companies/#shortName#/small.jpg","/modules/bv/includes/images/companies/generic.jpg")>
        <a href="/site/#shortName#" class="ttip" title="#title#"><img class="img-polaroid" alt="#xmlFormat(title)#" src="#uImage#" /></a>
      </cfoutput>
	 </div>
	</div>
</div>