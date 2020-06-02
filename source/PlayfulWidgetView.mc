using Toybox.WatchUi;
using Toybox.System;
using Toybox.Math;
using Toybox.Graphics;


const NUM_IMAGES = 12;
const FRONT_DIRECTION = 0; // 1, 2, 3
const LEFT_DIRECTION = 1; // 4,5, 6
const RIGHT_DIRECTION = 2;  // 7, 8, 9
const BACK_DIRECTION = 3;  // 10, 11, 12

const MAX_REPETITIONS = 3;

const ANIMATION_SPEED = 300;
const ANIMATION_PAUSE = 5000;


class PlayfulWidgetView extends WatchUi.View {

	// indicators
	var heart_bitmaps, fitLabel, notFitLabel, fitBitmap, hungryLabel, notHungryLabel, hungryBitmap;
	var hasHealth, isFit, isHungry;
	
	var monky_bitmaps;
	var current_position;
	var update_timer;
	var repetitions;
	
	var xPos;
	var yPos;
	
	var font = Graphics.FONT_TINY;
	var lineSpacing = Graphics.getFontHeight(font);
	
    function initialize() {
        View.initialize();
        System.println("initialize view 1");

        hasHealth = true;
        isFit = false;
        isHungry = true;

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
    	System.println("on layout view 1");
        xPos = dc.getWidth() / 2;
        yPos = dc.getHeight() / 2;
        
        // load the character bitmaps
        if (monky_bitmaps == null) {
			monky_bitmaps = new [NUM_IMAGES];
	        monky_bitmaps[0] = new WatchUi.Bitmap({:rezId=>Rez.Drawables.monky1});
	        monky_bitmaps[1] = new WatchUi.Bitmap({:rezId=>Rez.Drawables.monky2});
	        monky_bitmaps[2] = new WatchUi.Bitmap({:rezId=>Rez.Drawables.monky3});
	        monky_bitmaps[3] = new WatchUi.Bitmap({:rezId=>Rez.Drawables.monky4});
	        monky_bitmaps[4] = new WatchUi.Bitmap({:rezId=>Rez.Drawables.monky5});
	        monky_bitmaps[5] = new WatchUi.Bitmap({:rezId=>Rez.Drawables.monky6});
	        monky_bitmaps[6] = new WatchUi.Bitmap({:rezId=>Rez.Drawables.monky7});
	        monky_bitmaps[7] = new WatchUi.Bitmap({:rezId=>Rez.Drawables.monky8});
	        monky_bitmaps[8] = new WatchUi.Bitmap({:rezId=>Rez.Drawables.monky9});
	        monky_bitmaps[9] = new WatchUi.Bitmap({:rezId=>Rez.Drawables.monky10});
	        monky_bitmaps[10] = new WatchUi.Bitmap({:rezId=>Rez.Drawables.monky11});
	        monky_bitmaps[11] = new WatchUi.Bitmap({:rezId=>Rez.Drawables.monky12});
	    }
        
        // load the full heart and broken heart bitmaps
		if (heart_bitmaps == null) {
			heart_bitmaps = new [2];
			heart_bitmaps[0] = new WatchUi.Bitmap({:rezId=>Rez.Drawables.full_heart});
			heart_bitmaps[1] = new WatchUi.Bitmap({:rezId=>Rez.Drawables.broken_heart});
        }

		// load the text for other indicators
		if (fitLabel == null) {
			fitLabel = WatchUi.loadResource( Rez.Strings.fit );
			fitBitmap = new WatchUi.Bitmap({:rezId=>Rez.Drawables.scooter});
		}
        if (notFitLabel == null) {
        	notFitLabel = WatchUi.loadResource( Rez.Strings.not_fit );
        }
        if (hungryLabel == null) {
        	hungryLabel = WatchUi.loadResource( Rez.Strings.hungry );
        	hungryBitmap = new WatchUi.Bitmap({:rezId=>Rez.Drawables.cake});
        }
        if (notHungryLabel == null) {
        	notHungryLabel = WatchUi.loadResource( Rez.Strings.not_hungry );
        }
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    	System.println("on show view 1");
    	startAnimationTimer();
    }

	function timerCallback() {
    	WatchUi.requestUpdate();
	}
	
	function animateCharacter(dc) {
        // draw current
        if (current_position >= NUM_IMAGES) {
        	current_position = 0;
        	repetitions += 1;
        	if (repetitions == MAX_REPETITIONS) {
        		update_timer.stop();
        		var restart_timer = new Timer.Timer();
        		restart_timer.start(self.method(:startAnimationTimer), ANIMATION_PAUSE, false);
        		hasHealth = !hasHealth;
        	}
        }
        
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

        // increment position for next call
        current_position += 1;
	}
	
	function drawIndicators(dc) {
        var heart_id = 0;
        if (!hasHealth) {
        	heart_id = 1;
        }
        
        heart_bitmaps[heart_id].setLocation(50, 50);
        heart_bitmaps[heart_id].draw(dc);
        
        hungryBitmap.setLocation(100, 30);
        hungryBitmap.draw(dc);
        
        fitBitmap.setLocation(150, 50);
        fitBitmap.draw(dc);
	}

    // Update the view
    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
        dc.clear();

		drawIndicators(dc);
        animateCharacter(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    	System.println("on hide view 1");
    	update_timer.stop();
    }

}
