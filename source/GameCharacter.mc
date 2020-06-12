using Toybox.Math;
using Toybox.WatchUi;
using Toybox.Timer;


class GameCharacterRepresentation {

    var numImages = 12;
    var frontDirection = 0; // 1, 2, 3
    var leftDirection = 1; // 4,5, 6
    var rightDirection = 2;  // 7, 8, 9
    var back_direction = 3;  // 10, 11, 12

    var repetitions, loops;
    var currentPosition;
    var initialX, xPos;
    var initialY, yPos;

    var bitmaps;
    var timer;

    function initialize() {
        bitmaps = new [numImages];

        loops = 0;
        repetitions = 0;
        currentPosition = 0;

        timer = new Timer.Timer();
    }

    function loadResources(dc) {
        bitmaps[0] = new WatchUi.Bitmap({:rezId=>Rez.Drawables.monky1});
        bitmaps[1] = new WatchUi.Bitmap({:rezId=>Rez.Drawables.monky2});
        bitmaps[2] = new WatchUi.Bitmap({:rezId=>Rez.Drawables.monky3});
        bitmaps[3] = new WatchUi.Bitmap({:rezId=>Rez.Drawables.monky4});
        bitmaps[4] = new WatchUi.Bitmap({:rezId=>Rez.Drawables.monky5});
        bitmaps[5] = new WatchUi.Bitmap({:rezId=>Rez.Drawables.monky6});
        bitmaps[6] = new WatchUi.Bitmap({:rezId=>Rez.Drawables.monky7});
        bitmaps[7] = new WatchUi.Bitmap({:rezId=>Rez.Drawables.monky8});
        bitmaps[8] = new WatchUi.Bitmap({:rezId=>Rez.Drawables.monky9});
        bitmaps[9] = new WatchUi.Bitmap({:rezId=>Rez.Drawables.monky10});
        bitmaps[10] = new WatchUi.Bitmap({:rezId=>Rez.Drawables.monky11});
        bitmaps[11] = new WatchUi.Bitmap({:rezId=>Rez.Drawables.monky12});

        initialX = dc.getWidth() / 2;
        xPos = initialX;
        initialY = dc.getHeight() / 2;
        yPos = initialY;
    }

    function startAnimationTimer() {
        timer.start(self.method(:timerCallback), Constants.ANIMATION_SPEED, true);
    }

    function stopAnimation() {
        loops = 0;
        repetitions = 0;
        currentPosition = 0;
        xPos = initialX;
        yPos = initialY;
        timer.stop();
    }

    function timerCallback() {
        WatchUi.requestUpdate();
    }

    function animate(dc) {
        // draw current
        if (currentPosition >= numImages) {
            currentPosition = 0;
            repetitions += 1;
            if (repetitions == Constants.MAX_ANIMATION_REPETITIONS) {
                repetitions = 0;
                loops += 1;
                timer.stop();
                if (loops <= Constants.MAX_ANIMATION_REPETITIONS) {
                    timer.start(self.method(:startAnimationTimer), Constants.ANIMATION_PAUSE, false);
                }
            }
        }

        var currentDirection = 0;
        var currentOffset = 0;
        if (currentPosition > 0) {
            currentDirection = Math.floor(currentPosition / 3);
            currentOffset = currentPosition % 3;
        }
        if (currentDirection == leftDirection) {
            xPos = xPos - (currentOffset * 10);
        }
        else if (currentDirection == rightDirection) {
            xPos = xPos + (currentOffset * 10);
        }
        bitmaps[currentPosition].setLocation(xPos, yPos);
        bitmaps[currentPosition].draw(dc);

        // increment position for next call
        currentPosition += 1;
    }
}