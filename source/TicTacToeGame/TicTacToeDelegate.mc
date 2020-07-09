using Toybox.System;
using Toybox.WatchUi;
using Toybox.Application;


class TicTacToeDelegate extends WatchUi.InputDelegate {

    var view;
    function initialize(tttGameView) {
        WatchUi.InputDelegate.initialize();
        view = tttGameView;
    }

    function onTap(tapEvent) {
        var coord = tapEvent.getCoordinates();
        view.commons.processTap(coord[0], coord[1]);
        return true;
    }
}