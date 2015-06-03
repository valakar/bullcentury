/* go up button */
$(function () {
  // Only enable if the document has a long scroll bar
  // Note the window height + offset
  if ( ($('body').outerHeight() > $(window).height()) ) {
      $('#top-link-block').removeClass('hidden').affix({
          // how far to scroll down before link "slides" into view
          offset: {top:100}
      });
  }
});

$(document).ready(function() {
    $(window).scroll(function() {
        var windowpos = $(window).scrollTop() + $(window).height();
        var footerpos = 250 - ($(document).height() - ($(window).height() + $(window).scrollTop()));
    
        if (windowpos >= ($('.footer_background').offset().top))
        {
            $('#top-link-block').css('bottom', footerpos);
        } else
        {
            $("#top-link-block").css('bottom', '18px');
        }
    });
});