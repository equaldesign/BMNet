$(function(){
  $(".tweetinput").livequery("focus",function(){
    $(this).hide();
    $(this).closest(".tweet-box").find(".compose-tweet").show().find(".tweettextarea").focus();
    if ($(this).attr("placeholder") != "Compose new Tweet...") {
      $(this).closest(".tweet-box").find(".compose-tweet").show().find(".tweettextarea").val("@" + $(this).attr("placeholder").split("@")[1] + " ");
    }

  });
  $(".tweettextarea").livequery("blur",function(){
    $(this).closest(".tweet-box").find(".compose-tweet").hide();
    $(this).closest(".tweet-box").find(".tweetinput").show();   
  })
  $(".tweet").livequery(function(){
    $(this)
      .hover(function(){
        $(this).find(".extra").show();
      }, function() {
        $(this).find(".photo").hide();
        $(this).find(".extra").hide();
    });
  })
  $(".showImage").livequery("click",function(){
    $(this).parent().find(".photo").show();
  })
  $(".following").livequery(function(){
    $(this)
      .hover(function(){
        if ($(this).hasClass("following-true")) {
          $(this).removeClass("btn-info").addClass("btn-danger").text("unfollow");
        }
      }, function() {
        if ($(this).hasClass("following-true")) {
          $(this).removeClass("btn-danger").addClass("btn-info").text("following");
        }
    })
  })
  $(".retweet").livequery("click",function(){
    // get the tweet
    var tweet = $(this).closest(".media").clone();
    $(tweet).find(".tweet-extra").remove();
    $(tweet).find(".tweet-response").remove();
    $("#retweetDialog").find(".modal-body").html(tweet);
    $('#retweetDialog').modal("show");
  })
  $(".reply").livequery("click",function(){
    var userName = $(this).closest(".media").find(".media-heading").find("b").text();
    $(this).closest(".media").find(".tweet-response").show().find(".tweetinput").attr("placeholder","Reply to @" + userName);    
  })
});