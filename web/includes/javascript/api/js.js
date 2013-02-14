// Only do anything if jQuery isn't defined
if (typeof jQuery == 'undefined') {
  if (typeof $ == 'function') {
    // warning, global var
    thisPageUsingOtherJSLibrary = true;
  } 
  function getScript(url, success) {  
    var script     = document.createElement('script');
         script.src = url;    
    var head = document.getElementsByTagName('head')[0],
    done = false;    
    // Attach handlers for all browsers
    script.onload = script.onreadystatechange = function() {    
      if (!done && (!this.readyState || this.readyState == 'loaded' || this.readyState == 'complete')) {      
      done = true;        
        // callback function provided as param
        success();        
        script.onload = script.onreadystatechange = null;
        head.removeChild(script);        
      };    
    };    
    head.appendChild(script);  
  };  
  getScript('http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js', function() {  
    if (typeof jQuery=='undefined') {    
      // Super failsafe - still somehow failed...    
    } else {    
      doAPI();         
    }  
  });
  
} else { // jQuery was already loaded
	doAPI();
}
function getCookie(c_name) {
var i,x,y,ARRcookies=document.cookie.split(";");
for (i=0;i<ARRcookies.length;i++)
{
  x=ARRcookies[i].substr(0,ARRcookies[i].indexOf("="));
  y=ARRcookies[i].substr(ARRcookies[i].indexOf("=")+1);
  x=x.replace(/^\s+|\s+$/g,"");
  if (x==c_name)
    {
    return unescape(y);
    }
  }
}
function doAPI(){
	$(document).ready(function(){    
    
      var _gaq = _gaq || [];
      _gaq.push(['_setAccount', 'UA-866816-27']);
      _gaq.push(['_setDomainName', 'buildingvine.com']);
      _gaq.push(['_setAllowLinker', true]);
      _gaq.push(['_trackPageview']);
      
      (function(){
        var ga = document.createElement('script');
        ga.type = 'text/javascript';
        ga.async = true;
        ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
        var s = document.getElementsByTagName('script')[0];
        s.parentNode.insertBefore(ga, s);
      })();
      
      $("head").append("<link>");
      css = $("head").children(":last");
      css.attr({
        rel: "stylesheet",
        type: "text/css",
        href: "https://www.buildingvine.com/modules/bv/includes/style/jQuery/jqzoom.css"
      });
      $.getScript("https://www.buildingvine.com/includes/javascript/jQuery/jQuery.lightbox.js", function(){
        $("a.fancy").lightBox();
        $("head").append("<link>");
        css = $("head").children(":last");
        css.attr({
          rel: "stylesheet",
          type: "text/css",
          href: "https://www.buildingvine.com/modules/bv/includes/style/jQuery/lightbox/style.css"
        });
        $.getScript("https://www.buildingvine.com/includes/javascript/jQuery/jQuery.zoom.js", function(){
        
          $(".zoom").jqzoom({
            zoomWidth: 350,
            zoomHeight: 350,
            zoomType: 'reverse',
            xOffset: 10,
            yOffset: 0,
            position: "right"
          });
        })
      });
      $("head").append("<link>");
      css = $("head").children(":last");
      css.attr({
        rel: "stylesheet",
        type: "text/css",
        href: "https://www.buildingvine.com/modules/bv/includes/style/jQuery/jQuery.ratings.css"
      });
      $("head").append("<link>");
      css = $("head").children(":last");
      css.attr({
        rel: "stylesheet",
        type: "text/css",
        href: "https://www.buildingvine.com/modules/bv/includes/style/api/api.css"
      });
      $.getScript("https://www.buildingvine.com/includes/javascript/jQuery/jQuery.ratings.js", function(){
        doBV();
        })               
  });
  function doBV(){
    function addTab(name, id, content,pos){
      if (pos == "first") {
        $("#" + tabtarget).find(".nav-tabs").prepend('<li><a data-toggle="tab" href="#bv_' + id + '">' + name + '</a></li>').tab("show");
        $("#" + tabtarget).find(".tab-content").prepend('<div class="tab-pane" id="bv_' + id + '">' + content + '</div>');
        $("#" + tabtarget).find("ul a:last").tab('show');
        $("#" + tabtarget + " ul a:first").tab('show');
      } else {
        $("#" + tabtarget).find(".nav-tabs").append('<li><a data-toggle="tab" href="#bv_' + id + '">' + name + '</a></li>').tab("show");
        $("#" + tabtarget).find(".tab-content").append('<div class="tab-pane" id="bv_' + id + '">' + content + '</div>');
        $("#" + tabtarget).find("ul a:last").tab('show');
        $("#" + tabtarget + " ul a:first").tab('show'); 
      }    
    }
    var usetabs = (($("#bvinfo").attr("data-use-tabs") == undefined) ? "false" : $("#bvinfo").attr("data-use-tabs"));
    var tabtype = (($("#bvinfo").attr("data-tab-type") == undefined) ? "bootstrap" : $("#bvinfo").attr("data-tab-type"));
    var accordionType = (($("#bvinfo").attr("data-accordion-type") == undefined) ? "jQueryUI" : $("#bvinfo").attr("data-accordion-type"));
    var tabtarget = (($("#bvinfo").attr("data-tab-target") == undefined) ? "tabs" : $("#bvinfo").attr("data-tab-target"));
    var showdocuments = (($("#bvinfo").attr("data-showdocuments") == undefined) ? "false" : $("#bvinfo").attr("data-showdocuments"));
    var showData = (($("#bvinfo").attr("data-showdata") == undefined) ? "false" : $("#bvinfo").attr("data-showdata"));
    var dataString = (($("#bvinfo").attr("data-src") == undefined) ? "" : $("#bvinfo").attr("data-src"));
    var useAccordion = (($("#bvinfo").attr("data-use-accordion") == undefined) ? "false" : $("#bvinfo").attr("data-use-accordion"));
		var accordionCollapsible = (($("#bvinfo").attr("data-accordion-collapse") == undefined) ? false : $("#bvinfo").attr("data-accordion-collapse"));
		var accordionStart = (($("#bvinfo").attr("data-accordion-start") == undefined) ? 0 : $("#bvinfo").attr("data-accordion-start"));
    var accordionTarget = (($("#bvinfo").attr("data-accordion-target") == undefined) ? "accordion" : $("#bvinfo").attr("data-accordion-target"));
    var showSocialIcons = (($("#bvinfo").attr("data-social-icons") == undefined) ? "true" : $("#bvinfo").attr("data-social-icons"));
    var showVideo = (($("#bvinfo").attr("data-show-video") == undefined) ? "false" : $("#bvinfo").attr("data-show-video"));
    var socialNetworks = (($("#bvinfo").attr("data-social-networks") == undefined) ? "googlePlus,facebook,twitter,delicious,stumbleupon,linkedIn,pinterest" : $("#bvinfo").attr("data-social-networks"));
    if (dataString != "" && dataString != null && $("#bvinfo").is(":empty")) {
      try {
        var apiString = "https://www.buildingvine.com/api/getProductMeta?" + dataString;
        if ($("#bvdialog").length == 0) {
          $("body").append("<div id='bvdialog'></div>");
        }
        $.ajax({
          url: apiString,
          dataType: "jsonp",
          success: function(data){
            if (data.nodeRef != undefined && data.output.DETAIL != undefined) {
              var bvProductURL = "http://www.buildingvine.com/bv/products/productDetail?nodeRef=" + data.nodeRef;
              // do the easyrec logging
              $.ajax({
                url: "https://www.buildingvine.com/bv/api/viewItem?shortName=" + data.output.DETAIL.site + "&nodeRef=" + data.nodeRef + "&itemName= " + data.output.DETAIL.title + "&itemType=PRODUCT&returnType=jsonp",
                dataType: "jsonp" 
              });
              
              if (showdocuments == "true") {              
                $.ajax({
                  url: "http://www.buildingvine.com/bv/api/getAssociatedDocuments?nodeRef=" + data.nodeRef,
                  dataType: "jsonp",
                  success: function(data){
                    if (data.hasDocs) {
                      if (usetabs == "true") {
                        addTab("Documents", "bv_documents", data.docs, "last");
                      }
                      else 
                        if (useAccordion == "true") {
                          $("#" + accordionTarget).append('<h3><a href="#">Related Documents</a></h3><div>' + data.docs + '</div>').accordion('destroy').accordion({
                            autoHeight: false,
														collapsible: accordionCollapsible,
														active: accordionStart
                          });
                        }
                        else {
                          $("#bvinfo").append(data.docs);
                        }
                    }
                  }
                })
              }
              if (showVideo == "true") {
                var videos = [];
                for (i=0; i<data.output.DETAIL.links.length;i++) {
  
                  if (data.output.DETAIL.links[i].linkType == "youTube") {
                    videos.push(data.output.DETAIL.links[i]);
                  }
                }             
                for (v=0;v<videos.length;v++) {
                  var video = videos[v];                
                  if (useAccordion == "true") {
                    $("#" + accordionTarget).prepend('<h3><a href="#">' + video.linkName + ' Video</a></h3><div><div class="videoWrapper"><iframe width="99%" height="325" src="http://www.youtube.com/embed/' + video.linkAddress + '?theme=light&color=white&rel=0&showinfo=0" frameborder="0" allowfullscreen></iframe></div></div>').accordion('destroy').accordion({autoHeight: false,collapsible: accordionCollapsible, active: accordionStart});
                  } else if (usetabs == "true") {
                      addTab(video.linkName + " Video", "bv_videos",'<div class="videoWrapper"><iframe width="99%" height="325" src="http://www.youtube.com/embed/' + video.linkAddress + '?theme=light&color=white&rel=0&showinfo=0" frameborder="0" allowfullscreen></iframe></div>',"first");                  
                  } else {
                    $("#bvinfo").append('<div class="videoWrapper"><iframe width="99%" height="325" src="http://www.youtube.com/embed/' + video.linkAddress + '?theme=light&color=white&rel=0&showinfo=0" frameborder="0" allowfullscreen></iframe></div>');
                  }
                }
              }
              if (showData == "true") {
                
                var niceStruct = '<h2>Details</h2><table class="table table-striped table-condensed"><tr>' +
                '<td>Name</td>' +
                '<td>' +
                data.output.DETAIL.title +
                '</td>';
                if (data.output.DETAIL.attributes.unitweight != "" && data.output.DETAIL.attributes.unitweight != undefined) {
                  niceStruct += "<tr><td>Weight</td><td>" + data.output.DETAIL.attributes.unitweight + " Kg.</td></tr>";
                }             
                if (data.output.DETAIL.attributes.eancode != "" && data.output.DETAIL.attributes.eancode != undefined) {
                  niceStruct += "<tr><td>Barcode</td><td>" + data.output.DETAIL.attributes.eancode + "</td></tr>";
                }
                if (data.output.DETAIL.attributes.supplierproductcode != "" && data.output.DETAIL.attributes.supplierproductcode != undefined) {
                  niceStruct += "<tr><td>Product Code</td><td>" + data.output.DETAIL.attributes.supplierproductcode + "</td></tr>";
                }
                else {
                  if (data.output.DETAIL.attributes.manufacturerproductcode != "" && data.output.DETAIL.attributes.manufacturerproductcode != undefined) {
                    niceStruct += "<tr><td>Product Code</td><td>" + data.output.DETAIL.attributes.manufacturerproductcode + "</td></tr>";
                  }
                }
                try {
                  for (var key in data.output.DETAIL.attributes.customProperties) {
                    niceStruct += "<tr><td>" + key + "</td><td>" + data.output.DETAIL.attributes.customProperties[key] + "</td></tr>";
                  }
                } catch (a) {
                  // something went wrong here...
                }
                niceStruct += '</table>';
                if (usetabs == "true") {
                  addTab("Specifications", "specs", niceStruct,"last");
                  $("#bvinfo").prepend("<span></span>");
                } else if (useAccordion == "true") {
                  $("#" + accordionTarget).append('<h3><a href="#">Specifications</a></h3><div>' + niceStruct + '</div>').accordion('destroy').accordion({autoHeight: false,collapsible: accordionCollapsible,active: accordionStart});
                } else {
                  $("#bvinfo").prepend(niceStruct);
                }
              }
              if (showSocialIcons == "true") {
                // we should now have a nodeRef, which we can use for likes, and shares.
                $("head").append("<link>");
                css = $("head").children(":last");
                css.attr({
                  rel: "stylesheet",
                  type: "text/css",
                  href: "https://www.buildingvine.com/modules/bv/includes/style/api/sharrre.css"
                });
                $.getScript("https://www.buildingvine.com/includes/javascript/jQuery/jQuery.sharrre.js", function(){
                  if (usetabs == "true") {
                    addTab("Social", "social", '<div id="shareme" data-url="' + bvProductURL + '" data-title="share"></div>', "last");                  
                  } else if (useAccordion == "true") {
										$("#" + accordionTarget).append('<h3><a href="#">Social Reactions</a></h3><div><div id="shareme" data-url="' + bvProductURL + '" data-title="share"></div></div>').accordion('destroy').accordion({autoHeight: false,collapsible: accordionCollapsible,active: accordionStart});
									}	else {
                    $("#bvinfo").prepend('<div id="shareme" data-url="' + bvProductURL + '" data-title="share"></div>');
                  }
                  var socialObject = {};
									socialObject.share = {}
									socialObject.buttons = {};
									socialObject.enableHover = false;
                  socialObject.enableCounter = false;
                  socialObject.enableTracking = true;
									var socialNetworksArray = socialNetworks.split(",");
									if (socialNetworksArray.indexOf("googlePlus") != -1) {
										socialObject.share.googlePlus = true;
										socialObject.buttons.googlePlus = {size: 'tall'};
									}
									if (socialNetworksArray.indexOf("facebook") != -1) {
                    socialObject.share.facebook = true;
                    socialObject.buttons.facebook = {layout: 'box_count'};
                  }
									if (socialNetworksArray.indexOf("twitter") != -1) {
                    socialObject.share.twitter = true;
                    socialObject.buttons.twitter = {count: 'vertical'};
                  }
									if (socialNetworksArray.indexOf("delicious") != -1) {
                    socialObject.share.delicious = true;
                    socialObject.buttons.delicious = {size: 'tall'};
                  }
									if (socialNetworksArray.indexOf("stumbleupon") != -1) {
                    socialObject.share.stumbleupon = true;
                    socialObject.buttons.stumbleupon = {layout: '5'};
                  }
									if (socialNetworksArray.indexOf("linkedIn") != -1) {
                    socialObject.share.linkedin = true;
                    socialObject.buttons.linkedin = {counter: 'top'};
                  }
									if (socialNetworksArray.indexOf("pinterest") != -1) {
                    socialObject.share.pinterest = true;
                    socialObject.buttons.pinterest = {layout: 'vertical'};
                  }	
									
                  $('#shareme').sharrre(socialObject);
                })
              }
            }
          }
        })
    
      } 
      catch (e) {
        // do something here?
        console.log("oops")
      }
    }
  }
      
  function Left(str, n){
    if (n <= 0)
        return "";
    else if (n > String(str).length)
        return str;
    else
        return String(str).substring(0,n);
  }
  function isSecure()
  {
     return window.location.protocol == 'https:';
  }
    
    // Run your jQuery Code
}  
if (!Array.prototype.indexOf)
  {

       Array.prototype.indexOf = function(searchElement /*, fromIndex */)

    {


    "use strict";

    if (this === void 0 || this === null)
      throw new TypeError();

    var t = Object(this);
    var len = t.length >>> 0;
    if (len === 0)
      return -1;

    var n = 0;
    if (arguments.length > 0)
    {
      n = Number(arguments[1]);
      if (n !== n)
        n = 0;
      else if (n !== 0 && n !== (1 / 0) && n !== -(1 / 0))
        n = (n > 0 || -1) * Math.floor(Math.abs(n));
    }

    if (n >= len)
      return -1;

    var k = n >= 0
          ? n
          : Math.max(len - Math.abs(n), 0);

    for (; k < len; k++)
    {
      if (k in t && t[k] === searchElement)
        return k;
    }
    return -1;
  };

}