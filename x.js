window.onload = function() {
    // http://apis.map.kakao.com/web/sample/
    var mapElem = document.getElementById('map');
    var weddingHallCoord = [37.573920, 126.976517];
	var posCenter = new kakao.maps.LatLng(...weddingHallCoord);
    var options = { center: posCenter, level: 4 };
    var map = new kakao.maps.Map(mapElem, options);
    // add markers
	var posMarker = new kakao.maps.LatLng(...weddingHallCoord);
    var marker = new kakao.maps.Marker({ position: posMarker });
    marker.setMap(map);
    // generate the slide show
    new Glide('.glide').mount();
    // Kakao library required for KakaoStory sharing
    Kakao.init('34bdc320546bff69ab85d45afbb07fc1');
    var shareMsg = '최수강/최성필: 우리 결혼합니다!';
    appElm.ports.shareLink.subscribe(function(share) {
        switch (share.platform) {
            case 1:
                Kakao.Story.share({url: share.url, text: shareMsg});
                break;
            case 2:
                FB.ui({
                    method: 'share',
                    href: share.url
                }, function(response){});
                break;
            default:
                break;
        }
    });
    window.onresize = function(event) {
        var t = event.target;
        var load = {
            width: t.innerWidth,
            height: t.innerHeight
        };
        console.log(load);
        appElm.ports.resizeWindow.send(load);
    };
    var typedOpt = {
        typeSpeed: 40,
        backSpeed: 90,
        smartBackspace: true,
        loop: true,
        showCursor: false
    };
    var skOptions = {...typedOpt,
        strings: [
            'Thank you so much for coming to our wedding. I really appreciate it. ^1000',
            'You guys are really the absolute best!'
        ]
    };
    var jsOptions = {...typedOpt,
        strings: [
            'The moment comes once in a lifetime, when a lone prairie dog must find his way. ^1000',
            'The shadow of the dog tail leads the way to the tastiest termites.'
        ]
    };

    var skTyped = new Typed('#sk-typed', skOptions);
    var jsTyped = new Typed('#js-typed', jsOptions);
}

window.fbAsyncInit = function() {
    FB.init({
        appId            : '565769117480524',
        autoLogAppEvents : true,
        xfbml            : true,
        version          : 'v5.0'
    });
};
