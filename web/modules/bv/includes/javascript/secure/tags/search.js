$(function(){
  $('.tagSearch').autocomplete({ 
      delay: 2,
      source: "/alfresco/service/bv/tag/search?siteID=" + $("#tagsiteID").val() + "&container="  + $("#tagContainer").val() + "&alf_ticket=" + $("#alf_ticket").val(),
      minLength: 3,
      select: function( event, ui ) {
        addTag(ui.item.value);  
      }
         
  });
  function addTag(value) {
    var jsonObject = [];    
    jsonObject[0] = value;
    $.ajax({
      url: "/alfresco/service/api/node/workspace/SpacesStore/" + $("#tagNode").val() + "/tags?alf_ticket=" + $("#alf_ticket").val(),
      contentType: "application/json",
      data: JSON.stringify(jsonObject),
      dataType: "json",
      type: "POST",
      success: function(data) {
        $("#tags ul").append('<li><a class="tag" href="/bv/tags?type="' + $("#tagContainer").val() + '">' + value + ' </a><a class="deleteTag" data-name="'  + value + '" data-node="' + $("#tagNode").val() +'" href="#"><i class="icon-cross-circle-frame"></i></a></li>');            
        $(".tagSearch").val("");          
      }
    })
  }
  $(".tagSearch").bind("keydown",function(e){
    var code = (e.keyCode ? e.keyCode : e.which);
     if(code == 13) { //Enter keycode
       var tagName = $(this).val();
       addTag(tagName);  
        
       return false;
     }
  })
  $(".deleteTempTag").live("click",function(){
    var tag = $(this).parent().text();
    $(this).parent().remove();
    $("#newTags").val($("#newTags").val().replace("," + tag,""));
  })
})