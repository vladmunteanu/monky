using Toybox.System;
using Toybox.WatchUi;
using Toybox.Application;


class MonkyDelegate extends WatchUi.InputDelegate {

	function initialize() {
		WatchUi.InputDelegate.initialize();
	}
	
	function onTap(clickEvent) {
		var coordinates = clickEvent.getCoordinates();
        if (coordinates[0] >= 45 && coordinates[0] <= 75 && coordinates[1] >= 45 && coordinates[1] <= 75) {
        	WatchUi.pushView(new IndicatorView(), null, WatchUi.SLIDE_DOWN);
        }
        else if (coordinates[0] >= 95 && coordinates[0] <= 125 && coordinates[1] >= 25 && coordinates[1] <= 55) {
        	var customMenu = new WatchUi.Menu2({:title=>"Food Menu"});
            customMenu.addItem(new WatchUi.MenuItem("Vegetables", null, Constants.FOOD_VEGETABLES, null));
            customMenu.addItem(new WatchUi.MenuItem("Steak", null, Constants.FOOD_STEAK, null));
            customMenu.addItem(new WatchUi.MenuItem("Cookie", null, Constants.FOOD_COOKIE, null));
            WatchUi.pushView(customMenu, new FoodMenuDelegate(), WatchUi.SLIDE_DOWN);
        }
        else if (coordinates[0] >= 145 && coordinates[0] <= 175 && coordinates[1] >= 45 && coordinates[1] <= 75) {
        	var customMenu = new WatchUi.Menu2({:title=>"Games Menu"});
            customMenu.addItem(new WatchUi.MenuItem("Swipe that way!", null, Constants.GAME_SWIPE, null));
			customMenu.addItem(new WatchUi.MenuItem("Whack that mole!", null, Constants.GAME_WAM, null));
            WatchUi.pushView(customMenu, new GamesMenuDelegate(), WatchUi.SLIDE_DOWN );
        }
        return true;
    }
}