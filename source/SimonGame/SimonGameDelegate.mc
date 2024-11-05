using Toybox.System;
using Toybox.WatchUi;
using Toybox.Application;
using Toybox.Attention;


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
            if (Attention has :vibrate) {
                var vibe = [new Attention.VibeProfile(20, 50)];
                Attention.vibrate(vibe);
            }
        }
        return true;
    }
}
