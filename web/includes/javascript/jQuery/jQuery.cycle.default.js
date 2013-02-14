var showcase = $('#showcase').cycle({ 
    fx:     'scrollVert',
    easing: 'easeOutBounce',
    speed:  800, 
    timeout: 8000, 
    pager:  '#showcasenav',
    after: onAfter,
    slideExpr: 'img'

});

function onAfter(tin,tout,opts) {
    var theslide = opts.currSlide+1;
    $('#showcaseurl').html('<a href="' + tout.name + '" target="_blank">' + tout.alt + '</a>');
    $('#scase').html('<h1>' + tout.title + '</h1>'); 
}