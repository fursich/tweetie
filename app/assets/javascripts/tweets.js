
$(function(){
   
    $('.retweet-content').hide();

    $('.retweet-header').click(function(){
        var rc = $(this).next('.retweet-content');
        rc.slideToggle('fast');
        rc.find('.retweet-content').slideToggle('fast');
    });
    
    $('#new-tweet-form').on('ajax:complete', function(event, data, status) {
      if (status == 'success') {
          var json = JSON.parse(data.responseText);
          $('.tweet-container').prepend(json.html);
          $(this)[0].reset();
      }  
    });

});


