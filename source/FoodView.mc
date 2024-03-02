
using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Math;
using Toybox.Graphics;
using Toybox.Timer;
using Toybox.Lang;

class FoodView extends WatchUi.View {
    var timer, currentProgress, foodType, foodBitmap;

    function initialize(ft) {
        View.initialize();
        foodType = ft;
        timer = new Timer.Timer();
        currentProgress = 0;
    }

    function onLayout(dc) {
        if (foodType.equals(Constants.FOOD_VEGETABLES)) {
            // load a veggie bitmap, randomly
            var veggie = Math.rand() % 3;
            if (veggie == 0) {
                foodBitmap = new WatchUi.Bitmap({:rezId=>Rez.Drawables.food_veggie1});
            } else if (veggie == 1) {
                foodBitmap = new WatchUi.Bitmap({:rezId=>Rez.Drawables.food_veggie2});
            } else {
                foodBitmap = new WatchUi.Bitmap({:rezId=>Rez.Drawables.food_veggie3});
            }
        } else if (foodType.equals(Constants.FOOD_STEAK)) {
            foodBitmap = new WatchUi.Bitmap({:rezId=>Rez.Drawables.food_steak});
        } else if (foodType.equals(Constants.FOOD_CAKE)) {
            foodBitmap = new WatchUi.Bitmap({:rezId=>Rez.Drawables.food_cake});
        } else {
            foodBitmap = new WatchUi.Bitmap({:rezId=>Rez.Drawables.food_pizza});
        }
    }

    function onShow() {
        startTimer();
    }

    function startTimer() {
        timer.start(self.method(:timerCallback), 1000, true);
    }

    function timerCallback() {
        currentProgress += 25;
        if (currentProgress > 100) {
            timer.stop();
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        }
        WatchUi.requestUpdate();
        startTimer();
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        var maxHeight = dc.getHeight();
        var maxWidth = dc.getWidth();
        var bitmapSize = [foodBitmap.width, foodBitmap.height];

        if (currentProgress == 0) {
            dc.clear();
            foodBitmap.setLocation(maxWidth / 2 - bitmapSize[0] / 2, maxHeight / 2 - bitmapSize[1] / 2);
            foodBitmap.draw(dc);
        }
        if (currentProgress == 25) {
            dc.fillCircle(maxWidth / 2 - bitmapSize[0] / 4, maxHeight / 2 + bitmapSize[1] / 4, bitmapSize[1] / 3.5);
        } else if (currentProgress == 50) {
            dc.fillCircle(maxWidth / 2 + bitmapSize[0] / 4, maxHeight / 2 - bitmapSize[1] / 4, bitmapSize[1] / 3);
        } else if (currentProgress == 75) {
            dc.fillCircle(maxWidth / 2 + bitmapSize[0] / 4, maxHeight / 2 + bitmapSize[1] / 4, bitmapSize[1] / 2);
        } else if (currentProgress == 100) {
            dc.fillCircle(maxWidth / 2 - bitmapSize[0] / 4, maxHeight / 2 - bitmapSize[1] / 4, bitmapSize[1]);
        }
    }

    function onHide() {
        timer.stop();
    }
}
