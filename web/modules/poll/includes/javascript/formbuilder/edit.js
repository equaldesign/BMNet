if (formbuilder == undefined) {
	var formbuilder = true;
	$(document).ready(function(){
		function reloadTabs () {          
	    $("#pollTabs").tabs('load',$("#pollTabs").tabs('option', 'selected'));    
	  }
		// do nothing...
		$(".collpase").livequery("click",function(){
			$(this).parent().parent().children("div.widget-content").toggle();
		})
		$(".deleteE").click(function(){
			var thisEle = $(this).parent();
			$.blockUI();
			$.ajax({
				url: $(this).attr("href"),
				success: function(){
					$(thisEle).remove();
					$.unblockUI();
					reloadTabs();
				}
			})
			return false;
		});
		$(".addGroup").livequery("click",function(){
			var container = $(this).closest(".box");
			var formData = new Object();
			$(container).find(".newField").each(function(){
				var a = $(this).attr("id").split("_");
				formData.table = a[1];
				formData.rel = a[3];
				formData.id = a[4];
				formData[a[2]] = $(this).val();
			})
			
			$.blockUI();
			$.ajax({
				url: "/poll/formbuilder/addGroup",
				data: formData,
				type: "POST",
				success: function(data){
					$.unblockUI();
					reloadTabs();
				}
			})
		});
		$(".addField").livequery("click",function(){
			var container = $(this).closest(".box");
			var formData = new Object();
			$(container).find(".newField").each(function(){
				var a = $(this).attr("id").split("_");
				formData.table = a[1];
				formData.rel = a[4];
				formData.id = a[3];
				if ($(this).attr("type") == "checkbox") {
					formData[a[2]] = $(this).is(":checked");
				}
				else {
					formData[a[2]] = $(this).val();
				}
				
			})
			
			$.blockUI();
			$.ajax({
				url: "/poll/formbuilder/addField",
				data: formData,
				type: "POST",
				success: function(data){
					$.unblockUI();
					reloadTabs();
				}
			})
		})
		$(".instantUpdate").livequery("change",function(){
			var formData = new Object();
			var thisID = $(this).attr("id");
			var thisSplitter = thisID.split("_");
			formData.table = thisSplitter[0];
			formData.field = thisSplitter[1];
			formData.id = thisSplitter[2];
			formData.value = $(this).val();
			
			$.blockUI();
			$.ajax({
				url: "/poll/formbuilder/edit",
				data: formData,
				type: "POST",
				success: function(data){
					$.unblockUI();
					reloadTabs();
				}
			})
		})
		$(".instantAdd").livequery("change",function(){
			var formData = new Object();
			var thisID = $(this).attr("id");
			var thisSplitter = thisID.split("_");
			formData.table = thisSplitter[0];
			formData.rel = thisSplitter[1];
			formData.id = thisSplitter[2];
			formData.value = $(this).val();
			
			$.blockUI();
			$.ajax({
				url: "/poll/formbuilder/addoption",
				data: formData,
				type: "POST",
				success: function(data){					
					$.unblockUI();
					reloadTabs();
				}
			})
		})
		$('.draggable').each(function(){
			var id = $(this).attr("id");
			var el = this;
			$(this).sortable({
				placeholder: 'dragging',
				containment: 'parent',
				helper: 'clone',
				opacity: 0.6,
				scroll: true,
				cursor: 'move',
				axis: 'y',
				update: function(event, ui){
					var option = $(this).sortable('toArray');
					var itemOrder = [];
					
					for (i = 0; i <= option.length; i++) {
						if (option[i] != "" && option[i] != null) {
							var item = option[i].split("_");
							if (item[1] != null && item[1] != "" && item[1] != "null" && item[1] != undefined) {
								itemOrder.push(item[1]);
								table = item[0];
							}
						}
					}
					var jsonStruct = new Object();
					jsonStruct.table = table;
					jsonStruct.items = itemOrder;
					var jsonString = JSON.stringify(jsonStruct);
					
					$(this).block();
					$.ajax({
						url: $.buildLink("formbuilder.move"),
						type: "POST",
						contentType: "application/json",
						dataType: "html",
						data: jsonString,
						success: function(data){
							$(el).unblock();
							reloadTabs();
						}
					});
				},
				delay: 500,
				handle: '.handle',
				revert: true
			});
		});
	})
}