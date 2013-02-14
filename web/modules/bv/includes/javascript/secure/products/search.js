$(function() {
	$('#productSearch').ajaxForm({ 
      beforeSubmit: function() {
				$("#BVContent").block();
			},
			success: function(data) {
				$("#BVContent").html(data);
				$("#BVContent").unblock();
			}
  }); 
})
