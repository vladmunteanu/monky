using Toybox.WatchUi;
using Toybox.System;
using Toybox.Math;

const NUM_IMAGES = 12;
const FRONT_DIRECTION = 0; // 1, 2, 3
const LEFT_DIRECTION = 1; // 4,5, 6
const RIGHT_DIRECTION = 2;  // 7, 8, 9
const BACK_DIRECTION = 3;  // 10, 11, 12

const OUTSIDE_X = -50;
const OUTSIDE_Y = -50;

const MAX_REPETITIONS = 3;

const ANIMATION_SPEED = 300;


class PlayfulWidgetView extends WatchUi.View {

	var monky_bitmaps;
	var current_position;
	var update_timer;
	var repetitions;
	
	var xPos;
	var yPos;
	
    function initialize() {
        View.initialize();

        monky_bitmaps = new [NUM_IMAGES];
        monky_bitmaps[0] = new WatchUi.Bitmap({:rezId=>Rez.Drawables.monky1,:locX=>OUTSIDE_X,:locY=>OUTSIDE_Y});
        monky_bitmaps[1] = new WatchUi.Bitmap({:rezId=>Rez.Drawables.monky2,:locX=>OUTSIDE_X,:locY=>OUTSIDE_Y});
        monky_bitmaps[2] = new WatchUi.Bitmap({:rezId=>Rez.Drawables.monky3,:locX=>OUTSIDE_X,:locY=>OUTSIDE_Y});
        monky_bitmaps[3] = new WatchUi.Bitmap({:rezId=>Rez.Drawables.monky4,:locX=>OUTSIDE_X,:locY=>OUTSIDE_Y});
        monky_bitmaps[4] = new WatchUi.Bitmap({:rezId=>Rez.Drawables.monky5,:locX=>OUTSIDE_X,:locY=>OUTSIDE_Y});
        monky_bitmaps[5] = new WatchUi.Bitmap({:rezId=>Rez.Drawables.monky6,:locX=>OUTSIDE_X,:locY=>OUTSIDE_Y});
        monky_bitmaps[6] = new WatchUi.Bitmap({:rezId=>Rez.Drawables.monky7,:locX=>OUTSIDE_X,:locY=>OUTSIDE_Y});
        monky_bitmaps[7] = new WatchUi.Bitmap({:rezId=>Rez.Drawables.monky8,:locX=>OUTSIDE_X,:locY=>OUTSIDE_Y});
        monky_bitmaps[8] = new WatchUi.Bitmap({:rezId=>Rez.Drawables.monky9,:locX=>OUTSIDE_X,:locY=>OUTSIDE_Y});
        monky_bitmaps[9] = new WatchUi.Bitmap({:rezId=>Rez.Drawables.monky10,:locX=>OUTSIDE_X,:locY=>OUTSIDE_Y});
        monky_bitmaps[10] = new WatchUi.Bitmap({:rezId=>Rez.Drawables.monky11,:locX=>OUTSIDE_X,:locY=>OUTSIDE_Y});
        monky_bitmaps[11] = new WatchUi.Bitmap({:rezId=>Rez.Drawables.monky12,:locX=>OUTSIDE_X,:locY=>OUTSIDE_Y});
        
        current_position = 0;
        repetitions = 0;
        
        update_timer = new Timer.Timer();
    }
    
    function startAnimationTimer() {
    	repetitions = 0;
    	update_timer.start(self.method(:timerCallback), ANIMATION_SPEED, true);
    }

    // Load your resources here
    function onLayout(dc) {
    	startAnimationTimer();
        xPos = dc.getWidth() / 2;
        yPos = dc.getHeight() / 2;
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

	function timerCallback() {
    	WatchUi.requestUpdate();
	}
	
	function animateCharacter(dc) {
        // draw current
        var current_direction = 0;
        var current_offset = 0;
        if (current_position > 0) {
        	current_direction = Math.floor(current_position / 3);
        	current_offset = current_position % 3;
        } 
        if (current_direction == LEFT_DIRECTION) {
        	xPos = xPos - (current_offset * 10);
        }
        else if (current_direction == RIGHT_DIRECTION) {
        	xPos = xPos + (current_offset * 10);
        }
        monky_bitmaps[current_position].setLocation(xPos, yPos);
        monky_bitmaps[current_position].draw(dc);
	}

    // Update the view
    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
        dc.clear();
        
        if (current_position >= NUM_IMAGES) {
        	current_position = 0;
        	repetitions += 1;
        	if (repetitions == MAX_REPETITIONS) {
        		update_timer.stop();
        		var restart_timer = new Timer.Timer();
        		restart_timer.start(self.method(:startAnimationTimer), 5000, false);
        	}
        }

        animateCharacter(dc);
        
        // increment position for next call
        current_position += 1;
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

}
