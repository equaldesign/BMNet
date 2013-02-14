$(function() {
  $.widget("custom.tasksearch", $.ui.autocomplete, {
    _renderMenu: function( ul, items ) {
      var self = this,
        currentCategory = "";
      $.each( items, function( index, item ) {
        if ( item.category != currentCategory ) {
          ul.append( "<li class='sresults-"+ item.category +"'>" + item.category + "</li>" );
          currentCategory = item.category;
        }
        self._renderItem( ul, item );
      });
    },
    _renderItem: function( ul, item) {
    return $( "<li></li>" )
        .data( "item.autocomplete", item )
        .append( "<a class='sresultitem-" + item.iconclass + "'>" + item.label + "</a>" )
        .appendTo( ul );
    }
  });
  $('#relationshipSearch').tasksearch({
      delay: 1,
      source: $("#relationshipSearch").attr("data-url"),
      minLength: 3,
      select: function(event, ui){
				var chil = $("#relationship").find("tbody tr").length + 1;    				
				var tableData = '<tr><td><a class="del" href="#"><i class="icon-delete"></i></a>' +
				'<input type="hidden" name="relationship[' + chil + '].' + ui.item.category + '" value="' + ui.item.id + '" />' +
				'<input type="hidden" name="relationship[' + chil + '].type" value="' + ui.item.category + '" />' +
				'<input type="hidden" name="relationship[' + chil + '].system" value="' + ui.item.system + '" />' +
				'</td><td> ' + ui.item.label + '</td><td>' + ui.item.category + '</td></tr>';
        $("#relationship").find("tbody").append(tableData);
      } 
    });
  $('#participantSearch').tasksearch({
      delay: 1,
      source: $("#participantSearch").attr("data-url"),
      minLength: 3,
      select: function(event, ui){
				var chil = $("#participant").find("tbody tr").length + 1;    
        var tableData = '<tr><td><a class="del" href="#"><i class="icon-delete"></i></a>' +
        '<input type="hidden" name="participant[' + chil + '].' + ui.item.category + '" value="' + ui.item.id + '" />' +
				'<input type="hidden" name="participant[' + chil + '].type" value="' + ui.item.category + '" />' +
        '<input type="hidden" name="participant[' + chil + '].system" value="' + ui.item.system + '" />' +
        '</td><td> ' + ui.item.label + '</td></tr>';        
        $("#participant").find("tbody").append(tableData);
      } 
    });
		$(".del").live("click",function(){
			$(this).closest("tr").remove();
		})
  $("#addActivity").click(function(){
		var chil = $("#activities").find("tbody tr").length + 1;		
		var tableData = '<tr><td><a class="del" href="#"><i class="icon-delete"></i></a>' + 
		'<input type="hidden" name="activity[' + chil + '].name" value="' + $("#activityname").val() + '" />' + 
		'<input type="hidden" name="activity[' + chil + '].description" value="' + $("#activityDescription").val() + '" />' +
		'<input type="hidden" name="activity[' + chil + '].due" value="' + $("#dueDate").val() + '" />' +
		'<input type="hidden" name="activity[' + chil + '].reminder" value="' + $("#reminderDate").val() + '" />' +
		'</td>' +
		'<td>' + $("#activityname").val() + '</td>' + 
		'<td>' + $("#dueDate").val() + '</td>' +
		'<td>' + $("#reminderDate").val() + '</td>' +
		'</tr>';     
		$("#activities").find("tbody").append(tableData);
	})
	$("#itemName").change(function(){
		$("#activityname").val($(this).val());
	})
	$("#itemDescription").change(function(){
    $("#activityDescription").val($(this).val());
  })
})