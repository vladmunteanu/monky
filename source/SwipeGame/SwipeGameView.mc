using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Math;
using Toybox.Graphics;
using Toybox.Timer;
using Toybox.Lang;


class SwipeGameCommons extends Lang.Object {
    var current_direction;
    var directionsToGesture = {
        "up" => WatchUi.SWIPE_UP,
        "right" => WatchUi.SWIPE_RIGHT,
        "down" => WatchUi.SWIPE_DOWN,
        "left" => WatchUi.SWIPE_LEFT,
    };
    var directions = ["up", "right", "down", "left"];
    var timer;
    var timeout = 3000;
    var timeoutDecrement = 300;
    var timeoutThreshold = 500;
    var laps = 0;
    var successLaps = 0;
    var failedLaps = 0;
    var stopped = false;
    var lastAttemptSuccessful = false;

    var colorSwitch = true;

    function getTimeout() {
        if (lastAttemptSuccessful) {
            return timeout - (timeoutDecrement / 2 * laps);
        }
        return timeout - (timeoutDecrement * laps);
    }

    function startTimer() {
        if (timer == null) {
            timer = new Timer.Timer();
        }
        var current_timeout = getTimeout();
        if (current_timeout >= timeoutThreshold) {
            timer.start(self.method(:timerCallback), getTimeout(), false);
        } else {
            Application.getApp().incrCurrentStateItem(Constants.STATE_KEY_HAPPY, successLaps, Constants.MAX_HAPPY);
            Application.getApp().incrCurrentStateItem(Constants.STATE_KEY_XP, successLaps, null);
            stopped = true;
        }
    }

    function stopTimer() {
        timer.stop();
    }

    function timerCallback() {
        registerLap(false);
        resetCurrentDirection();
    }

    function getCurrentDirection() {
        if (current_direction == null) {
            resetCurrentDirection();
        }
        return current_direction;
    }

    function resetCurrentDirection() {
        if (!stopped) {
            stopTimer();
            current_direction = directions[Math.rand() % directions.size()];
            startTimer();
            WatchUi.requestUpdate();
            colorSwitch = !colorSwitch;
        }
    }

    function registerLap(result) {
        if (stopped) {
            return;
        }

        if (result) {
            successLaps += 1;
            lastAttemptSuccessful = true;
        } else {
            failedLaps += 1;
            lastAttemptSuccessful = false;
        }
        laps += 1;
    }

    function drawGame(dc) {
        var directionText = getCurrentDirection();
        var font = Graphics.FONT_MEDIUM;
        var directionTextX = dc.getWidth() / 2;
        var directionTextY = dc.getHeight() / 2 - dc.getFontHeight(font) / 2;

        if (colorSwitch) {
            dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
        } else {
            dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLACK);
        }

        dc.drawText(directionTextX, directionTextY, font, directionText, Graphics.TEXT_JUSTIFY_CENTER );
    }
}


class SwipeGameView extends WatchUi.View {
    var commons;

    function initialize() {
        View.initialize();
        commons = new SwipeGameCommons();
    }
    // Load your resources here
    function onLayout(dc) {
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
        commons.startTimer();
    }

    // Update the view
    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
        dc.clear();

        if (!commons.stopped) {
            commons.drawGame(dc);
        } else {
            var font = Graphics.FONT_MEDIUM;
            var fontHeight = dc.getFontHeight(font);
            var textX = dc.getWidth() / 2;
            var textY = dc.getHeight() / 2;
            var resultText = "Congratulations!";
            dc.drawText(textX, textY - 2 * fontHeight, font, resultText, Graphics.TEXT_JUSTIFY_CENTER );
            resultText = "total laps: " + commons.laps;
            dc.drawText(textX, textY - 1 * fontHeight, font, resultText, Graphics.TEXT_JUSTIFY_CENTER );
            resultText = "successful laps: " + commons.successLaps;
            dc.drawText(textX, textY, font, resultText, Graphics.TEXT_JUSTIFY_CENTER );
            resultText = "failed laps: " + commons.failedLaps;
            dc.drawText(textX, textY + 1 * fontHeight, font, resultText, Graphics.TEXT_JUSTIFY_CENTER );
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
        commons.laps = 0;
        commons.successLaps = 0;
        commons.failedLaps = 0;
        commons.stopped = false;
        commons.timer.stop();
    }

}
