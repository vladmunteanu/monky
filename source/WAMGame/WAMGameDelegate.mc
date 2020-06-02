using Toybox.System;
using Toybox.WatchUi;
using Toybox.Application;


class WAMGameDelegate extends WatchUi.InputDelegate {

	var view;
	function initialize(wamGameView) {
		WatchUi.InputDelegate.initialize();
		view = wamGameView;
	}
	
	function onTap(clickEvent) {
		if (!view.commons.stopped) {
			var coordinates = clickEvent.getCoordinates();
			var currentPosition = view.commons.holeCoordinates[view.commons.currentPosition];
	        System.println("4>>> Clicked at: " + coordinates + " currentPosition: " + currentPosition);
	        var lowerX = currentPosition[0] - 20;
	        var upperX = currentPosition[0] + 20;
	        var lowerY = currentPosition[1] - 20;
	        var upperY = currentPosition[1] + 20;
	        if (coordinates[0] >= lowerX && coordinates[0] <= upperX && coordinates[1] >= lowerY && coordinates[1] <= upperY) {
	        	view.commons.registerLap(true);
	        } else {
	        	view.commons.registerLap(false);
	        }
	        view.commons.resetPosition();
		}
        return true;
    }
}