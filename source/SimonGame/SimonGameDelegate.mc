using Toybox.System;
using Toybox.WatchUi;
using Toybox.Application;


class SimonGameDelegate extends WatchUi.InputDelegate {

    var view;
    function initialize(simonGameView) {
        WatchUi.InputDelegate.initialize();
        view = simonGameView;
    }

    function onTap(clickEvent) {
        if (!view.commons.stopped && !view.commons.simonsTurn) {
            var coordinates = clickEvent.getCoordinates();
            view.commons.registerTap(coordinates[0], coordinates[1]);
        }
        return true;
    }
}