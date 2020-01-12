window.onload = function() {
    var contGreeting = document.getElementById('cont-greeting');
    var contGallery = document.getElementById('cont-gallery');
    var greeting = new Hammer(contGreeting, {});
    var gallery = new Hammer(contGallery, {});
    greeting.get('swipe').set({ direction: Hammer.DIRECTION_VERTICAL });
    gallery.get('swipe').set({ direction: Hammer.DIRECTION_VERTICAL });
    greeting.on('tap', function(ev) {
        console.log(ev);
        alert('greeting tapped');
    });
    greeting.on('swipedown', function(ev) {
        console.log(ev);
        alert('greeting swiped down');
    });
}

