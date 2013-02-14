$(function() {
var oTable;
var giRedraw = false;

  /* 
   * Quick action listeners
   */   
	
	$(".getBV").livequery("click",function(e){
		var ean = $(this).attr("data-ean");
		var product_code = $(this).attr("data-product_code");
		var mpc = $(this).attr("data-mpc");
		var bvNode = $(this).attr("data-bvNode");
		if (bvNode == "") {
			if (ean == "") {
	  	  theURL = "/bv/search/products?product_code" + product_code + "&query=" + mpc
	    } else {
				theURL = "/bv/search/products?product_code" + product_code + "&query=" + ean
			}
		} else {
			theURL = "/bv/products/productDetail?nodeRef=" + bvNode
		}
		$("#dialog").dialog({
      title: $(this).attr("name"),
      buttons: {}
    })
		$.blockUI();
    $.ajax({
      url: theURL,
      datatype: "html",
      success: function(data) {
				$.unblockUI();
        $("#dialog").html(data);
        $("#dialog").dialog("open");        
      }
    })
    e.preventDefault();
    return false;
	})
	$(".approveBV").livequery("click",function(){
		var thisNode = this;
		var product_code = $(this).attr("data-product_code");
    var approved = $(this).attr("data-bvapproved");
		if (approved == "true") {
			setTo = false
		} else {
			setTo = true
		}
		$.blockUI();
		$.ajax({
      url: "/eunify/products/setAttribute?product_code=" + product_code + "&attribute=BVApproved&value=" + setTo,
      datatype: "html",
      success: function(data) {
        $.unblockUI();
				$(thiuNode).attr("data-bvapproved",setTo);
				if (setTo) {
				  $(thisNode).find("i").attr("class","icon-tick-circle-frame");					
				} else {
					$(thisNode).find("i").attr("class","icon-cross-circle-frame");
				}				                
      }
    })
  })
	$(".tradeEnable").livequery("click",function(){
    var thisNode = this;
    var product_code = $(this).attr("data-product_code");
    var tradeEnabled = $(this).attr("data-trade-enabled");
    if (tradeEnabled == "true") {
      setTo = false
    } else {
      setTo = true
    }
    $.blockUI();
    $.ajax({
      url: "/eunify/products/setAttribute?product_code=" + product_code + "&attribute=webEnabled&value=" + setTo,
      datatype: "html",
      success: function(data) {
        $.unblockUI();
        $(thisNode).attr("data-trade-enabled",setTo);
        if (setTo) {
          $(thisNode).find("i").attr("class","icon-tick-circle-frame");         
        } else {
          $(thisNode).find("i").attr("class","icon-cross-circle-frame");
        }                       
      }
    })
  })
	$(".webEnable").livequery("click",function(){
    var product_code = $(this).attr("data-product_code");
		var thisNode = this;
    var product_code = $(this).attr("data-product_code");
    var webEnabled = $(this).attr("data-public-web-enabled");
    if (webEnabled == "true") {
      setTo = false
    } else {
      setTo = true
    }
    $.blockUI();
    $.ajax({
      url: "/eunify/products/setAttribute?product_code=" + product_code + "&attribute=publicwebEnabled&value=" + setTo,
      datatype: "html",
      success: function(data) {
        $.unblockUI();
        $(thisNode).attr("data-trade-enabled",setTo);
        if (setTo) {
          $(thisNode).find("i").attr("class","icon-tick-circle-frame");         
        } else {
          $(thisNode).find("i").attr("class","icon-cross-circle-frame");
        }                       
      }
    })
  })
	
   oTable =  $('#productList').dataTable( {
        "bJQueryUI": true,
        "sPaginationType": "full_numbers",
        "sDom": '<"reload"r><"F"fl>t<"F"p>',
        "bAutoWidth":false,
				"bProcessing": true,
        "bServerSide": true,
        "sAjaxSource": "/eunify/products/list?categoryID=" + $("#categoryID").val(),				
				"iDisplayLength": 50,        
        "bStateSave": true,
				"aoColumns" : [
            {"bVisible" : false, "aTargets" : [0]},            
            {"bVisible" : true, "bSortable" : false, "aTargets" : [1]},
            {"sTitle" : "Product Code"},
            {"sTitle" : "Description"},
            {"sTitle" : "Retail Price"},
            {"sTitle" : "Trade Price"},
            {"sTitle" : "BV"},
						{"sTitle" : "BV Approved"},
            {"sTitle" : "Web"},
            {"sTitle" : "Public"}
				]				
    } );
    $('select').select2();
})