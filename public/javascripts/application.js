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
});