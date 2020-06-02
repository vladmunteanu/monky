using Toybox.System;
using Toybox.WatchUi;
using Toybox.Application;


class SwipeGameDelegate extends WatchUi.InputDelegate {

	var view;

	function initialize(swipeGameView) {
		WatchUi.InputDelegate.initialize();
		view = swipeGameView;
	}
	
	function onKey(keyEvent) {
		System.println("2 onKey: " + keyEvent.getKey());
		if (keyEvent.getKey() == WatchUi.KEY_ESC) {
			if (view.commons.stopped) {
				WatchUi.popView(WatchUi.SLIDE_RIGHT);
			} else {
				if (view.commons.getCurrentDirection().equals("right")) {
					view.commons.registerLap(true);
					view.commons.resetCurrentDirection();
				}
			}
		}
		return true;
	}
	
	function onKeyPressed(keyEvent) {
		System.println("2 onKeyPressed: " + keyEvent.getKey());
		return true;
	}
	
	function onSwipe(swipeEvent) {
		System.println("2 Swiped direction: " + swipeEvent.getDirection());
		if (!view.commons.stopped) {
			var direction = view.commons.getCurrentDirection();
			if (swipeEvent.getDirection() == view.commons.directionsToGesture[direction]) {
				System.println("Good swipe");
				view.commons.registerLap(true);
	        }
	        else {
	        	System.println("Bad swipe");
	        	view.commons.registerLap(false);
	        }
	        view.commons.resetCurrentDirection();
		} else {
			if (swipeEvent.getDirection() == WatchUi.SWIPE_LEFT) {
				var view = new WAMGameView();
				var delegate = new WAMGameDelegate(view);
				WatchUi.pushView(view, delegate, WatchUi.SLIDE_LEFT);
        	}
        }
		return true;
	}
}