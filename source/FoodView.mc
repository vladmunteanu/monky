
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
        startTimer(1000);
    }

    function startTimer(timerDuration) {
        timer.start(self.method(:timerCallback), timerDuration, true);
    }

    function timerCallback() {
        currentProgress += 25;
        if (currentProgress > 125) {
            timer.stop();
            WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
            return;
        }
        WatchUi.requestUpdate();
        var td = 1000;
        if (currentProgress == 100) {
            td = 500;
        }
        startTimer(td);
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        var maxHeight = dc.getHeight();
        var maxWidth = dc.getWidth();
        var bitmapSize = [foodBitmap.width, foodBitmap.height];

        foodBitmap.setLocation(maxWidth / 2 - bitmapSize[0] / 2, maxHeight / 2 - bitmapSize[1] / 2);
        foodBitmap.draw(dc);
        if (currentProgress >= 25) {
            dc.fillCircle(maxWidth / 2 - bitmapSize[0] / 4 - 5, maxHeight / 2 + bitmapSize[1] / 4 + 5, bitmapSize[1] / 3.5);
        }
        if (currentProgress >= 50) {
            dc.fillCircle(maxWidth / 2 + bitmapSize[0] / 4, maxHeight / 2 - bitmapSize[1] / 4, bitmapSize[1] / 3);
        }
        if (currentProgress >= 75) {
            dc.fillCircle(maxWidth / 2 + bitmapSize[0] / 4, maxHeight / 2 + bitmapSize[1] / 4, bitmapSize[1] / 2);
        }
        if (currentProgress >= 100) {
            dc.fillCircle(maxWidth / 2 - bitmapSize[0] / 4, maxHeight / 2 - bitmapSize[1] / 4, bitmapSize[1]);
        }
        if (currentProgress >= 125) {
            dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
            var font = Graphics.FONT_MEDIUM;
            var fontHeight = dc.getFontHeight(font);
            dc.drawText(maxWidth / 2, maxHeight / 2 - fontHeight / 2, font, "Yummy!", Graphics.TEXT_JUSTIFY_CENTER );
        }
    }

    function onHide() {
        timer.stop();
    }
}
