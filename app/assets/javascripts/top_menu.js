$(function() {
	$('.collapse').on('shown.bs.collapse', function(){
	$(this).parent().find(".glyphicon-chevron-left").removeClass("glyphicon-chevron-left").addClass("glyphicon-chevron-down");
	}).on('hidden.bs.collapse', function(){
	$(this).parent().find(".glyphicon-chevron-down").removeClass("glyphicon-chevron-down").addClass("glyphicon-chevron-left");
	});
})

$(function() {

	var active = true;

    $('#accordion').on('mouseenter.collapse.data-api', '[data-toggle=hovercollapse]', function(e) {
        var $this = $(this),
            href, target = $this.attr('data-target') || e.preventDefault() || (href = $this.attr('href')) && href.replace(/.*(?=#[^\s]+$)/, '') //strip for ie7
            ,
            option = $(target).data('collapse') ? $this.data(): 'show' 
            $(target).collapse(option)
    })
	$('#accordion.panel').on('mouseleave.collapse.data-api', '[data-toggle=hovercollapse]', function(e) {
        var $this = $(this),
            href, target = $this.attr('data-target') || e.preventDefault() || (href = $this.attr('href')) && href.replace(/.*(?=#[^\s]+$)/, '') //strip for ie7
            ,
            option = $(target).data('hide') ? $this.data() : 'hide'
            $(target).collapse(option)

    }) 
	    $('#accordion').on('show.bs.collapse', function () {
	    if (active) $('#accordion .in').collapse('hide');
	});
	$('html').click(function() {
		if (active) $('#accordion .in').collapse('hide');
	});
})