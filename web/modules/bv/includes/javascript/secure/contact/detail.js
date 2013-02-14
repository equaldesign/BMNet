$(document).ready(function(){
   $("#tabs").tabs('destroy').tabs({
        cookie: {
         expires: 30      
        },
        spinner: '<img hspace="10" src="/includes/images/secure/spinner.gif" border="0" />',
        cache: true,
        ajaxOptions: {cache: false}
      }); 
})
