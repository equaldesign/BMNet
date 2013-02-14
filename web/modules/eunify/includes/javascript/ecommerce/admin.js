$(function(){
	$("#changestatus").click(function(){
		var status = $("#status").val();
		var orderID = $("#orderID").val();
		$.blockUI();
		$.ajax({
      url: "/eunify/ecommerce/changeStatus",
      data: {
        id: orderID,
				status: status
      },
      success: function(){
        $.unblockUI();
      }
    })
	})
})
