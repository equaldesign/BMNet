$(document).ready(function(){
var productTree = $("#productTree").jstree({
	 "types" : { 
      "types" : {
				"valid_children": ["default","product"], 
        "default" : {           
          "select_node" : function(id) { 
                  this.toggle_node(id); 
                  return false; 
          } 
        }, 
        "product" : {           
          "select_node": function(id){				  	
				  	return true;
				  } 
        } 
      } 
    }, 
    "json_data" : {
      "ajax" : {
        "url" :  "/eunify/products/tree",
        "data" : function (n) { 
          return { id : n.attr ? n.attr("id") : 0  }; 
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
					"rename": false,
          "create" : {
            // The item label
            "label" : "Create Category",
            // The function to execute upon a click
            "action": function (obj) { 
              var parentID = $(obj).attr("id")
              var n = this;
							$("#dialog").dialog({
                title: $(this).attr("name"),
                buttons: {
                  "Save": {
                    "class": "btn btn-success", 
                    "text": "Save",
                    "click": function() { 
                      $("#dialog").find("form").submit();
                    }                     
                  }, 
                  "Cancel": {
                    "class": "btn",
                    "text": "Cancel",
                    "click": function(){
                      $(this).dialog("close");
                    } 
                   
                  } 
                } 
              })
              $.ajax({
                url: "/eunify/category/edit",
                dataType: "html",
                type: "GET",
                data: {                                                                           
                  "parentID": parentID 
                },
                success: function(data) {
                  $("#dialog").html(data);
                  $("#dialog").dialog("open");
                                  
                }
              }) 
                                         
            }           
           },
					 "details" : {
            // The item label
            "label" : "Edit Category",
            // The function to execute upon a click
            "action": function (obj) { 
              var parentID = $(obj).attr("id")
              var n = this;
               $("#dialog").dialog({
                title: $(this).attr("name"),
                buttons: {
                  "Save": {
                    "class": "btn btn-success", 
                    "text": "Save",
                    "click": function() { 
                      $("#dialog").find("form").submit();
                    }                     
                  }, 
                  "Cancel": {
                    "class": "btn",
                    "text": "Cancel",
                    "click": function(){
                      $(this).dialog("close");
                    } 
                   
                  } 
                } 
              })
              $.ajax({
                url: "/eunify/category/edit",
                dataType: "html",
                type: "GET",
                data: {                                                                           
                  "categoryID": parentID 
                },
                success: function(data) {
                  $("#dialog").html(data);
                  $("#dialog").dialog("open");
                                  
                }
              })                                                
            }           
           },           
           "deletecategory": {           
            "label": "Delete Category",
            
            "action": function(obj){
              var che = window.confirm("This will remove this category and potentially orphan products within it. Are you sure?");
              if (che) {                
               var n = this;
                var categoryID = $(obj).attr("id");                 
                $.ajax({
                  url: "/eunify/category/delete?categoryID=" + categoryID,
                  dataType: "html", 
                  type: "GET",                 
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
        productID = $(product).attr("rel");         
        categoryID = $(category).attr("id");          
        $.ajax({
          url: "/eunify/products/move",
          dataType: "html",
          type: "POST",        
          data: {         
            productID: productID,
            categoryID: categoryID          
          },
         success: function(data) {
            var uriArray = $.address.value().split("!");
            if (uriArray.length > 1) {
              var windowName = uriArray[0].replace("/","");
              var uri = uriArray[1];
            } else {
              var windowName = "maincontent";							
              var uri = uriArray[0];
            }
						if (uri.indexOf("?") >= 0) {
              appendC = "&"
            } else {
              appendC = "?";
            }
					  uri += appendC + "fwCache=true";
            $("#" + windowName).block();
              $.get(uri, function(data){                
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
		   "themes",
			 "types",
			 "ui",
       "json_data",
       "cookies",
       "dnd",
       "crrm",
       "contextmenu" 
    ]
  });  

	$("#productTree").bind("move_node.jstree", function(e, data){
      data.rslt.o.each(function(i){
        $.ajax({
          type: 'POST',          
          url: "/eunify/category/move/",
          data: {
						"sourceID": $(this).attr("id"),
						"position": data.rslt.cp + i,
						"targetID": data.rslt.np.attr("id")
          },					
          success: function(r){
            $(data.rslt.oc).attr("id", "node_" + r.id);
            if (data.rslt.cy && $(data.rslt.oc).children("UL").length) {
              data.inst.refresh(data.inst._get_parent(data.rslt.oc));
            }
            
          },
          error: function(){
            $.jstree.rollback(data.rlbk);
            alert("there was an error moving your document");
          }
        });
        
      });
    });

});
