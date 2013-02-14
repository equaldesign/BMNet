	$.AjaxCFC({require:'dDumper'});
	// more additional files
	 $.AjaxCFC({require:'json,wddx,dDumper,log4j,blockUI'});
	// optional global settings
	// using these setters also automatically include dependencies
	$.AjaxCFCHelper.setDebug(false);
	$.AjaxCFCHelper.setBlockUI(true);
	$.AjaxCFCHelper.setUseDefaultErrorHandler(true);
	$.AjaxCFCHelper.setSerialization('json'); // json, wddx
$(document).ready(function() {	 
	// sort out hashes
	$('a[href=#]').click(function(){
		return false;}
	);
	$('div #moreInfo').html('<a id="doMoreInfo" href="#"><img src="/stock/moreinfo.jpg" border="0"></a>');
	$("#doMoreInfo").click(function (){
		// what happens when clicked?
		$("#createFeedback").html(' \
		<div class="form-container"> \
		<form id="comment" > \
			<fieldset><legend>Call me please</legend> \
	  <div id="errorMessageBox"></div> \
		<div><label for="full_name">Full Name <em>*</em> </label><input id="full_name" size="30" name="full_name" /> </div> \
		<div><label for="email">Email Address <em>*</em></label> <input id="email" size="30" name="email" /> </div> \
		<div><label for="Phone Number">Phone Number <em>*</em></label> <input id="phone_number" size="30" name="phone_number" /> </div> \
		<div><label for="commenttext">Comment</label> <textarea id="commenttext" rows="5" cols="23" name="commenttext">I\'m interested in more information about ' + $("#currentPagename").html() + '</textarea> </div> \
		</fieldset> \
		<div class="buttonrow"><input type="submit" id="call_me" value="Call me" /></div> \
		</form> \
		</div>'
		);

	$("#comment").validate({
	 
		rules: {
			full_name: "required", 
			email: {
				required: true,
				email: true
			}
		},
		
		messages: { 
							full_name: "Enter your name",
							phone_number: "Enter your Telephone number",
							email: { 
									required: "Please enter a valid email address", 
									minlength: "Please enter a valid email address"
							}
		},
					submitHandler: function() { 
							submitForm(); 
					},
	
			highlight: function(element, errorClass) {
			 $(element).addClass(errorClass);
			 $(element.form).find("label[for=" + element.id + "]")
											.addClass(errorClass);
			},
			unhighlight: function(element, errorClass) {
			 $(element).removeClass(errorClass);
			 $(element.form).find("label[for=" + element.id + "]")
											.removeClass(errorClass);
			},														 
			errorLabelContainer: "#errorMessageBox",
			wrapper: "li",
			 errorElement: "strong",
			errorClass: "invalidInput"
			
		});
		
	});
});


function submitForm() {
		var first_name = document.getElementById("full_name").value;
		var emailAddress = document.getElementById("email").value;
		var phone_number = document.getElementById("phone_number").value;		
		var commenttext = document.getElementById("commenttext").value;
		var pageid = document.getElementById("tmp_pageid").value;
		$.AjaxCFC({
		  url: "/js/jQuery/lawsons.cfc",
		  method: "callmeBack",
		  data:[first_name,emailAddress,phone_number,commenttext,pageid],
			unnamedargs: true,
		  blockUI: false,
			setDebug: true,
			serialization: "json",
			blockMessage: 'Please wait...<br><br><img src="/images/loading.gif" />',
		  useDefaultErrorHandler: true,
		  success: function(data) {
				x = document.getElementById("createFeedback");
				x.innerHTML = "Thankyou.";				
		  }
		});		
};

