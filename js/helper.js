 
function hasClass(name, className) {
    return className.indexOf(name) !== -1;
}

function autoIconSize(parent, prescale=0.5, maxsize=512) {
    let width = parent.width * prescale;
    let height = parent.height * prescale;

    if (Math.min(width, height) < maxsize)
        return Math.min(width, height);
    else
        return maxsize;
}
