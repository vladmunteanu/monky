using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Math;
using Toybox.Graphics;
using Toybox.Timer;
using Toybox.Lang;


class WAMGameCommons {
    var moleBitmap, backdrop, holeCoordinates, holeDimensions, moleOffsets;

    var currentPosition;

    var laps, successLaps, failedLaps;
    var stopped;

    var timer, finishTimer;
    var timeBetweenMoles = 300;
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

    function timerCallback() {
        registerLap(false);
        timer.start(self.method(:betweenRendersTimerCallback), timeBetweenMoles, false);
    }

    function betweenRendersTimerCallback() {
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
        timer.stop();

        laps += 1;
        currentPosition = -1;
        WatchUi.requestUpdate();
        timer.start(self.method(:betweenRendersTimerCallback), timeBetweenMoles, false);
    }

    function loadResources() {
        moleBitmap = new WatchUi.Bitmap({:rezId=>Rez.Drawables.mole});
        backdrop = new Rez.Drawables.wam_backdrop();
        holeCoordinates = WatchUi.loadResource(Rez.JsonData.wamHoles);
        holeDimensions = WatchUi.loadResource(Rez.JsonData.wamHolesDimensions);
        moleOffsets = WatchUi.loadResource(Rez.JsonData.wamMoleOffsets);
        currentPosition = Math.rand() % holeCoordinates.size();
    }

    function drawGame(dc) {
        backdrop.draw(dc);

        // paint the mole holes
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        for (var i = 0; i < holeCoordinates.size(); i++) {
            var currentCoordinates = holeCoordinates[i];
            if (i == currentPosition) {
                moleBitmap.setLocation(currentCoordinates[0] + moleOffsets[0], currentCoordinates[1] + moleOffsets[1]);
                moleBitmap.draw(dc);
            } else {
                dc.fillEllipse(currentCoordinates[0], currentCoordinates[1], holeDimensions[0], holeDimensions[1]);
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
