$(document).ready(function(){
	var pageTree;
  pageTree = $("#pageTree").jstree({
    "json_data": {
      "ajax": {
        "url": "/sums/page/tree",
        contentType: "application/json",
        dataType: "json",
        "data": function(n){
          return {
		  	     siteID: $("#siteID").val(),
						 nodeRef: n.attr ? n.attr("id") : ""		  	     
		      }
        }
      }
    },
    "cookies": {
      "save_opened": "jstree_open",
      "auto_save": "true"
    },
    "plugins": ["json_data", "cookies"] 
  });
	$(".delete_page").click(function(){
    var c = window.confirm("Are you sure you want to delete this page?");
    if (c) {
      var url = $(this).attr("href");       
      $.ajax({
        url: url,
        datatype: "html",
        type: "delete",
        success: function(data) {
          document.location.href="/";
        }
      })
    } else {
      return false;
    }
	});
})
