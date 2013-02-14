$(function() {
	var hasUpdated = false;
    $( ".sortthem" ).sortable({
        connectWith: ".sortthem",
        placeholder: 'ui-state-highlight',
				cursor: "move",
				over: function(event,ui) {
					$(ui.placeholder).closest("div").css("border","1px solid red");					
				},
				out : function (event,ui) {
					$(ui.placeholder).closest("div").css("border","none");
				},
				receive : function (event,ui) {
					$(ui.item).closest("div").css("border","none");
					console.log(ui);
					var stageID = $(ui.item).closest(".sortthem").attr("id").split("_")[1];          
          var itemID = $(ui.item).attr("id").split("_")[1]; 
          //var stageTotal = $(ui.item).closest("div").find("h4");       
          var oldstageID = $(ui.sender).closest(".sortthem").attr("id").split("_")[1];
          //var oldstageTotal = $(ui.sender).closest("div").find("h4")
          $.ajax({
            url: "/flo/item/changeStage",
            data: {
              id: itemID,
              stageID: stageID
            },
            success: function() {
              $.ajax({
                url: "/flo/stage/getStageTotal",
                data: {                
                  stageID: stageID
                },
                success: function(data) {
                  // $(stageTotal).html("&pound;" + addCommas(data.DATA.AMOUNT[0]) + " " + data.DATA.ITEMS[0] + " deals");     
                  $.ajax({
                    url: "/flo/sales/getStageTotal",
                    data: {                
                      stageID: oldstageID     
                    },
                    success: function(data) {
                      //$(oldstageTotal).html("&pound;" + addCommas(data.DATA.AMOUNT[0]) + " " + data.DATA.ITEMS[0] + " deals");                 
                    }
                  });           
                }
              });
            }            
          }); 
									
        }
    }).disableSelection();
});

function addCommas(nStr)
{
  if (nStr == null) {
		nStr = 0;
	}
	nStr += '';
  x = nStr.split('.');
  x1 = x[0];
  x2 = x.length > 1 ? '.' + x[1] : '';
  var rgx = /(\d+)(\d{3})/;
  while (rgx.test(x1)) {
    x1 = x1.replace(rgx, '$1' + ',' + '$2');
  }
  return x1 + x2;
}