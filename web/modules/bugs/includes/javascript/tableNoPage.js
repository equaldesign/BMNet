$(document).ready(function(){
  $('.dataTable').dataTable({
    "bPaginate": false,
    "bLengthChange": false,
    "sDom": "<'widget-header'<'pull-left padd5'l><'pull-right padd5'f>r><'widget-content't><'widget-footer'<'pull-left padd5'i><'pull-right padd5'p>>",
  });
})