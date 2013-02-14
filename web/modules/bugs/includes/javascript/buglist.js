var oTable;
var hideClosed = true;

$(document).ready(function(){
	$(".showmessage").live("mouseenter",function(){
        $(this).popover({
          content: $(this).next().html(),
          trigger: "manual"
        }).popover("show");
    });
    $(".showmessage").live("mouseleave",function(){
        $(this).popover("toggle");
    });
	$(".priority").live("click",function(){
		var $ob = $(this);
		var currentPriority = $($ob).attr("rel");
		var id = $($ob).attr("rev");
		$.ajax({
      url: $.buildLink("bugs.priority","id=" + id + "&priority=" + currentPriority),
      dataType: "json",
      success: function(data) {
				var p = parseInt(data.priority);
        $($ob).removeClass("traffic_" + currentPriority);
				$($ob).addClass("traffic_" + p);
				$($ob).attr("rel",p);
      }
    })
		return false;
	});
	$(".closeTicket").live("click",function(){
    var $ob = $(this);
    var currentstatus = $($ob).attr("rel");
    var id = $($ob).attr("rev");
    $.ajax({
      url: $.buildLink("bugs.status","id=" + id + "&status=pending"),
      dataType: "json",
      success: function(data) {        
        $($ob).removeClass(currentstatus);
        $($ob).addClass(data.status);
        $($ob).attr("rel",data.status);
        if (data.status == "closed") {
          $($ob).parentsUntil("tr").parent().remove();
        }
      }
    })
    return false;
  });
	$(".status").live("click",function(){
    var $ob = $(this);
    var currentstatus = $($ob).attr("rel");
    var id = $($ob).attr("rev");
    $.ajax({
      url:  $.buildLink("bugs.status","id=" + id + "&status=" + currentstatus),
      dataType: "json",
      success: function(data) {        
        $($ob).removeClass(currentstatus);
        $($ob).addClass(data.status);
        $($ob).attr("rel",data.status);
				if (data.status == "closed") {
					$($ob).parentsUntil("tr").parent().remove();
				}
      }
    })
    return false;
  });
	$("#listToolBar .btn").live("click",function(e){
		hideClosed = $(this).hasClass("active");
		$("#" + $(this).attr("data-ref")).val(hideClosed);
		oTable.fnReloadAjax($.buildLink("bugs.list","hideClosed=" + $("#hideClosed").val() + "&showMine=" + $("#showMine").val()));
        return false;
	})
	$(".delete").live("click",function(){
    var $ob = $(this);
    var id = $($ob).attr("rev");
		var conf = window.confirm("Are you sure you wish to delete this bug/ticket?");
		if (conf) {
			$.ajax({
				url: $.buildLink("bugs.delete","id=" + id),
				dataType: "json",
				success: function(data){
					$($ob).parentsUntil("tr").parent().remove();
				}
			})
	  }
    return false;
  });
	
  oTable =  $('#bugsList').dataTable( {
	      "sDom": "<'widget-header'<'pull-left padd5'l><'pull-right padd5'f>r><'widget-content't><'widget-footer'<'pull-left padd5'i><'pull-right padd5'p>>",
        "bProcessing": true,
        "bServerSide": true,       
        "sPaginationType": "bootstrap",
        "oLanguage": {
          "sLengthMenu": "_MENU_ records per page"
        }, 
        "sAjaxSource":$.buildLink("bugs.list","hideClosed=" + $("#hideClosed").val() + "&showMine=" + $("#showMine").val()),
        "iDeferLoading": 57,        
        "bStateSave": true,
        "iDisplayLength": 25
        
     });
  
	
})

