(function($) { 
    var defaults = { 
        speed:'fast',
        multiplier:'9',
        maxwidth:'300' 
    };
    // актуальные настройки, глобальные
    var options; 
    $.fn.dmenu = function(params){
        options = $.extend({}, defaults, options, params);
        
        $.each($(this).children(".item"), function()
        {
            w = $(this).children(".label").outerWidth();      
            max = 0;
            $(this).find(".wrapper .item").each(function(){
                l = $(this).children("a").html().length;
                if(l > max) max = l;
            });
            iwidth = max*options['multiplier'];
            if(iwidth < w) iwidth = w;
            if(iwidth > options['maxwidth'])iwidth = options['maxwidth'];
            $(this).find(".wrapper").width(iwidth);
            
            $(this).mouseover(function(e){
                if($(this).children(".wrapper").is(":visible") == false)
                {
                    $(this).zIndex(100);
                    $(this).children(".wrapper").fadeIn(options['speed']);
                }
            });
            $(this).mouseleave(function(e){
                if($(this).children(".wrapper").is(":visible") == true)
                {   
                    $(this).zIndex(0);
                    $(this).children(".wrapper").fadeOut(options['speed']);
                }
            });    
        });
    };
})(jQuery);