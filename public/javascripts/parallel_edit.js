    function ajax_add_lock(part_id) {
        $.get("/wiki/add_lock?part_id=" + part_id, "", null, "script");
    }

    function ajax_update_lock(part_id) {
        if (is_locked(part_id)) {
            $.get("/wiki/update_lock?part_id=" + part_id, "", null, "script");
        }
    }

    function lost_focus() {
        $("#page_title").focus();
    }

    function set_focus(part_id, part_name) {
        $("#parts_" + part_id + "_" + part_name).focus();
    }

    function show_confirm(is_edited_by_another, part_id, part_name) {
        if (!is_locked(part_id)) {
            if (is_edited_by_another) {
                lost_focus();
                if (confirm(notification_message)) {
                    add_lock(part_id);
                    set_focus(part_id, part_name);
                } else {
                    lost_focus();
                    return false;
                }
            } else {
                add_lock(part_id);
            }
        }
    }


    function add_lock(part_id) {
        current_parts.push(part_id);
    }

    function is_locked(part_id) {
        return (current_parts.indexOf(part_id.toString()) != -1);
    }

function toggleWMD(elementId) {
    var element  = document.getElementById(elementId);
    $(elementId).toggle();
}