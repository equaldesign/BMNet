$(document).ready(function(){

    
  
$("#productTree").jstree({
    "json_data" : {
      "ajax" : {
        "url" :  "/alfresco/service/bv/product/tree?alf_ticket=" + $("#alf_ticket").val() + "&siteID=" + $("#productTree").attr("rel"),
        "data" : function (n) { 
          return { nodeRef : n.attr ? n.attr("id") : ""  }; 
        }
      }
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
              var che = window.confirm("are you sure?");
              if (che) {                
               var n = this;
                var categoryID = $(obj).attr("id");                 
                $.ajax({
                  url: "/alfresco/service/bv/product/category?categoryNodeRef=" + categoryID + "&alf_ticket=" + $("#alf_ticket").val(),
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
          console.log("hasclass");
          productID = $(product).attr("rel"); 
        } else {
          productID = $(product).closest(".product").attr("rel");
          console.log($(product));
          console.log("noclass");
        }
        categoryID = $(category).attr("id");
        console.log("product: " + productID);
        console.log("category: " + categoryID);       
        $.ajax({
          url: "/alfresco/service/bv/product/move?alf_ticket=" + $("#alf_ticket").val(),
          dataType: "json",
          type: "POST",        
          data: {         
            productNodeRef: productID,
            categoryNodeRef: categoryID          
          },
         success: function(data) {
            alert("ok!");
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
      "save_opened" : "JSTREE_OPEN",
			"save_selected": "JSTREE_SELECT",
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
    console.log("categoryID:" + categoryID);
    console.log("newName:" + result.args[1]);
		$.ajax({
      url: "/alfresco/service/bv/product/category?alf_ticket=" + $("#alf_ticket").val(),
      dataType: "json",
      type: "PUT",        
      data: {          
        categoryID: categoryID,
        categoryName: result.args[1]          
      }
    }) 
  });
});
