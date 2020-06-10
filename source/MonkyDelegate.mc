using Toybox.System;
using Toybox.WatchUi;
using Toybox.Application;


class MonkyDelegate extends WatchUi.InputDelegate {

    var view;
    function initialize(monkyView) {
        WatchUi.InputDelegate.initialize();
        view = monkyView;
    }

    function onTap(clickEvent) {
        if (view.heartBitmaps != null && view.activitiesBitmap != null && view.foodBitmap != null) {
            if (bitmapWasHit(view.heartBitmaps[view.heartId], clickEvent)) {
                WatchUi.pushView(new IndicatorView(), null, WatchUi.SLIDE_DOWN);
            }
            else if (bitmapWasHit(view.foodBitmap, clickEvent)) {
                var customMenu = new WatchUi.Menu2({:title=>"Food Menu"});
                customMenu.addItem(new WatchUi.MenuItem("Vegetables", null, Constants.FOOD_VEGETABLES, null));
                customMenu.addItem(new WatchUi.MenuItem("Steak", null, Constants.FOOD_STEAK, null));
                customMenu.addItem(new WatchUi.MenuItem("Cookie", null, Constants.FOOD_COOKIE, null));
                WatchUi.pushView(customMenu, new FoodMenuDelegate(), WatchUi.SLIDE_DOWN);
            }
            else if (bitmapWasHit(view.activitiesBitmap, clickEvent)) {
                var customMenu = new WatchUi.Menu2({:title=>"Activities Menu"});
                customMenu.addItem(new WatchUi.MenuItem("Swipe that way!", null, Constants.GAME_SWIPE, null));
                customMenu.addItem(new WatchUi.MenuItem("Whack that mole!", null, Constants.GAME_WAM, null));
                WatchUi.pushView(customMenu, new ActivitiesMenuDelegate(), WatchUi.SLIDE_DOWN );
            }
        }
        return true;
    }

    function bitmapWasHit(bitmap, tapEvent) {
        var bitmapLoc = [bitmap.locX, bitmap.locY];
        var bitmapSize = [bitmap.width, bitmap.height];
        var coordinates = tapEvent.getCoordinates();

        if (
            coordinates[0] >= bitmapLoc[0] - 5
            && coordinates[0] <= bitmapLoc[0] + bitmapSize[0] + 5
            && coordinates[1] >= bitmapLoc[1] - 5
            && coordinates[1] <= bitmapLoc[1] + bitmapSize[1] + 5
        ) {
            return true;
        }
        return false;
    }
}