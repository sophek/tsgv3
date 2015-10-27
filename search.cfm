<style>
		.container{
			width: 600px;
			margin: 0 auto;
		}



		ul.tabs{
			margin: 0px;
			padding: 0px;
			list-style: none;
		}
		ul.tabs li{
			background: none;
			color: #222;
			display: inline-block;
			padding: 10px 15px;
			cursor: pointer;
		}

		ul.tabs li.current{
			background: #ededed;
			color: #222;
		}

		.tab-content{
			display: none;
			background: #ededed;
			padding: 15px;
		}

		.tab-content.current{
			display: inherit;
		}
</style>

<div class="container">

	<ul class="tabs">
		<li class="tab-link current" data-tab="tab-1">School</li>
		<li class="tab-link" data-tab="tab-2">District</li>
		<li class="tab-link" data-tab="tab-3">Grade</li>
		<li class="tab-link" data-tab="tab-4">School Level</li>
        <li class="tab-link" data-tab="tab-4">Address</li>
        <li class="tab-link" data-tab="tab-4">Zip code</li>
	</ul>

	<div id="tab-1" class="tab-content current">
		<div class="subscribe">
								<form action="demo.cfm" method="post">
									<input type="submit" value="Go" class="subscribe-btn">
									
									<div class="subscribe-inner">
										<input type="email" id="mail" name="mail" value="" placeholder="Email Address" class="subscribe-field">
									</div><!-- /.subscribe-inner -->
								</form>
							</div>
	</div>
	<div id="tab-2" class="tab-content">
		 <div class="subscribe">
								<form id="myForm" class="form" action="demo.cfm" method="post">
									<input type="submit" value="Search" class="subscribe-btn" id="submitDistrict">
									
									<div class="subscribe-inner">
										<input type="text" id="district" name="district" value="" placeholder="District" class="subscribe-field">
									</div><!-- /.subscribe-inner -->
								</form>
							</div>
	</div>
	<div id="tab-3" class="tab-content">
		Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.
	</div>
	<div id="tab-4" class="tab-content">
		Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
	</div>
    <div>
    <cfinclude template="map.cfm" />
    </div>
</div>
<!-- container -->




<script>
$(document).ready(function(){
	
	$('ul.tabs li').click(function(){
		var tab_id = $(this).attr('data-tab');

		$('ul.tabs li').removeClass('current');
		$('.tab-content').removeClass('current');

		$(this).addClass('current');
		$("#"+tab_id).addClass('current');
	});
})
</script>
