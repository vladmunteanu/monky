using Toybox.System;
using Toybox.WatchUi;
using Toybox.Application;


class MonkyDelegate extends WatchUi.BehaviorDelegate {

    var view;
    function initialize(monkyView) {
        WatchUi.BehaviorDelegate.initialize();
        view = monkyView;
    }

    function onTap(clickEvent) {
        if (view.heartBitmaps != null && view.activitiesBitmap != null && view.foodBitmap != null) {
            if (bitmapWasHit(view.heartBitmaps[view.heartId], clickEvent)) {
                WatchUi.pushView(new IndicatorView(), null, WatchUi.SLIDE_DOWN);
            }
            else if (bitmapWasHit(view.foodBitmap, clickEvent)) {
                pushFoodMenu();
            }
            else if (bitmapWasHit(view.activitiesBitmap, clickEvent)) {
                pushActivitiesMenu();
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

    function onMenu() {
        pushSettingsMenu();
        return true;
    }
}