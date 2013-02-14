$(document).ready(function(){
  var tab_cookie_id = parseInt($.cookie("the_tab_cookie")) || 0; 
  $("#productTabs").tabs("destroy").tabs({
    selected: tab_cookie_id,
    spinner: '<img hspace="10" src="/includes/images/spinner.gif" border="0" />',
    cache: true
  });
});   