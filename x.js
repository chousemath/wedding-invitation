window.onload = function() {
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

    // generate the slide show
    new Glide('.glide').mount();
}

