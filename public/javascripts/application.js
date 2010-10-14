$(document).ready(function() {
    $("#q").autocomplete({
        source: "/wiki/pages/quick_search",
        minLength: 2,
        select: function(event, ui) {
            document.location = ui.item.url;
            return false;
        },
        searchingMode: true // solves http://dev.jqueryui.com/ticket/6038
    }).data("autocomplete")._renderItem = function(ul, item) {
        var description = (item.description == "") ? "" : "<br><span class='description'>" + item.description + "</small>";
        return $("<li></li>")
                .data("item.autocomplete", item)
                .append("<a>" + item.title + description + "<br><span class='path'>" + item.path + "</span></a>")
                .appendTo(ul);
    };

    // toggler checkboxes
    $(':checkbox.toggle').click(function() {
        $(this).parents("table").first().find(":checkbox").attr("checked", $(this).is(":checked"));
    });

    // ajax uploader
    $("a.uploader").each(function(){
        $(this).click(function(event) {
            $(this).closest("form").find("input[type=file]").click();
            event.preventDefault();
        });
        $(this).closest("form").find("input[type=file]").change(function() {
            if(this.value == "") return;
            $(this).closest("form").ajaxSubmit({dataType: 'script'});
        });
    });

    // more on hover
    $('.more.trigger').live('mouseover mouseout', function(event){
        var items = $(this).find(".more");
        if(event.type == "mouseover") {
            items.show();
        } else {
            items.hide();
        }
    });

    // autosubmit
    $('select.autosubmit').live('change', function() {
        $(this).closest("form").submit();
    });

    // autocomplete
    $("input[data-autocomplete]").each(function(){
        $(this).autocomplete({
            source: $(this).attr('data-autocomplete'),
            minLength: 2
        }).data("autocomplete")._renderItem = function(ul, item) {
        return $("<li></li>")
                .data("item.autocomplete", item)
                .append("<a>" + item.label + "</a>")
                .appendTo(ul);
        };
    });
});