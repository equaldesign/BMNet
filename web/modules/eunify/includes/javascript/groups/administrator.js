$(document).ready(function(){  
var groupTree = $("#groupTree").jstree({
  "json_data" : {
    "ajax" : {
      "url" :  "/eunify/groups/tree",
      "data" : function (n) { 
        return { 
          id : n.attr ? n.attr("id") : 0,
					showUsers: $("#showUsers").is(":checked") }; 
        }
    },        
    "data" : [{
      "data" : "Groups",
			"state" : "closed",
			"attr" : {
		    "id" : "0",
				"icon": "groups"
			}
    }]    
  },
  "contextmenu" : {   
      items: {              
          "ccp" : false,
          "remove": false,  					
          "create" : {
            // The item label
            "label" : "Create New Group",
						"icon": "create",
            // The function to execute upon a click
            "action": function (obj) { 
              var parentID = $(obj).attr("id")
              var n = this;
              $.ajax({
                url: "/eunify/groups/createGroup",
                dataType: "json",
                type: "POST",
                data: {                                     
                  "categoryName": "New Category",
                  "parentID": parentID 
                },
                success: function(data) {
                  n.create(obj,"inside",{
                    "attr": {
                      "id": data.groupID,
											"icon": "group"
                    },
                    "state": "open",
                    "data": data.groupName                          
                 });                                          
               }
              })
                                       
            }           
           },
					 "rename": {
            // The item label
              "label" : "Rename Group",
							"icon": "rename",
              // The function to execute upon a click
              "action": function (obj) { 
                          this.rename(obj);                         
                        }              
           },
           "deletecat": {           
            "label": "Delete Group",
						"icon": "delete",
            
            "action": function(obj){
              var che = window.confirm("This will remove this group permenantly. Are you sure?");
              if (che) {                
               var n = this;
                var groupID = $(obj).attr("id");                 
                $.ajax({
                  url: "/eunify/groups/delete?id=" + groupID,
                  dataType: "json",                                 
                  success: function(data) {
                    n.delete_node(obj);                                          
                 }
                })
              }
            } 
          },
           "reload": {
            // The item label
              "separator_before": true,
							"icon": "refresh",
							"label" : "Refresh from Server",
              // The function to execute upon a click
              "action": function (obj) { 
                          this.refresh(obj);                         
                        }              
           },
					"deleteGroupIn": {           
            "label": "Remove from tree",
            "icon": "delete_tree",
            "action": function(obj){
              var che = window.confirm("This will remove the selected item from within this group. Are you sure?");
              if (che) {                
               var n = this;
							  var parent = $(obj).closest("ul").parent();
                var groupID = $(obj).attr("id");                 
                $.ajax({
                  url: "/eunify/groups/deleteFromGroup",
                  dataType: "json", 
									data: {
										id: groupID,
										parentID: $(parent).attr("id"),
										oType: $(obj).attr("rev")
									},                            
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
        var moveOb = data.o; 
        var group = data.r;				
				var toMove = $(moveOb).parent().attr("id");
				var targetID = $(group).attr("id");
				var moveA = toMove.split("_");
				var oType = moveA[0];
				var id = moveA[1];
				var tInstance = data.rt;
				$.ajax({
          url: "/eunify/groups/addToGroup",
          dataType: "json", 
					data: {                                     
            "parentID": targetID,
            "id": id,
						"oType": oType 
          },                 
          success: function(data) {
            $.jstree.refresh($(group));                                           
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
  }).bind("move_node.jstree", function (e, data) {		  
      data.rslt.o.each(function (i) {     
      $.ajax({
        type: 'POST',        
        dataType: "json",
        url: "/groups/move",
        data : {
					newParent: data.rslt.np.attr("id"),
					oID: $(this).attr("id"),
					oType: $(this).attr("rev"),
					originalParent: data.rslt.op.attr("id")
					
				},       
        success : function (r) {                      
            if(data.rslt.cy && $(data.rslt.oc).children("UL").length) {
              data.inst.refresh(data.inst._get_parent(data.rslt.oc));
            }
          
        },
        error: function() {
          $.jstree.rollback(data.rlbk);
          alert("there was an error moving your document");
        }
      });
      
    });
  });;  
  $("#groupTree").bind("rename_node.jstree",function(e , result) {
    var newName = result.args[1];
    var categoryID = $(result.args[0]).attr("id");    
		$.ajax({
			url: "/eunify/groups/renameGroup",
			dataType: "json", 
          data: {                                     
            "id": categoryID,
            "name": result.args[1]
          },                 
          success: function(data) {
                            
         }
		})
  });
});