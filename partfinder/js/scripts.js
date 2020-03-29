$(document).ready(function () {
    // toggle sidebar when button clicked
    $('.sidebar-toggle').on('click', function () {
        $('.sidebar').toggleClass('toggled');
    });

    // auto-expand submenu if an item is active
    var active = $('.sidebar .active');

    if (active.length && active.parent('.collapse').length) {
        var parent = active.parent('.collapse');

        parent.prev('a').attr('aria-expanded', true);
        parent.addClass('show');
    }
});

function toggleWin(WinName) {
    if (document.layers) {
        document.layers[WinName].visibility = iState ? "show" : "hide";

    }
    else if (document.getElementById) {
        var obj = document.getElementById(WinName);
        if (obj.style.visibility != "visible" && obj.style.display != "block") {
            // is open
            obj.style.visibility = "visible";
            obj.style.display = "block";
        } else {
            obj.style.visibility = "hidden";
            obj.style.display = "none";
        }

    }
    else if (document.all)	// IE 4
    {
        document.all[WinName].style.visibility = iState ? "visible" : "hidden";

    }
}
// end jquery menu

function OpenHelpWindow(theURL) {
    window.open(theURL, '', 'scrollbars=yes,resizable=yes,width=600,height=600');
}

function DeleteConfirmation(filepath) {
    var answer = confirm("Are you sure you want to delete this item?")
    if (answer) {
        window.location = filepath;
    }
}