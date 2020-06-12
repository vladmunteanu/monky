using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Math;
using Toybox.Graphics;
using Toybox.Timer;
using Toybox.Lang;

const WAM_NUM_HOLES = 12;


class WAMGameCommons {
    var moleOffsetX = -13;
    var moleOffsetY = -12;

    var moleBitmap, backdrop, holeCoordinates;

    var currentPosition;

    var laps, successLaps, failedLaps;
    var stopped;

    var timer, finishTimer;
    var timeout = 1000;
    var finishTimeout = 15000;

    function initialize() {
        timer = new Timer.Timer();
        finishTimer = new Timer.Timer();
        laps = 0;
        successLaps = 0;
        failedLaps = 0;
        stopped = false;
    }

    function startFinishTimer() {
        finishTimer.start(self.method(:finishTimerCallback), finishTimeout, false);
    }

    function finishTimerCallback() {
        stopped = true;
        timer.stop();
        Application.getApp().incrCurrentStateItem(Constants.STATE_KEY_HAPPY, successLaps, Constants.MAX_HAPPY);
        Application.getApp().incrCurrentStateItem(Constants.STATE_KEY_XP, successLaps, null);
        WatchUi.requestUpdate();
    }

    function startTimer() {
        timer.start(self.method(:timerCallback), timeout, false);
    }

    function stopTimer() {
        timer.stop();
    }

    function timerCallback() {
        registerLap(false);
        resetPosition();
    }

    function getPosition() {
        if (currentPosition == null) {
            resetPosition();
        }
        return currentPosition;
    }

    function resetPosition() {
        if (!stopped) {
            stopTimer();
            currentPosition = Math.rand() % holeCoordinates.size();
            startTimer();
            WatchUi.requestUpdate();
        }
    }

    function registerLap(result) {
        if (stopped) {
            return;
        }
        if (result) {
            successLaps += 1;
        } else {
            failedLaps += 1;
        }
        laps += 1;
    }

    function loadResources() {
        moleBitmap = new WatchUi.Bitmap({:rezId=>Rez.Drawables.mole});
        backdrop = new Rez.Drawables.backdrop();
        holeCoordinates = WatchUi.loadResource(Rez.JsonData.wamHoles);
        System.println(holeCoordinates);
    }

    function drawGame(dc) {
        backdrop.draw(dc);

        // paint the mole holes
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        for (var i = 0; i < holeCoordinates.size(); i++) {
            var currentCoordinates = holeCoordinates[i];
            if (i == currentPosition) {
                moleBitmap.setLocation(currentCoordinates[0] + moleOffsetX, currentCoordinates[1] + moleOffsetY);
                moleBitmap.draw(dc);
            } else {
                dc.fillEllipse(currentCoordinates[0], currentCoordinates[1], 15, 10);
            }
        }
    }
}


class WAMGameView extends WatchUi.View {

    var commons;
    function initialize() {
        View.initialize();
        commons = new WAMGameCommons();
    }

    function onLayout(dc) {
        commons.loadResources();
    }

    function onShow() {
        // start mole timer
        commons.startTimer();
        commons.startFinishTimer();
    }

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
            resultText = "total: " + commons.laps;
            dc.drawText(textX, textY - 1 * fontHeight, font, resultText, Graphics.TEXT_JUSTIFY_CENTER );
            resultText = "whacked: " + commons.successLaps;
            dc.drawText(textX, textY, font, resultText, Graphics.TEXT_JUSTIFY_CENTER );
            resultText = "missed: " + commons.failedLaps;
            dc.drawText(textX, textY + 1 * fontHeight, font, resultText, Graphics.TEXT_JUSTIFY_CENTER );
        }
    }

    function onHide() {
        commons.laps = 0;
        commons.successLaps = 0;
        commons.failedLaps = 0;
        commons.stopped = false;
        commons.timer.stop();
        commons.finishTimer.stop();
    }

}
