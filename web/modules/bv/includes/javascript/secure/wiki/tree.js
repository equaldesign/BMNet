$(document).ready(function(){
$("#wikiTree").jstree({
    "json_data" : {
      "ajax" : {
        "url" :  "/alfresco/service/bv/wiki/tree/" + $("#productTree").attr("rel") + "?alf_ticket=" + $("#alf_ticket").val(),
        "data" : function (n) { 
          return { nodeRef : n.attr ? n.attr("id") : ""  }; 
        }
      }
    },                   
    "cookies" : {
      "save_opened" : "JSTREE_OPEN",
			"save_selected": "JSTREE_SELECT",
      "auto_save" : "false"
    },
    "plugins" : [
       "json_data",
       "cookies"
    ]
  });  
});
