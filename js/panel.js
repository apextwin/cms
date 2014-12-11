var marker = null;
$(document).ready(function(){
    ///// ФИКС ПРОБЛЕМЫ НЕАКТИВНЫХ ИНПУТОВ В ДИАЛОГАХ ПРИ ИСПОЛЬЗОВАНИИ BOOTSTRAP
    $.fn.modal.Constructor.prototype.enforceFocus = function () {
        modal_this = this
        $(document).on('focusin.modal', function (e) {
            if (modal_this.$element[0] !== e.target && !modal_this.$element.has(e.target).length
            // add whatever conditions you need here:
            &&
            !$(e.target.parentNode).hasClass('cke_dialog_ui_input_select') && !$(e.target.parentNode).hasClass('cke_dialog_ui_input_text')) {
                modal_this.$element.focus()
            }
        })
    };
    //////////////////////////////////////////////////////////////////////////////
    $("#hide").click(function(){
            $("#realms").slideToggle("fast");
            $(this).toggleClass("active");
    });
   
    $(".openModal").click(function(){
        url = $(this).attr('href'); 
        surl = url + "&modal=true";
        if($(this).attr('modal-title') !== undefined)text = $(this).attr('modal-title');
        else text = $(this).html();
        var state = {id: gettime(), title: text, url: url}
        // заносим ссылку в историю
        history.pushState( state, state.title, state.url );

        $.get( surl, function( data ) {
            $(".modal-title").html(text);
            $(".modal-body").html(data);
            $("#myModal").modal('show');
        });
        return false;
    });
    $(".openModal-lg").click(function(){
        url = $(this).attr('href');
        surl = url + "&modal=true"; 
        if($(this).attr('modal-title') !== undefined)text = $(this).attr('modal-title');
        else text = $(this).html();
        var state = {id: gettime(), title: text, url: url}
        // заносим ссылку в историю
        history.pushState( state, state.title, state.url );
        $.get( surl, function( data ) {
            $(".modal-dialog").addClass("modal-lg");
            $(".modal-title").html(text);
            $(".modal-body").html(data);
            $("#myModal").modal('show');
        });
        return false;
    });
    $('#myModal').on('hidden.bs.modal', function () {
        History.back();
    })
 
    $('#myTab a').click(function (e) {
        e.preventDefault()
        $(this).tab('show')
    })

    //$.datepicker.setDefaults($.datepicker.regional['ru']);
   /* $('.datetimepicker').datetimepicker({
        stepMinute: 5
    });
    */
    
    
    $(".price-string").click(function(){
        id = $(this).attr("data-id");
        $(".price-edit").hide();
        $(".price-string").show();
        $(this).hide();
        $("#"+id).show();
    });
    
    $(".save-form").click(function(){
        id = $(this).attr("data-id");
        data = Array();
        $(".price-edit[id="+id+"] input").each(function(){
			data[this.name] = this.value;
		});
        data['output'] = 'ajax';
        $.post(
            '/action/saveprice',
            {
                output: 'ajax',
                node: data['node'],
                extkey: data['extkey'],
                count: data['count'],
                price1: data['price1']/*, 
                price2: data['price2'],
                price3: data['price3']  */
            },
            function(response){
                //alert(response);
                $(".price-string[data-id="+id+"] .extkey").html(data['extkey']);
                $(".price-string[data-id="+id+"] .count").html(data['count']);
                $(".price-string[data-id="+id+"] .price1").html(data['price1']);
                /*$(".price-string[data-id="+id+"] .price2").html(data['price2']);
                $(".price-string[data-id="+id+"] .price3").html(data['price3']); */
                $(".price-edit").hide();
                $(".price-string[data-id='"+id+"']").show();
                //location.reload();   
            }
        );    
    });
    $(".clone-field").click(function(e){
        field = $(this).parents('.datafield').children('.field-wrapper'); //получаем поле, которое нужно скопировать.
        if(field.size() == 1)
        {
            fname = field.children('input').attr('name'); //Получаем имя input
            field.children('input').attr('name', fname+"[]");// Добавляем к имени скобки чтобы вышел массив
        }                
        clone = $(field[0]).clone(); //клонируем 1 элемент
        clone.children("input").val('');
        
        
        clone.insertAfter($(field).last());  //вставляем после последнего элеммента
        clone.children(".remove-field").show();
        field.children(".remove-field").show();
        //clone.children(".field-count")[0].innerHTML = field.size()+1; 
        i = 0;
        fid = $(this).parents('.datafield').attr("id");
        $("#"+fid).children('.field-wrapper').each(function()
        {
            $(this).children('.field-count').html(i);
            i++;
        });
    });
    
    /*$(".remove-field").live('click', function(e){
        field = $(this).parents('.field-wrapper'); //получаем поле, которое нужно удалить.
        fc = $(this).parents('.datafield').children('.field-wrapper').size();
        if(fc == 2)//Если поля осталось всего 2
        {
            $(this).parents('.datafield').children('.field-wrapper').children(".remove-field").hide(); //прячем кнопку удалить 
            name = $(this).parents('.datafield').children('.field-wrapper').children('input').attr('name'); // получаем имя поля
            l = name.length - 2;
            newname = name.substring(0, l);// и обрезаем вконце []
            $(this).parents('.datafield').children('.field-wrapper').children('input').attr('name', newname); //обновляем значение имени               
        }
        i = 0;
        fid = $(this).parents('.datafield').attr("id");
        field.remove();
        $("#"+fid).children('.field-wrapper').each(function()
        {
            $(this).children('.field-count').html(i);
            i++;
        });
    }); */
    $(".arrow").click(function(){
        id = $(this).attr("data-target");
        if($(this).hasClass('fa-plus-square'))
        {
            $(this).removeClass('fa-plus-square').addClass('fa-minus-square');
            $("#"+id).removeClass('cl');
        }
        else
        {
            $(this).removeClass('fa-minus-square').addClass('fa-plus-square');
            $("#"+id).addClass('cl');
        }
    });
    
    $(".fields .item").draggable({
       opacity: 0.7, 
       helper: "clone",
       revert: false
    });
    $(".workzone").droppable({
        drop: function( event, ui ) {
            dropped = ui.draggable;
            console.log($(dropped).attr('class'));
            if($(dropped).hasClass('original'))
            {
                fid = $(dropped).attr('id');
                $("#"+fid).clone().removeClass('original').appendTo(".workzone");
            }
        }
    });
    $(".workzone").sortable();
    $(".workzone").disableSelection();
});

function submit_form(form)
{
    $('textarea').each(function(){this.elrte !== void(0) && $(this).elrte('updateSource')});
    $('form[name="'+form+'"]').submit();
}

function checkall(e,a)
{
    for(i=0;i<e.length;i++)
    {
        if(e[i].name=='realm[]' && e[i].type == 'checkbox')e[i].checked = a.checked;
        if(e[i].name=='node[]' && e[i].type == 'checkbox')e[i].checked = a.checked;
        if(e[i].name=='include[]' && e[i].type == 'checkbox')e[i].checked = a.checked;
    }
    return true;
}
function UnHide( eThis, realm ){
    if( eThis.innerHTML.charCodeAt(0) == 9658 ){
        eThis.innerHTML = '▼'
        document.getElementById(realm).className = '';
    }else{
        eThis.innerHTML = '►'
        document.getElementById(realm).className = 'cl';
    }
    return false;
}

function changelist(id, v)
{
    $("#"+id).val(v);

}
function showlist(name)
{
    $("div.sublist").css("display", "none");
    $("#"+name).css("display", "block");
}
function gettime()
{
    var d = new Date();
    return d.getTime();
}