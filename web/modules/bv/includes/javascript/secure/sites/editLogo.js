var jcrop_large;
var jcrop_thumbnail;
var jcrop_transparent;
$(document).ready(function(){
	
	$("#saveLarge").click(function(){
		if (parseInt($('#large_w').val())) {
      $.ajax({
        url: "/site/crop",
        type: "POST",
        data: {
          "size": "large",
          "site": $(this).attr("rel"),
          "x": $('#large_x').val(),
          "y":$('#large_y').val(),
          "w": $('#large_w').val(),
          "h": $('#large_h').val(),
        },
        success: function(data){
          $("#largeLogo").attr("src","/includes/images/companies/" + $("#largeLogo").attr("rel") + "/large.jpg?" + guidGenerator());					
        }
      })
	  }	else {
		  alert('Please select a crop region then press save.');
		  return false;
	  }
	});
	$("#saveThumb").click(function(){
    if (parseInt($('#thumb_w').val())) {
      $.ajax({
				url: "/site/crop",
				type: "POST",
				data: {
					"size": "thumb",
					"site": $(this).attr("rel"),
					"x": $('#thumb_x').val(),
					"y":$('#thumb_y').val(),
					"w": $('#thumb_w').val(),
					"h": $('#thumb_h').val(),
				},
				success: function(data){
					$("#largeLogo").attr("src","/includes/images/companies/" + $("#largeLogo").attr("rel") + "/small.jpg?" + guidGenerator());
				}
			})
    } else {
      alert('Please select a crop region then press save.');
      return false;
    }
  });
	$("#saveTransparent").click(function(){
    if (parseInt($('#transparent_w').val())) {
      $.ajax({
        url: "/site/crop",
        type: "POST",
        data: {
          "size": "transparent",
          "site": $(this).attr("rel"),
          "x": $('#transparent_x').val(),
          "y":$('#transparent_y').val(),
          "w": $('#transparent_w').val(),
          "h": $('#transparent_h').val(),
        },
        success: function(data){
          $("#largeLogo").attr("src","/includes/images/companies/" + $("#largeLogo").attr("rel") + ".png?" + guidGenerator());
        }
      })
    } else {
      alert('Please select a crop region then press save.');
      return false;
    }
  });
	$("#largeLogo").Jcrop({
		onSelect: updateLarge
	},function(){
    jcrop_large = this;
  });
	$("#thumbnail").Jcrop({
		minSize: [46,46],
		aspectRatio:1,
		onSelect: updateThumb
	},function(){
    jcrop_thumbnail = this;
  });
	$("#transparent").Jcrop({
		onSelect: updateTransparent
	},function(){
    jcrop_transparent = this;
  });
	function updateThumb(c) {
    $('#thumb_x').val(c.x);
    $('#thumb_y').val(c.y);
    $('#thumb_w').val(c.w);
    $('#thumb_h').val(c.h);
  };
	function updateLarge(c) {
    $('#large_x').val(c.x);
    $('#large_y').val(c.y);
    $('#large_w').val(c.w);
    $('#large_h').val(c.h);
  };
	function updateTransparent(c) {
    $('#transparent_x').val(c.x);
    $('#transparent_y').val(c.y);
    $('#transparent_w').val(c.w);
    $('#transparent_h').val(c.h);
  };
	 
	$("#largeUpload").uploadify({
		swf: '/includes/javascript/jQuery/jQuery.uploadify/uploadify.swf',
    uploader: '/site/uploadLogo?size=large&siteID=' + $("#largeLogo").attr("rel"),
    method: 'POST',     
    auto: true,
    multi: false,   
    uploaderType: "flash",
    wmode: 'transparent',     
    checkExisting: false,
    buttonText: "Upload File",    
    width: 100,
    cancelImage: '/includes/images/secure/documents/cross-circle-frame.png',
    height: 16,
    queueID: 'largeQueue',           
    onQueueComplete: function(data) {
			$("#largeLogo").attr("src","/includes/images/companies/" + $("#largeLogo").attr("rel") + "/temp.jpg?" + guidGenerator());
			if (jcrop_large != undefined) {
			 jcrop_large.destroy()	
			}			
			$("#largeLogo").Jcrop({
				onSelect: updateLarge
			},function(){
		    jcrop_large = this;
		  });		
      console.log(data); 
    }
	})
	$("#thumbnailUpload").uploadify({
    swf: '/includes/javascript/jQuery/jQuery.uploadify/uploadify.swf',
    uploader: '/site/uploadLogo?size=thumb&siteID=' + $("#thumbnail").attr("rel"),
    method: 'POST',     
    auto: true,
    multi: false,   
    uploaderType: "flash",
    wmode: 'transparent',     
    checkExisting: false,
    buttonText: "Upload File",    
    width: 100,
    cancelImage: '/includes/images/secure/documents/cross-circle-frame.png',
    height: 16,
    queueID: 'thumbQueue',           
    onQueueComplete: function(data) {
      $("#thumbnail").attr("src","/includes/images/companies/" + $("#thumbnail").attr("rel") + "/temp_thumb.jpg?" + guidGenerator());
      if (jcrop_thumbnail != undefined) {
	  	  jcrop_thumbnail.destroy()
	    }
      $("#thumbnail").Jcrop({
				onSelect: updateThumb,
				minSize: [46,46],
        aspectRatio:1
			},function(){
        jcrop_thumbnail = this;
      });   
      console.log(data); 
    }
  })
	$("#transparentUpload").uploadify({
    swf: '/includes/javascript/jQuery/jQuery.uploadify/uploadify.swf',
    uploader: '/site/uploadLogo?size=transparent&siteID=' + $("#transparent").attr("rel"),
    method: 'POST',     
    auto: true,
    multi: false,   
    uploaderType: "flash",
    wmode: 'transparent',     
    checkExisting: false,
    buttonText: "Upload File",    
    width: 100,
    cancelImage: '/includes/images/secure/documents/cross-circle-frame.png',
    height: 16,
    queueID: 'transparentQueue',           
    onQueueComplete: function(data) {
      $("#transparent").attr("src","/includes/images/companies/" + $("#transparent").attr("rel") + "/temp.png?" + guidGenerator());
      if (jcrop_transparent != undefined) {
	  	  jcrop_transparent.destroy()
	    }
      $("#transparent").Jcrop({
				onSelect: updateTransparent
			},function(){
        jcrop_transparent = this;
      });   
      console.log(data); 
    }
  })
})
function guidGenerator() {
    var S4 = function() {
       return (((1+Math.random())*0x10000)|0).toString(16).substring(1);
    };
    return (S4()+S4()+"-"+S4()+"-"+S4()+"-"+S4()+"-"+S4()+S4()+S4());
}