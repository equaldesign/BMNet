$(document).ready(function(){
    var options = { 
              // target:        '#' + group + "_0" ,   // target element(s) to be updated with server response 
                // pre-submit callback 
              success:       afterComment,  // post-submit callback 
       
              // other available options: 
              //url:       url         // override for form's 'action' attribute 
              //type:      type        // 'get' or 'post', override for form's 'method' attribute 
              dataType:  "html"      // 'xml', 'script', or 'json' (expected server response type) 
              //clearForm: true        // clear all form fields after successful submit 
              //resetForm: true        // reset the form after successful submit 
       
              // $.ajax options can be used here too, for example: 
              //timeout:   3000 
          }; 
       
          // bind form using 'ajaxForm' 
        $('#form_comment').ajaxForm(options);
				$(".deleteComment").live("click",function() {
					var thisLink = $(this);
					$.post($.buildLink("comment.delete","id=" + $(this).attr("rev")),function(data){
					 $(thisLink).closest(".commentBox").remove();	
					})
									
					return false;
				})
				$("#commentSectionControl").click(function() {
					 $(this).toggleClass("hide");
					 $("#commentSection").toggle();
					 return false;
					  }
					);
        $(".commentMenu").live("click",function(){
					$(this).next().toggle();
				})
				
});				
 function afterComment(responseText, statusText, xhr, $form)  { 
    // for normal html responses, the first argument to the success callback 
    // is the XMLHttpRequest object's responseText property 
 
    // if the ajaxForm method was passed an Options Object with the dataType 
    // property set to 'xml' then the first argument to the success callback 
    // is the XMLHttpRequest object's responseXML property 
 
    // if the ajaxForm method was passed an Options Object with the dataType 
    // property set to 'json' then the first argument to the success callback 
    // is the json data object returned by the server 
    htmlData = responseText;    
    console.log(htmlData);
    $("#comments").prepend(htmlData);     
    // alert('status: ' + statusText + '\n\nresponseText: \n' + responseText +  '\n\nThe output div should have already been updated with the responseText.'); 
}				