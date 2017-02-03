
$(function(){

    $(document).on('ready page:load', function() {
        if ($('#show-reply-checkbox').is(':checked')) {
            $('.retweet-content').show();
        } else {
            $('.retweet-content').hide();
        }
    });
   
    $('#show-reply-checkbox').on('change', function() {
        if ($(this).is(':checked') ) {
            $('.retweet-content').show();
            $.ajax ({
                url: '/user_configs',
                type: 'post',
                data: {
                    show_reply: 'true'
                    },
                datatype: 'html',
            });
        } else {
            $('.retweet-content').hide();
            $.ajax ({
                url: '/user_configs',
                type: 'post',
                data: {
                    show_reply: 'false'
                    },
            });
        }
    });
    
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
        var rc = $(this).next('.retweet-content');
        rc.slideToggle('fast');
        rc.find('.retweet-content').slideToggle('fast');
    });
    
    $('#new-tweet-form').on('ajax:complete', function(event, data, status) {
      if (status == 'success') {

          var json = JSON.parse(data.responseText);
          $('p.notice').empty();
          $('p.alert').empty();

          if (json.result=='success') {
              $('.tweet-container').prepend(json.html);
              $(this)[0].reset();
            } else if (json.result=='failure') {
              $('p.alert').empty();
              $('p.alert').append(json.error_message);
            }

      }
    });

});


