using Toybox.System;
using Toybox.WatchUi;
using Toybox.Application;


class SwipeGameDelegate extends WatchUi.InputDelegate {

	function initialize() {
		WatchUi.InputDelegate.initialize();
	}
	
	function onSwipe(swipeEvent) {
		System.println("2 Swiped direction: " + swipeEvent.getDirection());
		if (swipeEvent.getDirection() == WatchUi.SWIPE_RIGHT) {
//        	var view_and_delegate = Application.getApp().getMainView();
        	WatchUi.popView(WatchUi.SWIPE_RIGHT);
//			WatchUi.switchToView(view_and_delegate[0], view_and_delegate[1], WatchUi.SWIPE_RIGHT);
        }
		return true;
	}
}