var host = '';
var timeOut;
var period = 10000;
var state = 1;
$(document).ready(function(){     
    Shadowbox.init();
       
    $(".action_link").click(function(){
        $("#answer"+this.id).slideToggle("slow");
        $(this).toggleClass("active");
    });


    $(".nav .btn").click(function(){
        id = $(this).attr('data-id');
        $(".slides .item:visible").fadeOut();
        $(".slides #slide"+id).fadeIn();
    });
    $(".slider-wrapper .left").click(function(){
        curr = $('.slides').find('.item:visible');
        curr.fadeOut();
        if(curr.prev().length)curr.prev().fadeIn();
        else $('.slides').find('.item:last').fadeIn();    
    });
    $(".slider-wrapper .right").click(function(){
        curr = $('.slides').find('.item:visible');
        curr.fadeOut();
        if(curr.next().length)curr.next().fadeIn();
        else $('.slides').find('.item:first').fadeIn();
    });
    $(".slides .item:first").fadeIn();
});

$(window).blur(function(){state = 0;});
$(window).focus(function(){state = 1;});


function autoAdvance()
{
    if(state == 1)
    {
        curr = $('.slides').find('.item:visible');
        curr.fadeOut();
        if(curr.next().length)curr.next().fadeIn();
        else $('.slides').find('.item:first').fadeIn();
    }                                                 
}

function autoChange()
{
    if(state == 1)
    {
        if($('.slider-container').find('.active') && $('.slider-container').find('.active').next().length == 1 )$('.slider-container').find('.active').next().click();
        else $('.slider-container').find('.item:first').click();
    }
}

function UnHide(eThis, realm ){
    var f = false;
    $("#"+realm).slideToggle('fast');
    $("#"+realm).toggleClass('cl');
    if( $("#"+realm).hasClass('cl') ){
        eThis.innerHTML = '<img src="/i/bullet.png"/>';
    }else{
        eThis.innerHTML = '<img src="/i/bullet-down.png"/>';
    }
    return f;
}
function UnHidel(eThis, realm){
    var f = false;
    $("#"+realm).slideToggle('fast');
    $("#"+realm).toggleClass('cl');
    if( $("#"+realm).hasClass('cl') ){
        $(eThis).parent().prev().html('<img src="/i/bullet.png"/>');
    }else{
        $(eThis).parent().prev().html('<img src="/i/bullet-down.png"/>');
    }
    return f;
}
function array2json(arr) {
    var parts = [];
    var is_list = (Object.prototype.toString.apply(arr) === '[object Array]');

    for(var key in arr) {
    	var value = arr[key];
        if(typeof value == "object") { //Custom handling for arrays
            if(is_list) parts.push(array2json(value));
            else parts[key] = array2json(value);
        } else {
            var str = "";
            if(!is_list) str = '"' + key + '":';

            //Custom handling for multiple data types
            if(typeof value == "number") str += value; //Numbers
            else if(value === false) str += 'false'; //The booleans
            else if(value === true) str += 'true';
            else str += '"' + value + '"'; //All other things
            // :TODO: Is there any more datatype we should be in the lookout for? (Functions?)

            parts.push(str);
        }
    }
    var json = parts.join(",");

    if(is_list) return '[' + json + ']';//Return numerical JSON
    return '{' + json + '}';//Return associative JSON
}

function is_array(input){return typeof(input)=='object'&&(input instanceof Array);}    

function my_hide(parent) {
    $("[id^='art_vis']").css("display", "none");
    $("#art_vis_"+parent).css("display", "block");
    $("[id^='tart_vis']").css("display", "none");
    $("#tart_vis_"+parent).css("display", "block");
} 

                                                                    