$(document).ready(function(){
	var rcID = $("#rootCategoryID").val();
$("#dealTree").jstree({
		"json_data" : {
            "ajax" : {
				"url" :  "/eunify/psa/tree",
				"data" : function (n) { 
					return { id : n.attr ? n.attr("id") : 0 }; 
				}
			}
			,"data" : [
                                {
                                        "data" : "Current Confirmed Agreements"
                                        ,"state" : "closed"
                                        ,"attr" : {"id" :rcID}
                                }
                        ] 			
        },
		
 		"cookies" : {
			"save_opened" : "jstree_open",
			"auto_save" : "true"
		},
        "plugins" : [ "json_data","cookies" ]
	});
	$("#historicTree").jstree({
    "json_data" : {
            "ajax" : {
        "url" :  "/eunify/psa/tree",
        "data" : function (n) { 
          return { id : n.attr ? n.attr("id") : 0, type: "historic" }; 
        }
      }
      ,"data" : [
                                {
                                        "data" : "Historic Agreements"
                                        ,"state" : "closed"
                                        ,"attr" : {"id" :rcID}
                                }
                        ]       
        },

        "plugins" : [ "json_data"]
  });
	$("#inProgressTree").jstree({
    "json_data" : {
            "ajax" : {
        "url" :  "/eunify/psa/tree",
        "data" : function (n) { 
          return { id : n.attr ? n.attr("id") : 0, type: "progress" }; 
        }
      }
      ,"data" : [
                                {
                                        "data" : "Agreements in progress"
                                        ,"state" : "closed"
                                        ,"attr" : {"id" :rcID}
                                }
                        ]       
        },

        "plugins" : [ "json_data" ]
  });
	
})
