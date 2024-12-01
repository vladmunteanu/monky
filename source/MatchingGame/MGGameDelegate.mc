using Toybox.System;
using Toybox.WatchUi;
using Toybox.Application;
using Toybox.Attention;


class MatchingGameDelegate extends WatchUi.InputDelegate {

    var view;
    function initialize(mgGameView) {
        WatchUi.InputDelegate.initialize();
        view = mgGameView;
    }

    function onTap(clickEvent) {
        if (view.commons.started && !view.commons.stopped) {
            var position, lowerX, upperX, lowerY, upperY;
            var coordinates = clickEvent.getCoordinates();
            for (var i = 0; i < view.commons.numPairs; i++) {
                position = view.commons.positions[i];
                lowerX = position[0] + view.commons.hideDetails[0] - view.commons.hideDetails[2];
                upperX = position[0] + view.commons.hideDetails[0] + view.commons.hideDetails[2];
                lowerY = position[1] + view.commons.hideDetails[1] - view.commons.hideDetails[2];
                upperY = position[1] + view.commons.hideDetails[1] + view.commons.hideDetails[2];
                if (coordinates[0] >= lowerX && coordinates[0] <= upperX && coordinates[1] >= lowerY && coordinates[1] <= upperY) {
                    view.commons.selectPosition(i);
                    break;
                }
            }
            if (Attention has :vibrate) {
                var vibe = [new Attention.VibeProfile(20, 50)];
                Attention.vibrate(vibe);
            }
        }
        return true;
    }
}