<!--  keeps track of history without duplicates so login can go to previous page -->
var url = window.location.pathname;


addPage(url);

// Back button function
function redirect(){
    var pageHistory = JSON.parse(sessionStorage.pageHistory || '[]');

    // Find this page in history
    var thisPageIndex = pageHistory.indexOf(url);
    if(thisPageIndex > 1 )
        if(pageHistory[thisPageIndex - 2] === "/shop/showcart.jsp")
            window.location.href = "/shop/checkout.jsp";
        else
            window.location.href = pageHistory[thisPageIndex - 2];
}

function addPage(url){
    var pageHistory = JSON.parse(sessionStorage.pageHistory || '[]');

    // Find this page in history
    var thisPageIndex = pageHistory.indexOf(url);

    if(url === "/shop/addcart.jsp"){ //don't include in-between pages
        url = "/shop/showcart.jsp";
    }
    // If this page was not in the history, add it to the top of the stack
    if( thisPageIndex < 0){
        pageHistory.push(url);
        thisPageIndex = pageHistory.length -1;

        // Wipe the forward history
    }else if(thisPageIndex < pageHistory.length -1){
        for(; thisPageIndex < pageHistory.length -1;)
            pageHistory.pop();
    }

    // Store history array
    sessionStorage.pageHistory = JSON.stringify(pageHistory);
}

function showToast(message, isSuccess) {
    var xhr = new XMLHttpRequest();
    xhr.open('GET', '/shop/toastGenerator?message=' + encodeURIComponent(message) + '&success=' + isSuccess, true);

    xhr.onload = function() {
        if (xhr.status === 200) {
            var toastContainer = document.getElementById('toastContainer');
            toastContainer.innerHTML = xhr.responseText; // Insert the toast HTML

            var toastElList = [].slice.call(toastContainer.querySelectorAll('.toast'));
            var toastList = toastElList.map(function(toastEl) {
                return new bootstrap.Toast(toastEl);
            });
            toastList.forEach(toast => toast.show());
        }
    };

    xhr.send();
}

// Countdown timer for redirecting to another URL after several seconds

var seconds = 5; // seconds for HTML
var foo; // variable for clearInterval() function

function pageRedirect(page) {
    document.location.href = page;
}

function updateSecs(page) {
    document.getElementById("seconds").innerHTML = seconds;
    seconds--;
    if (seconds === -1) {
        clearInterval(foo);
        pageRedirect(page);
    }
}

function countdownTimer(page) {
    foo = setInterval(function () {
        updateSecs(page)
    }, 1000);
}
