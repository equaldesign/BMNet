 var fckInstance = "";
 $(document).ready(function(){ 	  
  $("#doComment").click("click",function(){	 
		var add = $("#doBlog").attr("action");        		
		var jsonObject = new Object();
		$("#whiteBox").block();
		jsonObject.title = $(".blog_title").val();
		jsonObject.content = CKEDITOR.instances.content.getData();
		jsonObject.site = $("#doBlog").attr("data-siteID");
		jsonObject.container = "blog";
		jsonObject.page = "blog-postview"; 
		jsonObject.draft = "false";		
		jsonObject.tags = $(".blog_tags").val().split(",");    
		$.ajax({ 
      url: add,
      contentType: "application/json",
      data: JSON.stringify(jsonObject),
      dataType: "json",
      type: $("#doBlog").attr("method"),
      success: function (data) {
        $("#whiteBox").unblock();
				document.location.href="/bv/blog/item?nodeRef=" + data.item.url + "&siteID=" + $("#doBlog").attr("data-siteID");;       				
      }      
    });		
		return false;		
	});
 });
  $("#doBlog").submit(function(){
		return false;
	})
function FCKeditor_OnComplete( editorInstance ){
        //this is how you can assign onsubmit action
				fckInstance = editorInstance.Name;        
}
