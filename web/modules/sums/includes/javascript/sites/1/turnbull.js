var $tabs2;
var targetAjax = "";
var hashHistory = {};
$(document).ready(function(){
  var targetAjax = "mainp";
  var originalContet =  $("#" + targetAjax).html();
  var oldBrowser = false;
  
  
  
  
  $(".dialog").live("click",function(e){
    var url = $(this).attr("href");
      $("#dialog").dialog({
        title: $(this).attr("name"),
        buttons: {}
      })
    $.ajax({
      url: url,
      datatype: "html",
      success: function(data) {
        $("#dialog").html(data);
        $("#dialog").dialog("open");        
      }
    })
    e.preventDefault();
    return false;
  })
  $(".modaldialog").live("click",function(e){
    var url = $(this).attr("href");
      $("#dialog").dialog({
        title: $(this).attr("name"),
        buttons: {
          "Save": function() { 
            //$(this).dialog("close");  
          }, 
          "Cancel": function() { 
            $(this).dialog("close"); 
          } 
        }
      })
    $.ajax({
      url: url,
      datatype: "html",
      success: function(data) {
        $("#dialog").html(data);
        $("#dialog").dialog("open");        
      }
    }) 
    e.preventDefault();
    return false;
  })
  
  $("a[href='#']").live("click",function(event) { 
     event.preventDefault();
  })
  $(".tooltip").tipsy({
    live: true,
    gravity: "se"

  });
  $(".show").live("click",function(event){
    $("#" + $(this).attr("rev")).toggle();
     event.preventDefault();
     return false;
  });
  $(".helptip").tipsy({
    live: true,
    gravity: "w",
    trigger: "focus"
  });
  $(".complexTip").tipsy({
    live: true,
    html: true,
    title: function(e) {
      $(e).find(".hidden").html()
    },
    gravity: "se"

  });
  if ($(".date").length != 0) {
    $(".date").datepicker({
      dateFormat: 'dd/mm/yy'
    });
  }
  $(".confirm").live("click",function(){
    var s = window.confirm("Are you sure?");
    if (s) {
      return true;
    } else {
      return false;
    }
  })
  $("#dialog").dialog( "option", "buttons",{
          "Create Element": function() {
              $("#elementForm").submit();          
              $(this).dialog("close"); 
           } 
         });
   
  
  var $tabs =  $("#tabs").tabs({
        cookie: {
         expires: 30,
         name: 'tabs'      
        },
        spinner: '<img hspace="10" src="/includes/images/spinner.gif" border="0" />',
        cache: true,
        ajaxOptions: {cache: false}
      });     
    /*

*/
  
  $('a.void').click(function(){
      return false;
  });
  
      
  
  

   
   $('#dialog').dialog({
    autoOpen: false,
    width: 700,
    height: 600,
    zIndex: 3999,
    buttons: {
      "Ok": function() { 
        //$(this).dialog("close");  
      }, 
      "Cancel": function() { 
        $(this).dialog("close"); 
      } 
    },

    modal: true
  });
  $(".tooltip").tipsy({
    live: true,
    gravity: "se"

  });
  $(".updateB").click(function(){
    $("#updateBasket").submit();
  }) 
   var accordion = $("#accordion");
  var index = $.cookie("accordion");
  var active;
  if (index !== null) {
          active = accordion.find("h3:eq(" + index + ")");
  } else {
          active = 0
  }
  
  accordion.accordion({
          header: "h3",
          autoHeight: false,
          active: active,
		  clearStyle: true,
          change: function(event, ui) {
                  var index = $(this).find("h3").index ( ui.newHeader[0] );
                  $.cookie("accordion", index, {
                          path: "/"
                  });
          }
  
  }); 
  $("#accordion").css("visibility","visible");
  $(".accordion").accordion({
          header: "h3",
          autoHeight: false,
          active: active,
          icons: false
      });
  $(".updateB").click(function() {
    $("#basketForm").submit();
  })
  $("#pT").change(function() {
    var v = $(this).val();
    if (v == "Switch") {
      $("#div_issueNumber").show();
      $("#div_startDate").show();
    } else {
      $("#div_issueNumber").hide();
      $("#div_startDate").hide();
    }
  })  
 });
function Left(str, n){
  if (n <= 0)
      return "";
  else if (n > String(str).length)
      return str;
  else
      return String(str).substring(0,n);
}


