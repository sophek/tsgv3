(function($, window, document, undefined) {
	'use strict';

	var $win = $(window);
	var $doc = $(document);

	$doc.ready(function() { 
    
        
        
 function getUrlVars()
{
    var vars = [], hash;
    var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
    for(var i = 0; i < hashes.length; i++)
    {
        hash = hashes[i].split('=');
        vars.push(hash[0]);
        vars[hash[0]] = hash[1];
    }
    return vars;
}

        
        console.log(getUrlVars()["title"]);
      
        //
        
        loadPageBasedonTitle(getUrlVars()["title"]);
        
        function loadPageBasedonTitle(title){
            $("#headerTitle").text(headerTitle(title));
            var localTitle = title + ".html";
            aboutpage(localTitle);
        }
        
        
        function headerTitle(myUrl){
        var title = "";
        var headerImg = "assets/images/temp/main-image-1.jpg";
    switch (myUrl) {
    case "2015-texas-school-ranking":
        title = "2015 Texas School Ranking";
        headerImg = "assets/images/temp/main-image-2.jpg";   
            
        break;
    case "about-the-project":
        title = "About this project";
        headerImg = "assets/images/temp/main-image-1.jpg";   
        break;
    case "parent-action-guides":
        title = "Parent action guides";
        break;
    case "schedule-a-workshop":
        title = "Schedule a workshop";
        break;
    case "faq":
        title = "FAQ";
        break;
    case "testimonials":
        title = "Testimonials";
        break;
    case "contact-us":
        title = "Contact Us";
        break;
    case 7:
        title = "Saturday";
        break;        
}
            
            $('#headerimg').attr('src',headerImg);
           // alert(headerImg);
            return title;
            
        }
        
        
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
        aboutpage("parent-action-guides.html");
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
        
    $( "#resources" ).click(function() {
         aboutpage("resources.html");
        $("#headerTitle").text("Resources");
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
			autoplayTimeout: 9000,
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
