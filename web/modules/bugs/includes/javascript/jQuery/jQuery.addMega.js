$(document).ready(function() {
      var dSOptions = {			
			left: 1,
			top: 1
			};
      function addMega(){
        $(this).addClass("hovering");
				

        }

      function removeMega(){
        $(this).removeClass("hovering");
        }

    var megaConfig = {
         interval: 100,
         sensitivity: 4,
         over: addMega,
         timeout: 500,
         out: removeMega
    };

    $("li.mega").hoverIntent(megaConfig)   
    });
