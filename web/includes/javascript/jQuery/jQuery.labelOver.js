jQuery.fn.labelOver = function(overClass) {
	return this.each(function(){
	 	var label = jQuery(this);
		var f = label.attr('for');
			jQuery(this).click(function(){
					jQuery(label).hide();
					jQuery('#' + f).focus();
			})
			jQuery('#' + f).focus(function() {
				jQuery(label).hide();
			})
			jQuery('#' + f).blur(function() {
				if (jQuery('#' + f).val() == "") {
					jQuery(label).show();	
				}			
			})
  })
}
