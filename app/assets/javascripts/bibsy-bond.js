// $(function() {
//     $('#jennifer_button').click(function() {
//     	alert("alert")
//     	$('#jennifer_button').load('/jennifer');
// });

// $( "#jennifer_button" ).click(function() {
//   // alert( "Handler for .click() called." );
//   $('#jennifer_button').load('/jennifer');
// });
// $(document).ready(
// 	function() {
// 	  setInterval(function() {
// 	    $('#jennifer_button').load('/jennifer');
// 	}, 3000);
// });

// $('#jennifer_button').load('/dashboard_controller/jennifer'); // May need to use whatever locals you need to in here.

// $("#jennifer_button").html("<%= escape_javascript(render partial: 'shared/jennifer') %>");

// function jennifer() {
// 	$('#jennifer_button').load('/jennifer');
// }

$(document).ready(function() {
  $.simpleWeather({
    location: '11231',
    woeid: '',
    unit: 'c',
    success: function(weather) {
      html = '<span class="count_top">'+weather.city+', '+weather.region+'</span>'
      html += '<div class="count"><i class="icon-'+weather.code+' weather-icon"></i> '+weather.temp+'&deg;'+weather.units.temp+'</div>';
      html += '<span class="count_bottom">'+weather.currently+'</span>'
  
      $("#weather").html(html);
    },
    error: function(error) {
      $("#weather").html('<p>'+error+'</p>');
    }
  });
});