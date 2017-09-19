

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

