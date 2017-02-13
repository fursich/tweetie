
$(function(){

    $('a.navbar-brand.header-logo-box').on('mouseenter', function(){
        $(this).children('img.header-logo').attr('src',"/images/tweetie_logo_anime2.png");
    });
    $('a.navbar-brand.header-logo-box').on('mouseleave', function(){
        $(this).children('img.header-logo').attr('src',"/images/tweetie_logo_final.png");
    });

})

