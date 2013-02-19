$(function(){
  $('#attachments a.lightbox').lightBox({fixedNavigation:true});
  $("#addattachment").uploadify({
    swf: '/includes/javascript/jQuery/jQuery.uploadify/uploadify.swf',
    uploader: '/bugs/bugs/attach',
    method: 'POST', 
    postData: {
      'ticket' : $("#aholder").attr("data-bugID")
    },
    auto: true,
    multi: true,   
    uploaderType: "flash",
    wmode: 'transparent',     
    checkExisting: false,
    buttonText: "Add attachment",    
    width: 100,
    cancelImage: '/modules/bv/includes/images/secure/documents/cross-circle-frame.png',
    height: 16, 
    queueID: 'uploadQueue',           
    onQueueComplete: function() {
      var nodeRef = $("#nodeRef").val();
      document.location.href="/bugs/bugs/detail?ticket=" + $("#aholder").attr("data-bugID")         
    }
  }); 
   
})
