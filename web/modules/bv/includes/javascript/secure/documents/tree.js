var docTree;

$(document).ready(function(){

	
		docTree = $("#documentTree").jstree({
			"json_data": {
				"ajax": {
					"url": "/alfresco/service/bv/docs/treelist?alf_ticket=" + $("#alf_ticket").val(),
					"data": function(n){
						return {
							nodeRef: n.attr ? n.attr("id") : $("#folderNodeRef").val()
						};
					}
				}
			},
			"cookies": {
				"save_opened": "jstree_open",
				"auto_save": "true"
			},
			"plugins": ["json_data", "cookies"]
		});

});
