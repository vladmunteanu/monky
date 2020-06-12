using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Math;
using Toybox.Graphics;
using Toybox.Timer;
using Toybox.Lang;

class SimonGameCommons {
    var margin = 5;

    var minMoves = 3;
    var currentLevel;
    var moves;
    var currentMove;

    var timeBetweenLevels = 1500;
    var timeBetweenAnimations = 500;
    var stopped, paused;

    var timer;

    var simonsTurn = true;

    var maxX, maxY;

    function initialize() {
        currentLevel = 0;
        stopped = false;
        paused = false;
        timer = new Timer.Timer();
    }

    function drawGame(dc) {
        maxX = dc.getWidth();
        maxY = dc.getHeight();
        // clear screen
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.fillRectangle(0, 0, maxX, maxY);

        var upperLeftColor = Graphics.COLOR_RED;
        var lowerLeftColor = Graphics.COLOR_BLUE;
        var upperRightColor = Graphics.COLOR_GREEN;
        var lowerRightColor = Graphics.COLOR_YELLOW;

        if (simonsTurn && currentMove != null && !paused) {
            var hitColor = Graphics.COLOR_WHITE;
            var hitZone = moves[currentMove];
            if (hitZone == 0) {
                upperLeftColor = hitColor;
            } else if (hitZone == 1) {
                lowerLeftColor = hitColor;
            } else if (hitZone == 2) {
                upperRightColor = hitColor;
            } else if (hitZone == 3) {
                lowerRightColor = hitColor;
            }
        }

        // upper left
        dc.setColor(upperLeftColor, Graphics.COLOR_BLACK);
        dc.fillRectangle(0, 0, maxX / 2 - margin, maxY / 2 - margin);
        // lower left
        dc.setColor(lowerLeftColor, Graphics.COLOR_BLACK);
        dc.fillRectangle(0, maxY / 2 + margin, maxX / 2 - margin, maxY);
        // upper right
        dc.setColor(upperRightColor, Graphics.COLOR_BLACK);
        dc.fillRectangle(maxX / 2 + margin, 0, maxX, maxY / 2 - margin);
        // lower right
        dc.setColor(lowerRightColor, Graphics.COLOR_BLACK);
        dc.fillRectangle(maxX / 2 + margin, maxY / 2 + margin, maxX, maxY);
        // middle circle
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.fillCircle(maxX / 2, maxY / 2, 20);
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawText(maxX / 2, maxY / 2 - Graphics.getFontHeight(Graphics.FONT_SMALL) / 2, Graphics.FONT_SMALL, currentLevel, Graphics.TEXT_JUSTIFY_CENTER);
    }

    function startGame() {
        timer.start(self.method(:startLevel), timeBetweenLevels, false);
    }

    function stopGame() {
        currentLevel = 0;
        timer.stop();
    }

    function registerTap(tapX, tapY) {
        if (!stopped && !simonsTurn) {
            var correctHitZone = moves[currentMove];
            var hitZonesBoundaries = {
                0 => [[0, 0],                                   [maxX / 2 - margin, maxY / 2 - margin]],
                1 => [[0, maxY / 2 + margin],                   [maxX / 2 - margin, maxY]],
                2 => [[maxX / 2 + margin, 0],                   [maxX, maxY / 2 - margin]],
                3 => [[maxX / 2 + margin, maxY / 2 + margin],   [maxX, maxY]],
            };
            var boundaries = hitZonesBoundaries.get(correctHitZone);
            if (tapX >= boundaries[0][0] && tapY >= boundaries[0][1] && tapX <= boundaries[1][0] && tapY <= boundaries[1][1]) {
                currentMove += 1;
                if (currentMove == moves.size()) {
                    simonsTurn = true;
                    currentMove = 0;
                    paused = true;
                    currentLevel += 1;
                    timer.start(self.method(:startLevel), timeBetweenLevels, false);
                }
                WatchUi.requestUpdate();
            }
            else {
                stopped = true;
                Application.getApp().incrCurrentStateItem(Constants.STATE_KEY_HAPPY, currentLevel * 5, Constants.MAX_HAPPY);
                Application.getApp().incrCurrentStateItem(Constants.STATE_KEY_XP, currentLevel * 10, null);
                WatchUi.requestUpdate();
            }

        }
    }

    function startLevel() {
        simonsTurn = true;
        paused = false;
        var numMoves = currentLevel + minMoves;
        moves = new [numMoves];
        for (var i = 0; i < numMoves; i++) {
            moves[i] = Math.rand() % 4;
        }
        currentMove = 0;
        WatchUi.requestUpdate();
        timer.start(self.method(:timerCallback), timeBetweenAnimations, true);
    }

    function timerCallback() {
        paused = !paused;
        if (!paused) {
            currentMove += 1;
            if (currentMove == moves.size()) {
                simonsTurn = false;
                timer.stop();
                currentMove = 0;
            }
        }
        WatchUi.requestUpdate();
    }
}



class SimonGameView extends WatchUi.View {

    var commons;
    function initialize() {
        View.initialize();
        commons = new SimonGameCommons();
    }

    function onLayout(dc) {
    }

    function onShow() {
        commons.startGame();
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        if (!commons.stopped) {
            commons.drawGame(dc);
        } else {
            dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
            var font = Graphics.FONT_MEDIUM;
            var fontHeight = dc.getFontHeight(font);
            var textX = dc.getWidth() / 2;
            var textY = dc.getHeight() / 2;
            var resultText = "Game Over!";
            dc.drawText(textX, textY - 2 * fontHeight, font, resultText, Graphics.TEXT_JUSTIFY_CENTER );
            resultText = "level reached: " + commons.currentLevel;
            dc.drawText(textX, textY - 1 * fontHeight, font, resultText, Graphics.TEXT_JUSTIFY_CENTER );
        }
    }

    function onHide() {
        commons.stopGame();
    }

}