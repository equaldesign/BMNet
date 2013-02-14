
	$(function(){
		$("#createLink").click(function(){
			var jsonObject = {};
			jsonObject.linkName = $("#newLinkForm").find("#link_name").val();
			if ($("#newLinkForm").find("#link_name").val() == "" && $("#newLinkForm").find("#link_page option:selected").text() != "--none--") {
				jsonObject.linkName = $("#newLinkForm").find("#link_page option:selected").text();
			}
			jsonObject.linkURL = $("#newLinkForm").find("#link_url").val();
			jsonObject.linkTarget = $("#newLinkForm").find("#link_target").val();
			jsonObject.linkPage = $("#newLinkForm").find("#link_page").val();
			jsonObject.linkNodeRef = $("#newLinkForm").find("#linkNodeRef").val();
			jsonObject.pageNodeRef = $("#nodeRef").val();
			if (jsonObject.linkPage != "") {
				// this is what we care about;
				jsonObject.linkURL = jsonObject.linkPage;
			}
			$.ajax({
				url: $(this).closest("form").attr("action"),
				data: $.toJSON(jsonObject),
				datatype: "json",
				contentType: "application/json",
				type: $(this).closest("form").attr("method"),
				success: function(data){
					$.ajax({
			      url: $("#pageLinks").attr("href"),
			      datatype: "html",
			      success: function(data) {
			        $("#linkSelector").html(data);        			                  
			      }
			    })
				}
			})
		})
		
		$("#showLinks").click(function(){
			var jsonObject = {};
			jsonObject.showLinks = $(this).is(":checked");
			$.ajax({
        url: "/alfresco/service/sums/link/show?nodeRef=" + $("#nodeRef").val() + "&alf_ticket=" + $("#alf_ticket").val(),                
        type: "post",
				data: $.toJSON(jsonObject),
        datatype: "json",
        contentType: "application/json",
        success: function(data){
          
        }
      })
		})
		$("#inheritLinks").click(function(){
      var jsonObject = {};
			jsonObject.inheritLinks = $(this).is(":checked");
      $.ajax({
        url: "/alfresco/service/sums/link/inherit?nodeRef=" + $("#nodeRef").val() + "&alf_ticket=" + $("#alf_ticket").val(),                
        type: "post",
        data: $.toJSON(jsonObject),
        datatype: "json",
        contentType: "application/json",
        success: function(data){
          
        }
      })
    })
		
		
		$("#linkList").sortable({
      placeholder: "ui-state-highlight",
      handle: "i.draghandler",
      containment: "parent",
      cursor: "move",
      revert: true,
      update: function(event, ui){
        var nodeArray = [];
        $("#linkList").find("li").each(function(){
          nodeArray.push($(this).attr("rel"));
        })
        $("#linkList").block();
        var jsonObject = {};
        jsonObject.links = nodeArray;
        $.ajax({
          url: "/alfresco/service/sums/link/reorder?pageNodeRef=" + $("#pageNodeRef").val() + "&alf_ticket=" + $("#alf_ticket").val(),
          contentType: "application/json",
          type: "post",
          data: $.toJSON(jsonObject),
          success: function(data){
            $("#linkList").unblock();
          }
        });                 
      }
    });
    $("#linkList").disableSelection();
})

