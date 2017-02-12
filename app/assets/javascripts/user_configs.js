
$(function(){

    $('#option-show-followers-only .tab-all a').click(function (e) {
        e.preventDefault()
        $(this).tab('show')

        var uf = $('.per-tweet.per-others.not-followed');
        uf.next('.retweet-content').children('.retweet-box').children('.retweet-header').show();
        uf.show();

        $.ajax ({
            url: '/user_configs',
            type: 'post',
            data: {
                user_config: {
                    show_followers_only: 'false'
                }
            },
            datatype: 'html',
        });

    })
    $('#option-show-followers-only .tab-followers-only a').click(function (e) {
        e.preventDefault()
        $(this).tab('show')

        var uf = $('.per-tweet.per-others.not-followed');
        uf.next('.retweet-content').children('.retweet-box').children('.retweet-header').hide();
        uf.hide();

        $.ajax ({
            url: '/user_configs',
            type: 'post',
            data: {
                user_config: {
                    show_followers_only: 'true'
                }
            },
            datatype: 'html',
        });
    })


    $(document).ready(function() {
        if ($('#show-replies-checkbox').is(':checked')) {
            $('div.retweet-body').show();
        } else {
            $('div.retweet-body').hide();
        }

        if ($('#option-show-followers-only .tab-followers-only').hasClass('active')) {
            var uf = $('.per-tweet.per-others.not-followed');
            uf.next('.retweet-content').children('.retweet-box').children('.retweet-header').hide();
            uf.hide();
        }

    });

    $('#show-replies-checkbox').on('change', function() {
        if ($(this).is(':checked') ) {
            $('.retweet-body').show();
            $.ajax ({
                url: '/user_configs',
                type: 'post',
                data: {
                    user_config: {
                        show_replies: 'true'
                    }
                },
                datatype: 'html',
            });
        } else {
            $('.retweet-body').slideUp();
            $.ajax ({
                url: '/user_configs',
                type: 'post',
                data: {
                    user_config: {
                        show_replies: 'false'
                    }
                },
            });
        }
    });
})

