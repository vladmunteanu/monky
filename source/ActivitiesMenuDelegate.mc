using Toybox.WatchUi;

class ActivitiesMenuDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) {
        if( item.getId().equals(Constants.GAME_SWIPE) ) {
            var view = new SwipeGameView();
        	var delegate = new SwipeGameDelegate(view);
			WatchUi.pushView(view, delegate, WatchUi.SLIDE_LEFT);
        } else if ( item.getId().equals(Constants.GAME_WAM) ) {
            var view = new WAMGameView();
        	var delegate =  new WAMGameDelegate(view);
			WatchUi.pushView(view, delegate, WatchUi.SLIDE_LEFT);
        } else {
            WatchUi.requestUpdate();
        }
    }

    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_UP);
    }
}
