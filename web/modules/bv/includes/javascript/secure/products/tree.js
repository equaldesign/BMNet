$(document).ready(function(){
$("#productTree").jstree({
    "json_data" : {
      "ajax" : {
        "url" :  "/products/tree",
        "data" : function (n) { 
          return { nodeRef : n.attr ? n.attr("id") : 0  }; 
        }
      },
			"data" : [
            {
                    "data" : "Products"
                    ,"state" : "closed"
                    ,"attr" : {"id" : "0"}
            }
      ]
		},
		"contextmenu" : {		
			items: {	    				
			    "ccp" : false,
					"remove": false,	
			    "create" : {
			      // The item label
			      "label" : "Create Category",
			      // The function to execute upon a click
			      "action": function (obj) { 
						            var parentID = $(obj).attr("id")
												var n = this;
												$.ajax({
				                  url: "/alfresco/service/bv/product/category?alf_ticket=" + $("#alf_ticket").val(),
				                  dataType: "json",
				                  type: "POST",
				                  data: {              
													  "siteID": $("#siteID").val(),     
				                    "categoryName": "New Category",
														"categoryParent": parentID 
				                  },
				                  success: function(data) {
				                    n.create(obj,"inside",{
		                          "attr": {
		                            "id": data.nodeRef
		                          },
		                          "state": "open",
		                          "data": data.categoryName                          
                           });                                          
				                 }
				                })
						            												 
							        }			      
			     },
					 "rename": {
					 	// The item label
              "label" : "Rename Category",
              // The function to execute upon a click
              "action": function (obj) { 
							            this.rename(obj);													
											  }              
					 },
					 "deletecat": {		   	    
						"label": "Delete Category",
						
						"action": function(obj){
							var che = window.confirm("This will remove this category and any products within it. Are you sure?");
							if (che) {								
							 var n = this;
								var categoryID = $(obj).attr("id"); 								
								$.ajax({
									url: "/alfresco/service/bv/product/category?alf_ticket=" + $("#alf_ticket").val() + "&categoryNodeRef=" + categoryID,
									dataType: "json", 
									type: "DELETE",									
									success: function(data) {
										n.delete_node(obj);				            				               
				         }
								})
							}
						} 
					}			
			}
		
		},
		"dnd" : {      
      "drag_finish" : function (data) {
				var product = data.o; 
				var category = data.r;
				if ($(product).hasClass("product")) {					
					productID = $(product).attr("rel"); 
				} else {
					productID = $(product).closest(".product").attr("rel");
					if (productID == undefined) {
						// maybe we're too far "outside"
						productID = $(product).find(".product").attr("rel");
						if (productID.length == undefined) {
							// maybe it's the one we grabbed?
						  productID = $(product).attr("rel");					
						}
					}					
				}
				categoryID = $(category).attr("id");			  	
			  $.ajax({
	        url: "/alfresco/service/bv/product/move?alf_ticket=" + $("#alf_ticket").val(),
	        dataType: "json",
	        type: "POST",        
	        data: {         
	          productNodeRef: productID,
	          categoryNodeRef: categoryID          
	        },
	       success: function(data) {
				 	  alert("move ok!");
	          var uriArray = $.address.value().split("!");
	          if (uriArray.length > 1) {
	            var windowName = uriArray[0].replace("/","");
	            var uri = uriArray[1];
	          } else {
	            var windowName = "whiteBox";
	            var uri = uriArray[0];
	          }
	          $("#" + windowName).block();
	            $.get(uri, function(data){
	              $("#" + windowName).html(data);
	              $("#" + windowName).unblock();
	          })   
	       }
        }) 

      }
    },    		           
    "cookies" : {
      "save_opened" : "jstree_open",
      "auto_save" : "true"
    },
    "plugins" : [
		   "json_data",
			 "cookies",
			 "dnd",
			 "crrm",
			 "contextmenu" 
		]
  });
	var js = "Speng";
	function doNode(node) {
		console.log(node);
	}	
	$("#productTree").bind("rename_node.jstree",function(e , result) {
		var newName = result.args[1];
    var categoryID = $(result.args[0]).attr("id");        
    $.ajax({
      url: "/alfresco/service/bv/product/category?alf_ticket=" + $("#alf_ticket").val(),
      dataType: "json",
      type: "POST",        
      data: {          
        categoryNodeRef: categoryID,
        categoryName: newName         
      }
    }) 
  });
});
