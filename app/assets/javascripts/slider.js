(function () {
	$(function() {
	  $(".projects-carousel").each(function (i, element) {
	    $(element).jCarouselLite({
	      btnNext: $('.next', element)[0],
	      btnPrev: $('.prev', element)[0],
	      visible: 3,
	      start: 0,
	      circular: false
	    });
	  });
	});
})()
