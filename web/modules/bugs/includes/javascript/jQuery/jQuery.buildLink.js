(function($){
  $.buildLink = function(linkTo,qs) {
    var isSES = true;   
    var returnLink = "";
    if(isSES){
      /* SSL */
      linkTo = linkTo.replace(/\./g,"/");
      /* Query String Append */
      if (qs != "" && qs != null){        
        linkTo = linkTo +  "/" + qs.replace(/\&/g,"/");
        linkTo = linkTo.replace(/\=/g,"/");
      }
      /* Prepare link */
      if ($("#currentModule").val() != "" && $("#currentModule").val() != undefined) {
        returnLink = "/" + $("#currentModule").val() + "/" + linkTo;
      } else {
       returnLink = "/" + linkTo; 
      }    
			console.log($("#currentModule").val());       
            
    } else {
      /* Check if sending in QUery String */
      if (qs != "" && qs != null){
        returnLink = "index.cfm?event=" + linkTo + "&" + qs;
      } else{
        returnLink = "index.cfm?event=" + linkTo;
      }
    }
    return returnLink; 
  };
})(jQuery);
