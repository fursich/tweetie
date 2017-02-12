
$(function(){

    var ua = navigator.userAgent;
    $('.retweet-header').on('mouseover',function() {
        if (ua.indexOf('iPhone') <= 0 && ua.indexOf('Mobile') <= 0) {
            if (ua.indexOf('iPad') <= 0 && ua.indexOf('Android') <= 0) {
                $(this).css('height','15px');
            }
        }
    });

    $('.retweet-header').on('mouseout',function() {
        if (ua.indexOf('iPhone') <= 0 && ua.indexOf('Mobile') <= 0) {
            if (ua.indexOf('iPad') <= 0 && ua.indexOf('Android') <= 0) {
                $(this).css('height','10px');
            }
        }
    });


    $('.retweet-header').click(function(){
        var rb = $(this).siblings('.retweet-body');
        rb.slideToggle('fast');
    });
    
    $('#new-tweet-form').on('ajax:complete', function(event, data, status) {
      if (status == 'success') {

          var json = JSON.parse(data.responseText);
          $('#notice').empty();
          $('#alert').empty();

          if (json.result=='success') {
              $('div.tweet-box').prepend(json.html);
              $(this)[0].reset();
              $('.reaction-buttons-container').hide();
            } else if (json.result=='failure') {
              $('#alert').empty();
              $('#alert').append(json.error_message);
            }

      }
    });

});


