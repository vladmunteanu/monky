using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Math;
using Toybox.Graphics;
using Toybox.Timer;
using Toybox.Lang;


class BubbleBathView extends WatchUi.View {

    var bathTubBitmap, monkyBitmap, animationHeight;
    var animationStep;
    var animationTimer;
    var startTime;
    var totalAnimationSteps;
    var animationFrequency = 300;

    var wallColor = Graphics.COLOR_YELLOW;
    var floorColor = Graphics.COLOR_BLACK;
    var bubbleOuterColor = Graphics.COLOR_DK_BLUE;
    var bubbleInnerColor = Graphics.COLOR_BLUE;

    var minRewardTimeSpent = 3; // seconds

    function initialize() {
        View.initialize();
        animationStep = 0;
        totalAnimationSteps = 0;
        animationTimer = new Timer.Timer();
    }

    function onLayout(dc) {
        bathTubBitmap = new WatchUi.Bitmap({:rezId=>Rez.Drawables.bath_tub});
        monkyBitmap = new WatchUi.Bitmap({:rezId=>Rez.Drawables.monky1});
        animationHeight = WatchUi.loadResource(Rez.JsonData.bathAnimationHeight);
    }

    function onShow() {
        animationTimer.start(self.method(:timerCallback), animationFrequency, true);
        startTime = System.getTimer();
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        var maxX = dc.getWidth();
        var maxY = dc.getHeight();

        // paint the wall
        dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_BLACK);
        dc.fillRectangle(0, 0, maxX, maxY);

        // paint Monky in the bath tub
        monkyBitmap.setLocation(maxX / 2 - monkyBitmap.width, maxY / 2 - monkyBitmap.height / 2 - monkyBitmap.height / 4.5);
        monkyBitmap.draw(dc);

        // paint the floor
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.fillRectangle(0, maxY / 2 + bathTubBitmap.height / 4, maxX, maxY);

        // paint bubbles
        drawBubble(dc, maxX / 2, maxY / 2, 10);
        drawBubble(dc, maxX / 2 + 20, maxY / 2 - 5, 6);
        drawBubble(dc, maxX / 2 + 35, maxY / 2 + 5, 8);

        // paint the bath tub
        bathTubBitmap.setLocation(maxX / 2 - bathTubBitmap.width / 2, maxY / 2 - bathTubBitmap.height / 2);
        bathTubBitmap.draw(dc);
    }

    function onHide() {
        animationTimer.stop();
        var timeSpent = Math.floor((System.getTimer() - startTime) / 1000);
        Application.getApp().incrCurrentStateItem(Constants.STATE_KEY_CLEAN, timeSpent, Constants.MAX_CLEAN);
        if (timeSpent >= minRewardTimeSpent) {
            Application.getApp().incrCurrentStateItem(Constants.STATE_KEY_HAPPY, 5, Constants.MAX_HAPPY);
            Application.getApp().incrCurrentStateItem(Constants.STATE_KEY_XP, 10, null);
        }
    }

    function timerCallback() {
        animationStep += 1;
        if (animationStep >= 15) {
            animationStep = 0;
            totalAnimationSteps += 1;
            if (totalAnimationSteps >= 3) {
                finishBath();
            }
        }
        WatchUi.requestUpdate();
    }

    function drawBubble(dc, x, y, initialRadius) {
        var bubbleXOffset = (Math.rand() % 3) * (animationStep % 5);
        if (animationStep % 2 == 0) {
            bubbleXOffset = bubbleXOffset * (-1);
        }
        var bubbleYOffset = animationHeight * animationStep - Math.rand() % 10;
        var bubbleX = x + bubbleXOffset;
        var bubbleY = y - bubbleYOffset;

        dc.setColor(bubbleOuterColor, Graphics.COLOR_DK_BLUE);
        dc.fillCircle(bubbleX, bubbleY, initialRadius);
        dc.setColor(bubbleInnerColor, Graphics.COLOR_DK_BLUE);
        dc.fillCircle(bubbleX, bubbleY, initialRadius - 2);
        dc.setColor(wallColor, Graphics.COLOR_DK_BLUE);
        dc.fillCircle(bubbleX - 2, bubbleY - 2, 2);
    }

    function finishBath() {
        animationTimer.stop();
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
    }

}
