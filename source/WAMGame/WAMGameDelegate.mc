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
        if (!view.commons.stopped && view.commons.currentPosition >= 0) {
            var coordinates = clickEvent.getCoordinates();
            var currentPosition = view.commons.holeCoordinates[view.commons.currentPosition];
            var lowerX = currentPosition[0] - view.commons.holeDimensions[0] - 5;
            var upperX = currentPosition[0] + view.commons.holeDimensions[0] + 5;
            var lowerY = currentPosition[1] - view.commons.holeDimensions[1] - 5;
            var upperY = currentPosition[1] + view.commons.holeDimensions[1] + 5;
            if (coordinates[0] >= lowerX && coordinates[0] <= upperX && coordinates[1] >= lowerY && coordinates[1] <= upperY) {
                view.commons.registerLap(true);
            } else {
                view.commons.registerLap(false);
            }
        }
        return true;
    }
}
