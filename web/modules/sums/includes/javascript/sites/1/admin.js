$(document).ready(function(){
	$(".add").change(function(){
		var total = 0;
		var delTotal = parseFloat($(".d").val());
		$(".c").each(function(){
			total +=parseFloat($(this).val());
		})
		$("#totalItemsPrice").html("&pound;" + total.toFixed(2));
		var grandTotal =(total+delTotal)/100*20+(total+delTotal);
		$("#totalPrice").html("&pound;" + grandTotal.toFixed(2));
	})
	$("#orderStatus").change(function(){		
		var orderID = $(this).attr("rel");
		$.ajax({
        url: "/mxtra/admin/orders/changeStatus/id/" + orderID + "/status/" + $(this).val(),
        dataType: "html",
        type: "POST",
        success: function(data){
          alert("order status changed");
        }
      });
	})
})
