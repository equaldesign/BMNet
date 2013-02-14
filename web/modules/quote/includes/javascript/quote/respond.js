var reJustTheNumber = /\s*(\-?\d+(\.\d+)?)\s*/;
var totalAmount = 0;

$(document).ready(function(){
	var nameIDs = $(".totalamounts").length-1;
	$.validator.addClassRules("totalamounts",{
  	required: true
  });
	function doValid(){
  	$("#proposalForm").validate({
  		submitHandler: function(f){
  			f.submit();
  		},
  		invalidHandler: function(form, validator){
  			var errors = validator.numberOfInvalids();
  			if (errors) {
  				$('#submitQuote').modal('hide')
  			}
  		}
  	})
  }
	$(".ddate").datepicker({
    dateFormat: 'dd/mm/yy'
  });
	$(".removeLine").live("click",function(){
		$(this).closest("tr").remove();
		nameIDs--;
		calcTotals();
	})
	$(".totalamounts").change(function(){
		updateTotal(this);
	});
	$(".addLine").click(function(){
		
		var thisTR = $(this).closest("tr");
		var q = $(thisTR).find(".quant");
		var u = $(thisTR).find(".unitType");
		var p = $(thisTR).find(".prodname");
		var t = $(thisTR).find(".amount");
		nameIDs++;
		$("#quoteTable tbody").append(
		'<tr>' + 
		  '<td>' + 
        '<input class="quantity" type="hidden" name="product[' + nameIDs + '].quantity" value="' + q.val() + '" />' + 
        q.val() + 
			'</td>' +
      '<td>' +
        '<input class="unit" type="hidden" name="product[' + nameIDs + '].unit" value="' + u.val() + '" />' + 
        u.val() + 
			'</td>' + 
      '<td>' + 
        '<input class="productName" type="hidden" name="product[' + nameIDs + '].productName" value="' + p.val() + '" />' + 
        p.val() + 
			'</td>' + 
      '<td>' + 
        '<div class="input-prepend input-append">' + 
          '<span class="add-on">&pound;</span>' + 
            '<input type="text" class="input-mini totalamounts" name="product[' + nameIDs + '].amount" value="' + t.val() + '" />' + 
          '<span class="add-on">Ex VAT</span>' +  
        '</div>' + 
      '</td>' + 
      '<td>' + 
        '<a href="##" title="remove this item" class="btn btn-danger removeLine"><i class="icon-delete"></i> Remove</a></td>' +
		'</tr>');
		$(q).val(1);		
		$(p).val("");
		$(t).val("");		
		calcTotals();
	});
	function calcTotals() {
		totalAmount = 0;
		$(".totalamounts").each(function(){
      if ($(this).val() != '') {
        if (!isNaN($(this).val())) {
          totalAmount += parseFloat($(this).val());
					doValid();
        }        
      }
    })
    $("#totalCost").html("&pound;" + totalAmount.toFixed(2));
	}
	function updateTotal(el) {
		
		if ($(el).val().search(reJustTheNumber) > -1){
	    $(el).val(RegExp.$1);
			calcTotals();
	  } else {	    
	    $(el).val("");
	  }
		
	}
	$("#paymentChoose").change(function(){
		if ($(this).val() == "paypal") {
			$("#paypalDetails").show();
		} else {
			$("#paypalDetails").hide();
		}
	})
	doValid();
});
