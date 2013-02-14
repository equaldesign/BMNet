$(document).ready(function(){
	$(".deleteComment").click(function(){
		var commentURL = $(this).attr("href");
		var commentBox = $(this).parentsUntil(".commentBox").parent();
		$("#whiteBox").block();
		$.ajax({
			url: commentURL,
			type: "DELETE",
			dataType: "json",
			success: function() {
	  	  $(commentBox).remove();
				$("#whiteBox").unblock();
	    }
		});		
		return false;
	})
	$(".editComment").click(function(){
    var commentURL = $(this).attr("href");    
    $("#whiteBox").block();
    $.ajax({
      url: commentURL,
      type: "GET",
      dataType: "json",
      success: function(data) {
				$("#doComment #title").val(data.item.title);
				$("#doComment #content").val(data.item.content);
				$("#doComment").attr("action","/alfresco/service/" + data.item.url + "?alf_ticket=" + $("#alf_ticket").val())
				$("#doComment #doComment").val("edit comment");
				$("#doComment").attr("method","PUT")
        $("#whiteBox").unblock();
      }
    });   
    return false;
  })
	$("#doComment").submit(function(){
		var add = $(this).attr("action");
		$("#whiteBox").block();
		$.ajax({
			url: add,
			contentType: "application/json",
			data: JSON.stringify($(this).serializeObject()),
			dataType: "json",
			type: $(this).attr("method"),
      success: function (data) {
				$("#whiteBox").unblock();
				window.location.reload();
			}			
		});
		return false;
	});
});
$.fn.serializeObject = function()
{
    var o = {};
    var a = this.serializeArray();
    $.each(a, function() {
        if (o[this.name] !== undefined) {
            if (!o[this.name].push) {
                o[this.name] = [o[this.name]];
            }
            o[this.name].push(this.value || '');
        } else {
            o[this.name] = this.value || '';
        }
    });
    return o;
};
