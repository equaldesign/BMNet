$(document).ready(function(){
  
  var alf_ticket = $("#alf_ticket").val();
  $("#uploadFile").uploadify({
    swf: '/includes/javascript/jQuery/jQuery.uploadify/uploadify.swf',
    uploader: '/alfresco/service/api/upload?alf_ticket=' + alf_ticket,
    method: 'POST', 
    postData: {
      'destination' : $("#nodeRef").val()
    },
    auto: true,
    multi: true,   
    uploaderType: "flash",
    wmode: 'transparent',     
		checkExisting: false,
    buttonText: "Upload File",    
    width: 100,
    cancelImage: '/includes/images/secure/documents/cross-circle-frame.png',
    height: 16,
    queueID: 'uploadQueue',           
    onQueueComplete: function() {
      var nodeRef = $("#nodeRef").val();
      document.location.href="/bv/documents/index?dir=" + nodeRef         
    }
  });
  $("#upnv").uploadify({
    swf: '/includes/javascript/jQuery/jQuery.uploadify/uploadify.swf',
    uploader: '/alfresco/service/api/upload?alf_ticket=' + alf_ticket,
    method: 'POST',
    postData: {
      'updatenoderef' : $("#nodeRef").val(),
      'overwrite': true
    },
    auto: true,
    multi: true,   
    buttonText: "",
    wmode: 'transparent',         
    width: 150,
    uploaderType: "flash",
    cancelImage: '/includes/images/secure/documents/cross-circle-frame.png',
    height: 16,
    queueID: 'uploadQueue',           
    onQueueComplete: function() {
      var nodeRef = $("#nodeRef").val();
      document.location.href="/bv/documents/index?dir=" + nodeRef         
    }
  });
});
