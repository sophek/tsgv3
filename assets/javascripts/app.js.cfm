(function($, window, document, undefined) {
	'use strict';

	var $win = $(window);
	var $doc = $(document);

	$doc.ready(function() { 
    

//tabs
        
        $('ul.tabs li').click(function(){
		var tab_id = $(this).attr('data-tab');

		$('ul.tabs li').removeClass('current');
		$('.tab-content').removeClass('current');

		$(this).addClass('current');
		$("#"+tab_id).addClass('current');
	});
        
        $('ul.tabs li').hover(function(){
		var tab_id = $(this).attr('data-tab');

		$('ul.tabs li').removeClass('current');
		$('.tab-content').removeClass('current');

		$(this).addClass('current');
		$("#"+tab_id).addClass('current');
	});
        
        
    //Accordion
        

    //parent action guides
    
    $( "#schedule-a-workshop" ).click(function() {
        aboutpage("schedule-a-workshop.html");
        $("#headerTitle").text("Schedule A Workshop");
    });  
        
    $( "#parent-action-guides" ).click(function() {
        aboutpage("parent-action-guide.html");
        $("#headerTitle").text("Parent Action Guides");
    }); 
        
     $( "#about-the-project" ).click(function() {
         aboutpage("about-the-project.html");
         $("#headerTitle").text("About the Project");
    });     
        
      $( "#faq" ).click(function() {
         aboutpage("faq.html");
          $("#headerTitle").text("FAQ");
    });
        
    $( "#testimonials" ).click(function() {
         aboutpage("testimonials.html");
        $("#headerTitle").text("Testimonials");
    }); 
        
    $( "#contact-us" ).click(function() {
         aboutpage("contact-us.html");
        $("#headerTitle").text("Contact Us");
    }); 
        
    function aboutpage(myurl){
        $( "#main" ).load( myurl, function( response, status, xhr ) {
        if ( status == "error" ) {
            var msg = "Sorry but there was an error: ";
        $( "#error" ).html( msg + xhr.status + " " + xhr.statusText );
    }
    });
        
    }    
        
		// Foundation Init
		//$(document).foundation();
        
       $(document).foundation();

		// Fullscreener
		$('.fullscreener img').fullscreener();

		// Progressbar
		$('.progressbar-inner').each(function() {
			var width = $(this).data('progress');

			$(this).width(width + '%');
		});
        
        
//        $('.iframe').colorbox({iframe:true, width:'80%', height:'80%'});

		// Slider Intro
		$('.slider-intro .slides').owlCarousel({
			loop: true,
			autoplay: true,
			autoplayHoverPause : true,
			autoplayTimeout: 5000,
			smartSpeed: 500,
			nav: true,
			navContainer: '.slider-intro .slider-actions',
			navText: ['<i class="fa fa-chevron-left"></i>', '<i class="fa fa-chevron-right"></i>'],
			items: 1,
			margin: 0
		});

		// Slider Featured
		$('.slider-featured .slides').owlCarousel({
			loop: true,
			nav: true,
			navContainer: '.slider-featured .slider-actions',
			navText: ['<i class="fa fa-chevron-left"></i>', '<i class="fa fa-chevron-right"></i>'],
			items: 1,
			autoWidth: true,
			margin: 30,
			responsive: {
				320: {
					items: 1
				},
				768: {
					items: 2
				},
				1024: {
					items: 3
				},
				1200: {
					items: 4
				}
			}
		});

		// Slider Sponsor
		$('.slider-sponsor .slides').owlCarousel({
			loop: true,
			nav: true,
			smartSpeed: 500,
			navContainer: '.slider-sponsor .slider-actions',
			navText: ['<i class="fa fa-chevron-left"></i>', '<i class="fa fa-chevron-right"></i>'],
			items: 1
		});

        
        
		// Slider News
		$('.slider-news .slides').owlCarousel({
			loop: true,
			nav: true,
			navContainer: '.slider-news .slider-actions',
			navText: ['<i class="fa fa-chevron-left"></i>', '<i class="fa fa-chevron-right"></i>'],
			items: 1
		});

		// Slider Staff
		$('.slider-staff .slides').owlCarousel({
			loop: true,
			mouseDrag: false,
			touchDrag: false,
			nav: true,
			smartSpeed: 500,
			navContainer: '.slider-staff .slider-actions',
			navText: ['<i class="fa fa-chevron-left"></i>', '<i class="fa fa-chevron-right"></i>'],
			items: 1
		});

		// Slider Testimonials
		$('.slider-testimonials .slides').owlCarousel({
			loop: true,
			dots: true,
			autoplay: true,
			autoplayTimeout: 5000,
			smartSpeed: 500,
			items: 1
		});

		// Slider Widgets
		$('.slider-widget .slides').owlCarousel({
			loop: true,
			dots: true,
			smartSpeed: 500,
			items: 1,
			margin: 30,
		});

		// Post Format Gallery Slider
		$('.format-gallery .post-image ul').owlCarousel({
			loop: true,
			nav: true,
			smartSpeed: 500,
			navText: ['<i class="fa fa-chevron-left"></i>', '<i class="fa fa-chevron-right"></i>'],
			items: 1
		});

		// Mobile Navigation
		var $nav = $('.nav');

		$nav.find('li').each(function() {
			if ( $(this).children('ul').length ) {
				$(this).append('<span>+</span>')
			}
		});

		$nav.find('li > span').on('click', function(e) {
			e.preventDefault();
			
			$(this).text( $(this).text() == "+" ? "-" : "+");
			$(this).siblings('ul').slideToggle(300);
		});

		$('.button-burger').on('click', function (event) {
			$(this).toggleClass('active');  
			
			$nav.slideToggle(300);
			event.preventDefault();
		});


		// Custom Input Number
		$('input[type=number]').number();


	});

    

})(jQuery, window, document);
