using Toybox.System;
using Toybox.WatchUi;
using Toybox.Application;


class PlayfulWidgetDelegate extends WatchUi.InputDelegate {

	function initialize() {
		WatchUi.InputDelegate.initialize();
	}
	
	function onTap(clickEvent) {
		var coordinates = clickEvent.getCoordinates();
        System.println("1 Clicked at: " + coordinates + " type: " + clickEvent.getType());
        if (coordinates[0] >= 45 && coordinates[0] <= 75 && coordinates[1] >= 45 && coordinates[1] <= 75) {
        	System.println("Clicked on heart");
        	WatchUi.pushView(new IndicatorView("heart"), new IndicatorDelegate(), WatchUi.SLIDE_DOWN);
        }
        else if (coordinates[0] >= 95 && coordinates[0] <= 125 && coordinates[1] >= 25 && coordinates[1] <= 55) {
        	System.println("Clicked on cake");
        	WatchUi.pushView(new IndicatorView("cake"), new IndicatorDelegate(), WatchUi.SLIDE_DOWN);
        }
        else if (coordinates[0] >= 145 && coordinates[0] <= 175 && coordinates[1] >= 45 && coordinates[1] <= 75) {
        	System.println("Clicked on scooter");
        	var customMenu = new WatchUi.Menu2({:title=>"Games Menu"});
            customMenu.addItem(new WatchUi.MenuItem("Swipe that way!", null, Constants.GAME_SWIPE, null));
			customMenu.addItem(new WatchUi.MenuItem("Whack that mole!", null, Constants.GAME_WAM, null));
            WatchUi.pushView(customMenu, new GamesMenuDelegate(), WatchUi.SLIDE_DOWN );
        }
        return true;
    }
	
	function onKey(keyEvent) {
		System.println("1 Pressed key: " + keyEvent.getKey() + " type: " + keyEvent.getType());
		if (keyEvent.getKey() == WatchUi.KEY_ESC) {
			return false;
		}
		return true; 
	}
}