using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Math;
using Toybox.Graphics;


class MonkyView extends WatchUi.View {

    // indicators
    var heartBitmaps, activitiesBitmap, foodBitmap;
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

        System.println("Screen width " + dc.getWidth() + " height " + dc.getHeight());
        var maxWidth = dc.getWidth();
        var maxHeight = dc.getHeight();
        heartBitmaps[heartId].setLocation(40, maxWidth / 4);
        heartBitmaps[heartId].draw(dc);

        foodBitmap.setLocation(maxWidth / 2 - foodBitmap.width / 2, 30);
        foodBitmap.draw(dc);

        activitiesBitmap.setLocation(maxWidth - 40 - activitiesBitmap.width, maxWidth / 4 - foodBitmap.width / 2);
        activitiesBitmap.draw(dc);
    }

    // Update the view
    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
        dc.clear();

        drawIndicators(dc);
        characterRepr.animate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
        characterRepr.stopAnimationTimer();
    }
}
