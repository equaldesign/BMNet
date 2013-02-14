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
			"plugins": ["json_data", "cookies", "dnd"]
		}).bind("move_node.jstree", function(e, data){
			data.rslt.o.each(function(i){
				$.ajax({
					type: 'POST',
					contentType: 'application/json',
					dataType: "json",
					url: "/alfresco/service/slingshot/doclib/action/move-to/node/" + data.rslt.np.attr("id").replace(":/", "") + "?alf_ticket=" + $("#alf_ticket").val(),
					data: '{"nodeRefs": ["' + $(this).attr("id") + '"]}',
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
