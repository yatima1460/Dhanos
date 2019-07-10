document.onkeydown = function (evt) {
    evt = evt || window.event;
    var isEscape = false;
    if ("key" in evt) {
        isEscape = (evt.key === "Escape" || evt.key === "Esc");
    } else {
        isEscape = (evt.keyCode === 27);
    }
    if (isEscape) {
        //alert("The window will close");
        console.log("The window will close");
        //document.write("The window will close");
        window.external.invoke("aaaaaaaa");
    }
};