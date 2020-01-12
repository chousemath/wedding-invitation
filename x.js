window.onload = function() {
    var contGreeting = document.getElementById('cont-greeting');
    var contGallery = document.getElementById('cont-gallery');
    var contMap = document.getElementById('cont-map');
    var greeting = new Hammer(contGreeting, {});
    var gallery = new Hammer(contGallery, {});
    var mapSect = new Hammer(contMap, {});
    var scrollOpts = { block: 'start',  behavior: 'smooth' };

    greeting.get('swipe').set({ direction: Hammer.DIRECTION_VERTICAL });
    gallery.get('swipe').set({ direction: Hammer.DIRECTION_VERTICAL });
    mapSect.get('swipe').set({ direction: Hammer.DIRECTION_VERTICAL });

    greeting.on('swipeup', function(ev) { zenscroll.to(contGallery); });
    gallery.on('swipeup', function(ev) { zenscroll.to(contMap); });

    gallery.on('swipedown', function(ev) { zenscroll.to(contGreeting); });
    mapSect.on('swipedown', function(ev) { zenscroll.to(contGallery); });

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

