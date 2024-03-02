using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Math;
using Toybox.Graphics;


class MonkyView extends WatchUi.View {

    // indicators
    var heartBitmaps, activitiesBitmap, foodBitmap, heartIconPosition, foodIconPosition, activitiesIconPosition;
    var heartId;

    var font = Graphics.FONT_TINY;
    var lineSpacing = Graphics.getFontHeight(font);

    var characterRepr;

    function initialize() {
        View.initialize();

        characterRepr = new GameCharacterRepresentation();
        heartId = 1;
    }

    // Load your resources here
    function onLayout(dc) {
        // load the character resources
        characterRepr.loadResources(dc);

        // load the full heart and broken heart bitmaps
        if (heartBitmaps == null) {
            heartBitmaps = new [2];
            heartBitmaps[0] = new WatchUi.Bitmap({:rezId=>Rez.Drawables.full_heart});
            heartBitmaps[1] = new WatchUi.Bitmap({:rezId=>Rez.Drawables.broken_heart});
        }

        activitiesBitmap = new WatchUi.Bitmap({:rezId=>Rez.Drawables.scooter});
        foodBitmap = new WatchUi.Bitmap({:rezId=>Rez.Drawables.cake});
        // icon positions
        heartIconPosition = WatchUi.loadResource(Rez.JsonData.heartIconPosition);
        foodIconPosition = WatchUi.loadResource(Rez.JsonData.foodIconPosition);
        activitiesIconPosition = WatchUi.loadResource(Rez.JsonData.activitiesIconPosition);
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
        characterRepr.startAnimationTimer();
    }

    function drawIndicators(dc) {
        var currentState = Application.getApp().currentState;
        var isHealthy = (currentState.get(Constants.STATE_KEY_HEALTH) > 50);
        var isFit = (currentState.get(Constants.STATE_KEY_FIT) > 50);
        var isHappy = (currentState.get(Constants.STATE_KEY_HAPPY) > 50);
        var isClean = (currentState.get(Constants.STATE_KEY_CLEAN) > 50);

        if (isHealthy && isFit && isHappy && isClean) {
            heartId = 0;
        }
        else {
            heartId = 1;
        }

        heartBitmaps[heartId].setLocation(heartIconPosition[0], heartIconPosition[1]);
        heartBitmaps[heartId].draw(dc);

        foodBitmap.setLocation(foodIconPosition[0], foodIconPosition[1]);
        foodBitmap.draw(dc);

        activitiesBitmap.setLocation(activitiesIconPosition[0], activitiesIconPosition[1]);
        activitiesBitmap.draw(dc);
    }

    // Update the view
    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
        dc.clear();

        drawIndicators(dc);
        characterRepr.animate(dc);
    }

    function onHide() {
        characterRepr.stopAnimation();
    }
}
