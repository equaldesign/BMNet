$(document).ready(function(){
  // Get the parent page URL as it was passed in, for browsers that don't support
  // window.postMessage (this URL could be hard-coded).
  var parent_url = decodeURIComponent( document.location.hash.replace( /^#/, '' ) ),
    link;
  
  // The first param is serialized using $.param (if not a string) and passed to the
  // parent window. If window.postMessage exists, the param is passed using that,
  // otherwise it is passed in the location hash (that's why parent_url is required).
  // The second param is the targetOrigin.
  function setHeight() {
		var theH = $("#ajaxMain").outerHeight();
    $.postMessage({
		thisHeight: theH
	}, parent_url);
  };  
  setInterval(setHeight,5000);
  // Now that the DOM has been set up (and the height should be set) invoke setHeight.  
}); 