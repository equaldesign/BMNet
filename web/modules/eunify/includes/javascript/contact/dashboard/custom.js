$(function() {
    function doSort() {
        $( "#dashboard" ).sortable({
            placeholder: "ui-state-highlight",
            forceHelperSize: true,
            helper: 'clone',
            opacity: 0.6,
            scroll: true,
            cursor: 'move',
            delay: 500,
            handle: '.icon-arrow-move',
            revert: true
        });
        $( "#dashboard" ).disableSelection();
    }
    function fixThumbnailMargins() {
        $('#dashboard .portlet').each(function () {
            var $thumbnails = $(this).children(),
                previousOffsetLeft = $thumbnails.first().offset().left;
            $thumbnails.each(function () {
                var $thumbnail = $(this),
                    offsetLeft = $thumbnail.offset().left;
                if (offsetLeft < previousOffsetLeft) {
                    $thumbnail.css('margin-left', 0);
                }
                previousOffsetLeft = offsetLeft;
            });
        });
    }

    $(".changeSpan").live("click",function(){
        var thisWin = $(this).closest(".portlet");
        var thisWidth = $(this).attr("data-width");
        $(thisWin).attr("class","portlet span" + thisWidth);
        $(thisWin).find(".widget-content").css("width","auto");
        fixThumbnailMargins();
    });
    $(".closeWidget").live("click",function(){
        var thisWin = $(this).closest(".portlet");
        $(thisWin).fadeOut().remove();
    })
    $(".addWidget").live("click",function(){
        $.ajax({
            url:$.buildLink("dashboard.newWidget"),
            success: function(data) {
                $("#dashboard").append(data);
                var newWidget =$(".portlet:last-child");
                loadWidget($.buildLink((newWidget).attr("data-url")),$(newWidget).find(".widget-content"));
                doSort();
                fixThumbnailMargins();
            }
        })

    })
    // load the portlets data
    $(".portlet").each(function(){
        var portletURL = $.buildLink($(this).attr("data-url"),$(this).attr("data-urlattributes"),$(this).attr("data-module"));
        var contentDiv = $(this).find(".widget-content");

        loadWidget(portletURL,contentDiv);

    })
    $(".saveLayout").live("click",function(){
      saveLayout();
      document.location.reload()
    })
    $(".changeUrl").live("click",function(){
      var dataURL = $(this).attr("data-url");
      var dataattributes = $(this).attr("data-urlattributes");
      var dataName = $(this).attr("data-urlname");
      var module = $(this).attr("data-module");			
      var portlet = $(this).closest(".portlet");
      $(portlet).attr("data-url",dataURL);
      $(portlet).attr("data-module",module);			
      $(portlet).attr("data-urlattributes",dataattributes);
      $(portlet).find(".widget-header h5").text(dataName);

      loadWidget($.buildLink(dataURL,dataattributes,$(this).attr("data-module")),$(this).closest(".portlet").find(".widget-content"));
    })
    function loadWidget(u,d) {
        $(d).html("<img src='/includes/images/ajax-loader.gif' />");
        $.ajax({
            url: u,
            success: function(data) {
                $(d).html(data);
                $(d).slimScroll({
                  height: $(d).innerHeight(),
                  animate: true,
                  animateSpeed:0,
                  allowDrag: false
                });
                (d).parent().resizable({
                    resize: function(event, ui) {
                        $(d).css("height",ui.size.height-40);
                        ui.size.width = ui.originalSize.width;
                        $(d).slimScroll({
                            height: $(d).innerHeight(),
                            animate: true,
                            animateSpeed:0,
                            allowDrag: false
                        });
                    }
                });
            }
        })
    }
    function saveLayout() {
      var layoutArray = [];
        $.blockUI();
      $(".portlet").each(function(){
        var portletObject = {};
          portletObject.url = $(this).attr("data-url");
          portletObject.urlattributes = $(this).attr("data-urlattributes");
          portletObject.module = $(this).attr("data-module");					
          portletObject.class = $(this).attr("class");
          portletObject.height = $(this).find(".widget-content").outerHeight();
          portletObject.name = $(this).find(".widget-header h5").html();
          layoutArray.push(portletObject);
      })
        $.ajax({
            url: $.buildLink("contact.setDashboardLayout"),
            data: {
                 l: JSON.stringify(layoutArray)
            },
            type: "POST",
            success: function(){
                $.unblockUI();
            }
        })
    }
    doSort();
    fixThumbnailMargins();
});