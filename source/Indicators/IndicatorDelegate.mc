using Toybox.System;
using Toybox.WatchUi;
using Toybox.Application;


class IndicatorDelegate extends WatchUi.InputDelegate {

	function initialize() {
		WatchUi.InputDelegate.initialize();
	}
	
	function onTap(clickEvent) {
        System.println("2 Clicked at: " + clickEvent.getCoordinates() + " type: " + clickEvent.getType());
        return true;
    }
	
	function onSwipe(swipeEvent) {
		System.println("2 Swiped direction: " + swipeEvent.getDirection());
		if (swipeEvent.getDirection() == WatchUi.SWIPE_UP) {
        	WatchUi.popView(WatchUi.SWIPE_RIGHT);
        }
		return true;
	}
}