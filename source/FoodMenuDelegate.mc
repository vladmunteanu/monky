using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Timer;


class EatingProgressDelegate extends WatchUi.BehaviorDelegate {
	var timer, currentProgress, progressBar;
    
    function initialize(startValue, progressBarInstance) {
        BehaviorDelegate.initialize();
        timer = new Timer.Timer();
        currentProgress = startValue;
        progressBar = progressBarInstance;

        timer.start(self.method(:timerCallback), 500, true);
    }

    function onBack() {
    	timer.stop();
        return true;
    }
    
   function timerCallback() {
   		currentProgress += 25;
   		if (currentProgress > 100) {
   			timer.stop();
   			WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
   		}
    	progressBar.setProgress(currentProgress);
    }
}


class FoodMenuDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) {
    	System.println("On select food: " + item.getId());
        if(item.getId().equals(Constants.FOOD_VEGETABLES)) {
            Application.getApp().incrCurrentStateItem(Constants.STATE_KEY_HEALTH, 10, Constants.MAX_HEALTH);
            Application.getApp().incrCurrentStateItem(Constants.STATE_KEY_FIT, 5, Constants.MAX_FIT);
            Application.getApp().decrCurrentStateItem(Constants.STATE_KEY_HAPPY, 5, Constants.MIN_HAPPY);
        } 
        else if (item.getId().equals(Constants.FOOD_COOKIE)) {
        	Application.getApp().incrCurrentStateItem(Constants.STATE_KEY_HAPPY, 15, Constants.MAX_HAPPY);
            Application.getApp().decrCurrentStateItem(Constants.STATE_KEY_HEALTH, 5, Constants.MIN_HEALTH);
            Application.getApp().decrCurrentStateItem(Constants.STATE_KEY_FIT, 5, Constants.MIN_FIT);
        } 
        else if (item.getId().equals(Constants.FOOD_STEAK)){
            Application.getApp().incrCurrentStateItem(Constants.STATE_KEY_HEALTH, 5, Constants.MAX_HEALTH);
            Application.getApp().incrCurrentStateItem(Constants.STATE_KEY_HAPPY, 10, Constants.MAX_HAPPY);
            Application.getApp().decrCurrentStateItem(Constants.STATE_KEY_FIT, 5, Constants.MIN_FIT);
            Application.getApp().decrCurrentStateItem(Constants.STATE_KEY_CLEAN, 5, Constants.MIN_CLEAN);
        }
        Application.getApp().incrCurrentStateItem(Constants.STATE_KEY_XP, 10, null);
        var progressBar = new WatchUi.ProgressBar("Eating " + item.getId(), 0);
        var progressBarDelegate = new EatingProgressDelegate(0, progressBar);
        WatchUi.pushView(progressBar, progressBarDelegate, WatchUi.SLIDE_IMMEDIATE);
    }

    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_UP);
    }
}
