window.onload = function() {
    var contGreeting = document.getElementById('cont-greeting');
    var contGallery = document.getElementById('cont-gallery');
    var contMap = document.getElementById('cont-map');
    var greeting = new Hammer(contGreeting, {});
    var gallery = new Hammer(contGallery, {});
    var mapSect = new Hammer(contMap, {});

    greeting.get('swipe').set({ direction: Hammer.DIRECTION_VERTICAL });
    gallery.get('swipe').set({ direction: Hammer.DIRECTION_VERTICAL });
    mapSect.get('swipe').set({ direction: Hammer.DIRECTION_VERTICAL });

    greeting.on('swipeup', function(ev) { contGallery.scrollIntoView(); });
    gallery.on('swipeup', function(ev) { contMap.scrollIntoView(); });

    gallery.on('swipedown', function(ev) { contGreeting.scrollIntoView(); });
    mapSect.on('swipedown', function(ev) { contGallery.scrollIntoView(); });

    // kakao map section
    // http://apis.map.kakao.com/web/sample/
    var mapElem = document.getElementById('map');
	var posCenter = new kakao.maps.LatLng(37.573920, 126.976517);
    var options = { center: posCenter, level: 4 };
    var map = new kakao.maps.Map(mapElem, options);
    // add markers
	var posMarker = new kakao.maps.LatLng(37.574927, 126.979106);
    var marker = new kakao.maps.Marker({ position: posMarker });
    marker.setMap(map);
}

