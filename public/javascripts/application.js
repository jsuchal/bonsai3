$(document).ready(function() {
    $("#q").autocomplete({
        source: "/wiki/pages/quick_search",
        minLength: 2,
        select: function(event, ui) {
            document.location = ui.item.url;
            return false;
        }
    });
});