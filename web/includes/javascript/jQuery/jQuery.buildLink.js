(function($){
  $.buildLink = function(linkTo,qs,m) {
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
			if (m != undefined) {
				returnLink = "/" + m + "/" + linkTo;
			}	else if ($("#currentModule").val() != "" && $("#currentModule").val() != undefined) {
				returnLink = "/" + $("#currentModule").val() + "/" + linkTo;
			} else {
			 returnLink = "/" + linkTo;	
			}     			
		        
		}	else {
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
