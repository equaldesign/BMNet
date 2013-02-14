$(document).ready(function(){
  var subButt = $('.ui-dialog-buttonpane').find('button:contains("Save")');
  var dialogForm = $(".ui-dialog-content").find("form");
	$(dialogForm).ajaxForm({
    success: function(){      
      p = location.hash;  
			if (p.substring(0,2) == "#!") {          
          var uriArray = p.split("!");
          if (uriArray.length > 1) {
            var windowName = uriArray[1].replace("#","");
            //console.log(windowName);
            var uri = uriArray[2];
          } else {
            var windowName = "maincontent";
            var uri = uriArray[1];
          }                  
					if (uri.indexOf("?") >= 0) {
            appendC = "&"
          } else {
            appendC = "?";
          }
					if (uri.indexOf("fwCache") < 0) {
					 uri += appendC + "fwCache=true";
					}
					uri = windowName + "!" + uri;      	
          document.location.href = "#!" + uri;
      } else {
				window.location.reload()
			}
      $("#dialog").dialog("close");
    }
  })
  $(subButt).click(function(){
    $(dialogForm).submit();
  })
})
