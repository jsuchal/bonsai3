$(document).ready(function() {
    $("#q").autocomplete({
        source: "/wiki/pages/quick_search",
        minLength: 2,
        select: function(event, ui) {
            document.location = ui.item.url;
            return false;
        },
        searchingMode: true // solves http://dev.jqueryui.com/ticket/6038
    });
});