$(document).ready(function(){
	var cache = {},
      lastXhr;
	$(".ddate").datepicker({
    dateFormat: 'dd/mm/yy'
  });
	//Matches UK landline + mobile, accepting only 01-3 for landline or 07 for mobile to exclude many premium numbers
	jQuery.validator.addMethod('phonesUK', function(phone_number, element) {
	  phone_number = phone_number.replace(/\s+|-/g,'');
	  return this.optional(element) || phone_number.length > 9 &&
	    phone_number.match(/^(0[1-3]{1}[0-9]{8,9})$/) || phone_number.match(/^(07[5-9]{1}[0-9]{7,8})$/);
	}, 'Please specify a valid uk phone number');
	//Matches UK postcode. based on http://snipplr.com/view/3152/postcode-validation/
	jQuery.validator.addMethod('postcodeUK', function(postcode, element) {
	  postcode = (postcode.toUpperCase()).replace(/\s+/g,'');
	  return this.optional(element) || postcode.match(/^([^QZ]{1}[^IJZ]{0,1}[0-9]{1,2})([0-9]{1}[^CIKMOV]{2})$/) || postcode.match(/^([^QV]{1}[0-9]{1}[ABCDEFGHJKSTUW]{1})([0-9]{1}[^CIKMOV]{2})$/) || postcode.match(/^([^QV]{1}[^IJZ][0-9]{1}[ABEHMNPRVWXY])([0-9]{1}[^CIKMOV]{2})$/) || postcode.match(/^(GIR)(0AA)$/) || postcode.match(/^(BFPO)([0-9]{1,4})$/) || postcode.match(/^(BFPO)(C\/O[0-9]{1,3})$/);
	}, 'Please specify a valid postcode');
	jQuery.validator.addMethod("dateITA", function(value, element) {
	  var check = false;
	  var re = /^\d{1,2}\/\d{1,2}\/\d{4}$/;
	  if( re.test(value)){
	    var adata = value.split('/');
	    var gg = parseInt(adata[0],10);
	    var mm = parseInt(adata[1],10);
	    var aaaa = parseInt(adata[2],10);
	    var xdata = new Date(aaaa,mm-1,gg);
	    if ( ( xdata.getFullYear() == aaaa ) && ( xdata.getMonth () == mm - 1 ) && ( xdata.getDate() == gg ) )
	      check = true;
	    else
	      check = false;
	  } else
	    check = false;
	  return this.optional(element) || check;
	}, "Please enter a correct date");
		$("#doQuote").validate({
		rules: {
      // simple rule, converted to {required:true}
      reference: "required",
      deadline: {
			 	required: true, 
				dateITA: true
		  },
			contact: "required",
		  phone: {
		 	  required: true,
			 phonesUK: true
		  },
      // compound rule
      email: {
        required: true,
        email: true
      },
		  deliveryAddress: "required",
			postcode: {
		 	  required: true,
        postcodeUK: true
		  },
			password: {
				required: true
			},
			password2: {
				required: true,
				equalTo: "#password"
			}
    },
    messages: {
      reference: "You need to specify a reference",
			contact: "Please enter your name",
      email: {
        required: "We need your email address to contact you",
        email: "Your email address must be in the format of name@domain.com"
      },
      phone: {
        required: "We need your phone number so we can contact you in case of an query with your order",
        phonesUK: "Please enter a valid UK phone number"
      },
			deliveryAddress: {
				required: "We need your address in case in case your postcode cannot be found automatically"
			},
      postcode: {
        required: "We need your postcode to target your order to local merchants only",
        postcodeUK: "Your postcode does not appear to be valid!"
      },
      deadline: {
        required: "Please enter a deadline date",
        dateITA: "Your deadline date doesn't appear to be valid!"
      },
			password: {
				required: "You need to enter a password so you can login to view your quotations"
			},
			password2: {
				required: "Please confirm your password",
				equalTo: "Your passwords did not match"
			}
    },
		submitHandler: function(f) {
			f.submit();
		},
		invalidHandler: function(f,v) {
			var errors = v.numberOfInvalids();
      if (errors) {
        if (!$("#stage2").is(":visible")) {
          $("#stage1").fadeOut("fast",function(){
						$("#stage2").fadeIn("fast");
						$("#cont").show();        
						$(".finishconfirm").removeClass("disabled");
						$(".finishconfirm").removeAttr("disabled");
          });
        }			 
      }
		}
	});
	
	$(".addProducts, .finishconfirm.btn-info").click(function(){	
		$("#stage1").fadeOut("fast",function(){
		  $("#stage2").fadeIn("fast");
			$("#cont").show();				
			$(".finishconfirm").remove();
      $('<input type="submit" value="Finish &amp; Confirm &raquo;" class="btn btn-large btn-success finishconfirm pull-right" />').appendTo($("#submitSpan"));
		})
	})
	$("#backToRequirements").click(function(){
		$("#stage2").fadeOut("fast",function(){
      $("#stage1").fadeIn("fast");        
    })
	})
	$(".del").change(function(){
		console.log("changed");
		if ($(this).val() == "true") {
		  // they need it delivered
			$("#collectionRadius").hide();
			$("#field_deliverPostCode").text("Delivery Postcode");
			$("#field_deliveryAddress").text("Delivery Address");
			$("#deliveryDate").show();
		} else {
			$("#collectionRadius").show();
      $("#field_deliverPostCode").text("Your Postcode");
      $("#field_deliveryAddress").text("Your Address");
      $("#deliveryDate").hide();
		}
	})
	$("#doSearch").click(function(){
		$("#searchQuery").addClass("spinner");      
		$.ajax({
		  type: 'POST',
		  url: "/quote/search",
		  data: {
				term: $("#searchQuery").val()
			},
		  success: function(data) {
				$("#searchResults").html(data);
				$("#searchQuery").removeClass("spinner");
        $("#actions").show();
			}
		});
    		
	})
	
	$("#searchQuery").bindWithDelay("keyup",function(){
		if ($(this).val().length > 4) {			
			$(this).addClass("spinner");			
			$.ajax({
	      type: 'POST',
	      url: "/quote/search",
	      data: {
	        term: $("#searchQuery").val()
	      },
	      success: function(data) {
	        $("#searchResults").html(data);
	        $("#searchQuery").removeClass("spinner");
	        $("#actions").show();
	      }
	    });
		} 
	},1000);
	$(".addProduct").live("click",function(){
		var pTD = $(this).closest("tr");
		var product_code = $(pTD).find(".pcode").val();
		var unit_type = $(pTD).find(".utype").val();
		var quantity = $(pTD).find(".quant").val();
		var product_name = $(pTD).find(".pname").val();
		$('<tr><td><input type="hidden" name="quantity" value="' + quantity + '" />' + quantity + '</td><td><input type="hidden" name="unit" value="' + unit_type + '" />' + unit_type + '</td><td><input type="hidden" name="product_name" value="void"/><input type="hidden" name="product_code" value="' + product_code + '"/>' + product_name + '</td><td><a href="#" class="removeItem"><i class="icon-delete"></i></a></td></tr>').appendTo($("#shoppingList tbody"));
		$(".addProducts").removeClass("disabled");
		$(".addProducts").removeAttr("disabled");
		$(".finishconfirm").removeClass("disabled");
    $(".finishconfirm").removeAttr("disabled");
	})
	/*$("#searchQuery").autocomplete({
		source: function( request, response ) {
        var term = request.term;
        if ( term in cache ) {
          response( cache[ term ] );
          return;
        }

        lastXhr = $.getJSON( "/mxtra/shop/search/jsonsearch", request, function( data, status, xhr ) {
          cache[ term ] = data;
          if ( xhr === lastXhr ) {
            response( data );
          }
        });
      },    
    minLength: 2,
    select: function(event, ui){
      $('<tr><td><input type="hidden" name="quantity" value="' + $("#quantity").val() + '" />' + $("#quantity").val() + '</td><td><input type="hidden" name="unit" value="' + $("#unit").val() + '" />' + $("#unit").val() + '</td><td><input type="hidden" name="product_name" value="void"/><input type="hidden" name="product_code" value="' + ui.item.id + '"/>' + ui.item.label + '</td><td><a href="#" class="removeItem"><i class="icon-delete"></i></a></td></tr>').appendTo($("#shoppingList tbody"));
			$("#quantity").val("1");
			$("#searchQuery").val("");
			$("#quantity").focus();
			return false;
    }       
  });
  */
	$("#manualProductAdd").live("click",function(e) {
	   $('<tr><td><input type="hidden" name="quantity" value="' + $("#manualQuantity").val() + '" />' + $("#manualQuantity").val() + '</td><td><input type="hidden" name="unit" value="' + $("#manualUnits").val() + '" />' + $("#manualUnits").val() + '</td><td><input type="hidden" name="product_code" value="void"/><input type="hidden" name="product_name" value="' + $("#manualProductName").val() + '"/>' + $("#manualProductName").val() + '</td><td><a href="#" class="removeItem"><i class="icon-delete"></i></a></td></tr>').appendTo($("#shoppingList tbody"));
     $("#quanmanualQuantitytity").val("1");
     $("#manualProductName").val("");
		 $("#manualQuantity").focus();
		 $(".addProducts").removeClass("disabled");
     $(".addProducts").removeAttr("disabled");
		 $(".finishconfirm").removeClass("disabled");
     $(".finishconfirm").removeAttr("disabled");
		 return false;		
	});
	$(".removeItem").live("click",function(e){
		$(this).closest("tr").remove();
		e.preventDefault();
		return false;
	});
	/*window.onscroll = function(){
  var scrollTop = $(window).scrollTop();
	  if(scrollTop>200){
	        $("#list").css("position","fixed");
	        $("#list").css("top",10);
					//$("#list").css("right",0);
	    }else{
	        $("#list").css("position","inherit");
	        $("#list").css("top",0);
	    }
	}
	*/
})
