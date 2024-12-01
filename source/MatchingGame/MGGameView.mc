using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Math;
using Toybox.Graphics;
using Toybox.Timer;
using Toybox.Lang;

enum {
    GAME_STATE_INIT,
    GAME_STATE_PLAYING,
    GAME_STATE_FINISHED,
    GAME_STATE_RESULTS
}

class MatchingGameCommons {
    var matched, failed;
    var selectedPosition;

    var timer, finishTimer;
    var gameState;
    var finishTimeout = 30000;
    var timeout = 3000;
    var timeoutStarted = 5000;

    var bitmaps, positions, pairs, hideDetails, pairsMatched;

    var numPairs = 10;

    function initialize() {
        matched = 0;
        failed = 0;
        selectedPosition = null;
        gameState = GAME_STATE_INIT;

        timer = new Timer.Timer();
        finishTimer = new Timer.Timer();

        bitmaps = new [numPairs / 2];
        pairs = new [numPairs];
        pairsMatched = new [numPairs];

        for (var i = 0; i < numPairs; i++) {
            pairsMatched[i] = false;
        }

        for(var i = 0; i < numPairs / 2; i++) {
            initializePair(i);
        }
    }

    function initializePair(bitmapId) {
        // first position
        var position = findPosition();
        pairs[position] = bitmapId;
        // second position
        position = findPosition();
        pairs[position] = bitmapId;
    }

    function findPosition() {
        var position;
        do {
            position = Math.rand() % numPairs;
        }
        while (pairs[position] != null);
        return position;
    }

    function startTimer() {
        if (gameState == GAME_STATE_INIT) {
            timer.start(self.method(:timerCallback), timeoutStarted, false);
        } else {
            timer.start(self.method(:timerCallback), timeout, false);
        }
    }

    function timerCallback() {
        if (gameState == GAME_STATE_INIT) {
            gameState = GAME_STATE_PLAYING;
        }
        if (gameState == GAME_STATE_PLAYING && selectedPosition != null) {
            selectedPosition = null;
            failed++;
        }
        if (gameState == GAME_STATE_FINISHED) {
            gameState = GAME_STATE_RESULTS;
        }
        WatchUi.requestUpdate();
        if (gameState != GAME_STATE_RESULTS) {
            startTimer();
        }
    }

    function startFinishTimer() {
        finishTimer.start(self.method(:finishTimerCallback), finishTimeout, false);
    }

    function finishTimerCallback() {
        gameState = GAME_STATE_RESULTS;
        timer.stop();
        finishTimer.stop();
        Application.getApp().incrCurrentStateItem(Constants.STATE_KEY_HAPPY, matched * 2, Constants.MAX_HAPPY);
        Application.getApp().incrCurrentStateItem(Constants.STATE_KEY_XP, matched * 10, null);
        WatchUi.requestUpdate();
    }

    function loadResources() {
        positions = WatchUi.loadResource(Rez.JsonData.mgPositions);
        hideDetails = WatchUi.loadResource(Rez.JsonData.mgHideDetails);

        bitmaps[0] = new WatchUi.Bitmap({:rezId=>Rez.Drawables.mole});
        bitmaps[1] = new WatchUi.Bitmap({:rezId=>Rez.Drawables.cake});
        bitmaps[2] = new WatchUi.Bitmap({:rezId=>Rez.Drawables.scooter});
        bitmaps[3] = new WatchUi.Bitmap({:rezId=>Rez.Drawables.full_heart});
        bitmaps[4] = new WatchUi.Bitmap({:rezId=>Rez.Drawables.broken_heart});
    }

    function drawGame(dc) {
        dc.setColor(Graphics.COLOR_ORANGE, Graphics.COLOR_BLACK);
        dc.clear();

        for (var i = 0; i < numPairs; i++) {
            var position = positions[i];
            var bitmap = bitmaps[pairs[i]];
            if (gameState == GAME_STATE_INIT || gameState == GAME_STATE_FINISHED || selectedPosition == i || pairsMatched[i] == true) {
                bitmap.setLocation(position[0], position[1]);
                bitmap.draw(dc);
            } else {
                dc.fillCircle(position[0] + hideDetails[0], position[1] + hideDetails[1], hideDetails[2]);
            }
        }
    }

    function selectPosition(position) {
        if (selectedPosition == null) {
            selectedPosition = position;
            startTimer();
        } else {
            if (pairs[selectedPosition] == pairs[position]) {
                matched++;
                pairsMatched[selectedPosition] = true;
                pairsMatched[position] = true;
            } else {
                failed++;
            }
            selectedPosition = null;
        }
        if (matched + failed == numPairs / 2) {
            gameState = GAME_STATE_FINISHED;
            startTimer();
            Application.getApp().incrCurrentStateItem(Constants.STATE_KEY_HAPPY, matched * 5, Constants.MAX_HAPPY);
            Application.getApp().incrCurrentStateItem(Constants.STATE_KEY_XP, matched * 10, null);
        }
        WatchUi.requestUpdate();
    }
}

class MatchingGameView extends WatchUi.View {
    var commons;
    function initialize() {
        View.initialize();
        commons = new MatchingGameCommons();
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
        if (commons.gameState != GAME_STATE_RESULTS) {
            commons.drawGame(dc);
        } else {
            var font = Graphics.FONT_MEDIUM;
            var fontHeight = dc.getFontHeight(font);
            var textX = dc.getWidth() / 2;
            var textY = dc.getHeight() / 2;
            var resultText = "Congratulations!";
            dc.drawText(textX, textY - fontHeight, font, resultText, Graphics.TEXT_JUSTIFY_CENTER );
            resultText = "matches: " + commons.matched;
            dc.drawText(textX, textY, font, resultText, Graphics.TEXT_JUSTIFY_CENTER );
            resultText = "misses: " + commons.failed;
            dc.drawText(textX, textY + fontHeight, font, resultText, Graphics.TEXT_JUSTIFY_CENTER );
        }
    }

    function onHide() {
        commons.timer.stop();
        commons.finishTimer.stop();
    }
}