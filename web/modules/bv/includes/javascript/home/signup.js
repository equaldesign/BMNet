$(document).ready(function(){
	$("#access_personal").click(function(){		
		$("#stage3").hide();
    $("#stage4").hide();
    $("#stage5").hide();
		$("#confirmText").html('I/We have read and understood the <a target="_blank" href="/html/terms-and-conditions.html">terms and conditions</a> of use.');
		$('input[name$="group"]').each(function(){
      $(this).hide();
    })
	})
	$("#access_merchant").click(function() {
		$("#stage3").show();
    $("#stage4").show();
    $("#stage5").show();
		$("#confirmText").html('I/We agree to the charge of &pound;490 per annum (+ VAT), payable to Building Vine Limited, and have read and understood the <a target="_blank" href="/html/terms-and-conditions.html">terms and conditions</a> of use.');
		$('input[name$="group"]').each(function(){
      $(this).show();
    })
		$("#m_subs, #m_cost").hide();
	});
	$("#access_supplier").click(function() {
    $("#stage3").show();
    $("#stage4").show();
    $("#stage5").show();
		$("#confirmText").html('I/We agree to the charge of &pound;290 per annum (+ VAT), payable to Building Vine Limited, and have read and understood the <a target="_blank" href="/html/terms-and-conditions.html">terms and conditions</a> of use.');
		$('input[name$="group"]').each(function(){
      $(this).show(); 
    }) 
    $("#m_subs, #m_cost").hide();
  });
  $(".access_type").click(function(){
    $(".access_type").closest("label").removeClass("selected");
    $(".access_type").closest("label").find(".label").hide();
    $(this).closest("label").addClass("selected");
    $(this).closest("label").find(".label").show();
    $.scrollTo(800,"slow",{easing: "easeInCubic" });
  })
	$("#access_group").click(function(){
		$("#stage3").show();
    $("#stage4").hide();
		$('input[name$="group"]').each(function(){
      $(this).hide();
    })
		$("#m_subs, #m_cost").show();
	});
  $(".validateeGroup").click(function(){    
    if ($(this).is(":checked")) {
      $(this).parent().next().show();
    } else {
      $(this).parent().next().hide();
    }    
  })
  $(".validateNMBS").click(function(){
    $(".nmbs").hide();
    if ($(this).is(":checked")) {
      $(this).next().show();
    }    
  })
  $("#checkNMBS").click(function(){
    var NMBSCode = $(this).prev().val();
    var hb = $(this).closest(".nmbs").find(".help-block");
    $(hb).html('checking...');
    $.ajax({
      url: "/signup/nmbsCheck",
      data: {
        NMBSCode: NMBSCode
      },
      success: function(result) {
        if (result.ROWCOUNT > 0) {          
          $(hb).html('<span class="label label-success">validated.</span>');
          $("#companyName").val(result.DATA.Supplier_Name[0]);
          $("#postcode").val(result.DATA.Postcode[0]);
          $("#switchboard").val(result.DATA.Telephone[0]);
          $("#web").val(result.DATA.Website[0]);
          $("#companyAddress").val(result.DATA.address1[0] + ',' + result.DATA.address2[0]);
          $("#country").val("United Kingdom");          
        } else {
          $(u).addClass("error");
          $(hb).html('<span class="label label-important">error validating.</span>');
        }
      }
    })
  })
  $(".checkCredentials").click(function(){
    var ds = $(this).attr("data-for");
    var u = $(this).parent().find(".username");
    var p = $(this).parent().find(".password");
    var hb = $(this).closest(".loginInfo").find(".help-block");
    $(hb).html('checking...');
    $.ajax({
      url: "/signup/bgcheck",
      data: {
        username: u.val(),
        password: p.val(),
        datasource: ds
      },
      success: function(result) {
        if (result.ROWCOUNT > 0) {
          $(u).addClass("success");
          $(hb).html('<span class="label label-success">validated.</span>');
          $("#companyName").val(result.DATA.name[0]);
          $("#postcode").val(result.DATA.postcode[0]);
          $("#switchboard").val(result.DATA.switchboard[0]);
          $("#web").val(result.DATA.web[0]);
          $("#companyAddress").val(result.DATA.address1[0] + ',' + result.DATA.address2[0] + ',' + result.DATA.town[0]);
          $("#country").val("United Kingdom");          
          $("#email").val(u.val());
          $("#password1").val(p.val());
          $("#password2").val(p.val());
          $("#first_name").val(result.DATA.first_name[0]);
          $("#surname").val(result.DATA.surname[0]);
          if (result.DATA.type_id == 2) {
            $("#companyType").val("Supplier");
          } else if (result.DATA.type_id == 1) {
            $("#companyType").val("Merchant");
          }

        } else {
          $(u).addClass("error");
          $(hb).html('<span class="label label-important">error validating.</span>');
        }
      }
    })
  })
	$("#subs").change(function(){
		var members = $(this).val();
		var cost = 0;
		
		if (isNumber(members)) {		
			$("#cost").val(0);			
			if (members > 40) {
				// how many members at 190?
				over40 = members - 40;
				cost = over40 * 190;
				cost = (10 * 990) + (10 * 490) + cost;
			} else if (members > 20) {
				over20 = members - 20;
				cost = over20 * 490;
				cost = (10 * 990) + cost;
			} else {
				cost = members * 990;
			}			
			$("#cost").val(cost);
			$("#confirmText").html('I/We agree to the charge of &pound;' + cost + ' per annum, payable to Building Vine Limited, and have read and understood the <a target="_blank" href="/pages/terms">terms and conditions</a> of use.');  			
		}
	})
	$("#signUpForm").validate({
    rules: {
      surname: "required",
      first_name: "required",
      email: {
        required: true,
        email: true
      },
      password1: { 
        required: true
      },
      password2: {
        required: true,
        equalTo: "#password1"       
      },
      companyName: {
        required: "#access_merchant:checked,#access_merchant:checked,access_supplier:checked"
      },

      postcode: {
        required: "#access_merchant:checked,access_supplier:checked"
      },
      switchboard: {
        required: "#access_merchant:checked,access_supplier:checked"
      },
      companyType: {
        required: "#access_merchant:checked,access_supplier:checked"
      },
			web: {
        required: "#access_merchant:checked,access_supplier:checked"
      },
      country: {
        required: "#access_merchant:checked,access_supplier:checked"
      },
			subs: {
				required: "#access_group:checked"
			},
			cost: {
        required: "#access_group:checked"
      },
			termsconfirm: {
        required: true
      },
      captcha: {
        required: true,
        remote: "/signup/checkCaptcha?captcha_check=" + $("#captcha_check").val()
      }
    },
    submitHandler: function(form) {
        form.submit();
      },
   messages: {
      captcha: "The correct code is required. You entered an incorrect code!",
      termsconfirm: "You must agree to the terms within the confirmation section."
    }
  })
})
function isNumber(n) {
  return !isNaN(parseFloat(n)) && isFinite(n);
}