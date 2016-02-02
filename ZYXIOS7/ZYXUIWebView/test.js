
function showAlert()
{
    alert('in show alert');
}

function loadURL(url)
{
    var iFrame;
    iFrame = document.createElement("iFrame");
    iFrame.setAttribute("src", url);
    iFrame.setAttribute("style", "display:none;");
    iFrame.setAttribute("height", "0px");
    iFrame.setAttribute("width", "0px");
    iFrame.setAttribute("frameborder", "0");
    document.body.appendChild(iFrame);
    
    //发起请求后这个iFrame就没用了
    iFrame.parentNode.removeChild(iFrame);
    iFrame = null;
}