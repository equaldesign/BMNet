$(function(){
  
   $('#calendar').fullCalendar({
      header: {
        left: 'prev,next',
        center: 'title',
        right: 'month,basicWeek,basicDay'
      },
			lazyFetching: false,
			eventClick: function(calEvent, jsEvent, view) {
				var currentQString = $.deparam.querystring(); 
				currentQString["id"] = calEvent.id
				$.bbq.pushState($.param.querystring("!maincontent!/eunify/calendar/detail/",currentQString,0));		  
			},
			
			theme: false,
      editable: true,
      droppable: false,
			eventSources: getEventSources()
    }); 
		function getEventSources() {		  
      var returnA = [];
      $(".calendar-address").each(function() {
				var dataDiv =this;
        if ($(this).attr("data-url") != "") {
          eventOb = {
            url: $(this).attr("data-url"),
            type: 'POST',
            error: function() {
                alert('there was an error while fetching events!');
            },
						success: function(data) {
							$(dataDiv).empty();
							console.log(data);
							//$("#eventList").empty();
							for (i=0;i<data.length;i++) {
								if ($(dataDiv).find("#eventdetail_" + data[i].id).length == 0) {
									if (data[i].target == undefined) {
										target = "_blank"
									} else {
										target = data[i].target;
									}
									var niceDate = getNiceDate(data[i].start);
									var eventWidget = '<div id="eventdetail_' + data[i].id + '" class="widget-box">' +
									'<div class="widget-title">' +
									'<span class="icon"><i class="icon-calendar-day"></i></span>' +
									'<h5><a href="' + data[i].url +	'" target="' + target + '">' + niceDate + '</a></h5>' +
									'</div>' +
									'<div class="widget-content">' +
									'<p>' +	data[i].title +	'</p>' +
									'</div>' +
									'</div>';
									$(dataDiv).append(eventWidget);
								}
							}														
						},
            color: $(this).attr("data-bgcolor"),   // a non-ajax option
            textColor: $(this).attr("data-textcolor") // a non-ajax option
          }
          returnA.push(eventOb)
        }      
      })
      return returnA;
		}
		function getNiceDate(d) {
			try {
	  	  return $.fullCalendar.formatDate(d, "ddd dS MMM @ H:mm");
	    } catch (e) {
				return $.fullCalendar.formatDate(new Date(d), "ddd dS MMM @ H:mm");
			}
		}
});