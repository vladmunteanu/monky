using Toybox.System;
using Toybox.WatchUi;
using Toybox.Application;


class SwipeGameDelegate extends WatchUi.InputDelegate {

	var view;
	var lastKeyRight;

	function initialize(swipeGameView) {
		WatchUi.InputDelegate.initialize();
		view = swipeGameView;
	}
	
	function onKey(keyEvent) {
		if (keyEvent.getKey() == WatchUi.KEY_ESC) {
			if (view.commons.stopped) {
				WatchUi.popView(WatchUi.SLIDE_RIGHT);
			} else {
				var currentTimeMs = System.getTimer();
				if (lastKeyRight && currentTimeMs - lastKeyRight < 300) {
					WatchUi.popView(WatchUi.SLIDE_RIGHT);
				}
				else {
					lastKeyRight = currentTimeMs;
				}
				if (view.commons.getCurrentDirection().equals("right")) {
					view.commons.registerLap(true);
					view.commons.resetCurrentDirection();
				}
			}
		}
		return true;
	}
	
	function onSwipe(swipeEvent) {
		if (!view.commons.stopped) {
			var direction = view.commons.getCurrentDirection();
			if (swipeEvent.getDirection() == view.commons.directionsToGesture[direction]) {
				view.commons.registerLap(true);
	        }
	        else {
	        	view.commons.registerLap(false);
	        }
	        view.commons.resetCurrentDirection();
		} else {
			if (swipeEvent.getDirection() == WatchUi.SWIPE_RIGHT) {
				WatchUi.popView(WatchUi.SLIDE_RIGHT);
        	}
        }
		return true;
	}
}