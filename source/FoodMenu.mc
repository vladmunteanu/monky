using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Timer;

function pushFoodMenu() {
    var customMenu = new WatchUi.Menu2({:title=>"Food Menu"});
    customMenu.addItem(new WatchUi.MenuItem("Vegetables", null, Constants.FOOD_VEGETABLES, null));
    customMenu.addItem(new WatchUi.MenuItem("Steak", null, Constants.FOOD_STEAK, null));
    customMenu.addItem(new WatchUi.MenuItem("Pizza", null, Constants.FOOD_PIZZA, null));
    customMenu.addItem(new WatchUi.MenuItem("Cake", null, Constants.FOOD_CAKE, null));
    WatchUi.pushView(customMenu, new FoodMenuDelegate(), WatchUi.SLIDE_DOWN);
}

class FoodMenuDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) {
        var itemId = item.getId();
        if(itemId.equals(Constants.FOOD_VEGETABLES)) {
            Application.getApp().incrCurrentStateItem(Constants.STATE_KEY_HEALTH, 10, Constants.MAX_HEALTH);
            Application.getApp().incrCurrentStateItem(Constants.STATE_KEY_FIT, 5, Constants.MAX_FIT);
            Application.getApp().decrCurrentStateItem(Constants.STATE_KEY_HAPPY, 10, Constants.MIN_HAPPY);
        } else if (itemId.equals(Constants.FOOD_CAKE)) {
            Application.getApp().incrCurrentStateItem(Constants.STATE_KEY_HAPPY, 15, Constants.MAX_HAPPY);
            Application.getApp().decrCurrentStateItem(Constants.STATE_KEY_HEALTH, 5, Constants.MIN_HEALTH);
            Application.getApp().decrCurrentStateItem(Constants.STATE_KEY_FIT, 10, Constants.MIN_FIT);
        } else if (itemId.equals(Constants.FOOD_STEAK)){
            Application.getApp().incrCurrentStateItem(Constants.STATE_KEY_HEALTH, 5, Constants.MAX_HEALTH);
            Application.getApp().incrCurrentStateItem(Constants.STATE_KEY_FIT, 10, Constants.MAX_FIT);
            Application.getApp().decrCurrentStateItem(Constants.STATE_KEY_CLEAN, 10, Constants.MIN_CLEAN);
        } else if (itemId.equals(Constants.FOOD_PIZZA)){
            Application.getApp().incrCurrentStateItem(Constants.STATE_KEY_HEALTH, 5, Constants.MAX_HEALTH);
            Application.getApp().incrCurrentStateItem(Constants.STATE_KEY_HAPPY, 10, Constants.MAX_HAPPY);
            Application.getApp().decrCurrentStateItem(Constants.STATE_KEY_CLEAN, 5, Constants.MIN_CLEAN);
            Application.getApp().decrCurrentStateItem(Constants.STATE_KEY_FIT, 5, Constants.MIN_FIT);
        }
        Application.getApp().incrCurrentStateItem(Constants.STATE_KEY_XP, 10, null);
        WatchUi.pushView(new FoodView(item.getId()), null, WatchUi.SLIDE_DOWN);
    }

    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_UP);
    }
}
