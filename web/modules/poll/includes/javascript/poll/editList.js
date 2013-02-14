$(function(){
	var oCurrentList = $('#currentList').dataTable();
	$(".jstree-draggable").draggable();
	
	$("#addGroup").livequery("click",function(){
		var groupList = [];
		$(".group_check:checked").each(function(){
			groupList.push($(this).val());
		});
		$.ajax({
			url: "/poll/addUsers",
			data: {
				id: $("#pollID").val(),
				groupList: groupList.join(",")
			},
			success: function(data){
				resultList = data.DATA;
				for (i = 0; i < resultList.ID.length; i++) {
					oCurrentList.fnAddData(['<tr><td><input class="invitee_check" type="checkbox" name="invitee" value=' + resultList.ID[i] + '" />', resultList.NAME[i], resultList.KNOWN_AS[i]]);
				}
			}
		})
	})
	
	$("#addUser").livequery("click",function(){
		var userList = [];
		$(".contact_check:checked").each(function(){
			userList.push($(this).val());
		});
		$.ajax({
			url: "/poll/addUsers",
			data: {
				id: $("#pollID").val(),
				userList: userList.join(",")
			},
			success: function(data){
				resultList = data.DATA;
				for (i = 0; i < resultList.ID.length; i++) {
					oCurrentList.fnAddData(['<tr><td><input class="invitee_check" type="checkbox" name="invitee" value=' + resultList.ID[i] + '" />', resultList.NAME[i], resultList.KNOWN_AS[i]]);
				}
			}
		})
	})
	$("#delInvitee").livequery("click",function(){
		var userList = [];
		$(".invitee_check:checked").each(function(){
			userList.push($(this).val());
		});
		$.ajax({
			url: "/poll/removeUsers",
			data: {
				id: $("#pollID").val(),
				userList: userList.join(",")
			},
			success: function(data){
				$(".invitee_check:checked").each(function(){
					$(this).closest("tr").remove();
				})
			}
		})
	})
	$("#doSendInvites").livequery("click",function(){
		var whotoNotify = $("#whotonotify").val();
		var userList = [];
		if (whotoNotify == "selected") {
			$(".invitee_check:checked").each(function(){
				userList.push($(this).val());
			});
		}
		else {
			$(".invitee_check").each(function(){
				userList.push($(this).val());
			});
		}
		$("#inviteeID").val(userList.join(","));
		$("#editInviteeList").submit();
	})
})	