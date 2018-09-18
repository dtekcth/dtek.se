/*Set header to something random */

$banner = $('#banner-pix:not([class])');

function setBanner() {
    var rawFile = new XMLHttpRequest();
    rawFile.open("GET", imageDir + "/banners/banners.txt", true);
    rawFile.onload = function (e) {
        if(rawFile.readyState === 4) {
            if(rawFile.status === 200 || rawFile.status == 0) {
                var allText = rawFile.responseText.split("\n");
                var number = Math.floor(Math.random() * allText.length);
                var background = allText[number];
                $banner.css('background-image', "url('" + imageDir + "/banners/" + background + "')");
                $banner.fadeIn(1000);
                console.log("Background " + number + ": " + background);
            } else {
                console.error(rawFile.statusText);
            }
        }
    }
    rawFile.onerror = function (e) {
        console.error(rawFile.statusText);
    }
    rawFile.send(null);
    setTimeout(function(){ $banner.fadeOut(1000, setBanner);}, 10000);
}
setBanner();


function is_touch_device() {
    return 'ontouchstart' in window;
}
