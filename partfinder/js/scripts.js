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

window.addEventListener('DOMContentLoaded', event => {

    // Toggle the side navigation
    const sidebarToggle = document.body.querySelector('#sidebarToggle');
    if (sidebarToggle) {
        // Uncomment Below to persist sidebar toggle between refreshes
        // if (localStorage.getItem('sb|sidebar-toggle') === 'true') {
        //     document.body.classList.toggle('sb-sidenav-toggled');
        // }
        sidebarToggle.addEventListener('click', event => {
            event.preventDefault();
            document.body.classList.toggle('sb-sidenav-toggled');
            localStorage.setItem('sb|sidebar-toggle', document.body.classList.contains('sb-sidenav-toggled'));
        });
    }

});