$(function(){
  $(".startTracking").livequery("click",function(){
    var activityID = $(this).attr("data-activityID");
    var e = $(this);
    $.ajax({
      url: "/flo/activities/startTracking",
      data: {
        activityID: activityID
      },
      success: function(data) {
        $(e).html('<img src="/includes/images/spinner.gif" border="0">');
        $(e).attr("title","Started");
        $(e).addClass("stopTracking");
        $(e).removeClass("startTracking");
        $(e).attr("data-trackingID",data);
      }
    }) 
  })
  $(".stopTracking").livequery("click",function(){
    var trackingID = $(this).attr("data-trackingID");
    var activityID = $(this).attr("data-activityID");
    var e = $(this);
    $.ajax({
      url: "/flo/activities/stopTracking",
      data: {
        trackingID: trackingID
      },
      success: function(data) {
        $(e).html('<i class="icon-clock"></i>');
        $(e).attr("title","Start Tracking");
        $(e).removeClass("stopTracking");
        $(e).addClass("startTracking");
      }
    })
  })
})
