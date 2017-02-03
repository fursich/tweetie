
$(function(){

    $('.emotion-icon').on('ajax:complete', function(event, data, status){
        
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

            }
        }
    });
});
