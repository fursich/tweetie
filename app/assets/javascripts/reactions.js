
$(function(){

    $('.reaction-buttons-container').hide();
    $(document).on('mouseenter', '.index div.per-tweet', function(){
        $(this).find('.reaction-buttons-container').slideDown('fast');
    });
    $(document).on('mouseleave', '.index div.per-tweet', function(){
        $(this).find('.reaction-buttons-container').slideUp('fast');
    });


    $(document).on('ajax:complete', '.emotion-icon', function(event, data, status){
        
        if (status=='success') {
            var jsonData = JSON.parse(data.responseText);

            if (jsonData.result=='success') {

                $(this).siblings('.selected').each(function() {
                    $(this).removeClass('selected');
                    $(this).addClass('not-selected');
                });

                if ( jsonData.has_emotion == true) {
                    $(this).removeClass('not-selected');
                    $(this).addClass('selected');
                } else {
                    $(this).removeClass('selected');
                    $(this).addClass('not-selected');
                }

                var ctr = $(this).closest('.user-tweet').find('.reaction-counter-container');
                ctr.empty();
                if (jsonData.html != false) {
                    ctr.html(jsonData.html);
                }


            }
        }
    });
});
