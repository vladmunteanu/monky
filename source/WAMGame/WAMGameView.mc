using Toybox.WatchUi;
using Toybox.System;
using Toybox.Math;
using Toybox.Graphics;
using Toybox.Timer;
using Toybox.Lang;


class WAMGameCommons extends Lang.Object {
	var holeCoordinates = [
		[45, 80], [85, 80], [125, 80], [165, 80],
		[45, 120], [85, 120], [125, 120], [165, 120],
		[45, 160], [85, 160], [125, 160], [165, 160],
	];

	var moleOffsetX = -13;
	var moleOffsetY = -12;
	
	var currentPosition;

	var laps = 0;
	var successLaps = 0;
	var failedLaps = 0;

	var timer, finishTimer;
	var timeout = 1000;
	var finishTimeout = 15000;
	
	var stopped = false;

	function startFinishTimer() {
		if (finishTimer == null) {
			finishTimer = new Timer.Timer();
		}
		finishTimer.start(self.method(:finishTimerCallback), finishTimeout, false);
	}
	
	function finishTimerCallback() {
		System.println("Finished");
		stopped = true;
		timer.stop();
		WatchUi.requestUpdate();
	}

	function startTimer() {
		if (timer == null) {
			timer = new Timer.Timer();
		}
		timer.start(self.method(:timerCallback), timeout, false);
	}
	
	function stopTimer() {
		timer.stop();
	}
	
	function timerCallback() {
		registerLap(false);
		resetPosition();
	}
	
	function getPosition() {
		if (currentPosition == null) {
			resetPosition();
		}
		return currentPosition;
	}
	
	function resetPosition() {
		if (!stopped) {
			System.println("Resetting, current laps: " + laps);
			stopTimer();
			currentPosition = Math.rand() % holeCoordinates.size();
			startTimer();
			WatchUi.requestUpdate();
		}
	}
	
	function registerLap(result) {
		if (stopped) {
			return;
		}
		System.println("Registering " + result);
		if (result) {
			successLaps += 1;
		} else {
			failedLaps += 1;
		}
		laps += 1;
	}
	
	function drawGame(moleBitmap, dc) {
		// paint the sky
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
        dc.fillRectangle(0, 0, dc.getHeight(), dc.getWidth());
        // paint the sun
        dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_BLACK);
        dc.fillCircle(150, 0, 25);
        // paint the grass
        dc.setColor(Graphics.COLOR_DK_GREEN, Graphics.COLOR_BLACK);
        dc.fillEllipse(107, 140, 240, 100);
        
        // paint the mole holes
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        for (var i = 0; i < holeCoordinates.size(); i++) {
    		var currentCoordinates = holeCoordinates[i];
    		if (i == currentPosition) {
    			moleBitmap.setLocation(currentCoordinates[0] + moleOffsetX, currentCoordinates[1] + moleOffsetY);
        		moleBitmap.draw(dc);
    		} else {
    			dc.fillEllipse(currentCoordinates[0], currentCoordinates[1], 15, 10);
    		}
        }
	}
}


class WAMGameView extends WatchUi.View {

	var moleBitmap;
	var commons;
	// indicators
    function initialize() {
        View.initialize();
        System.println("initialize view 4");
        commons = new WAMGameCommons();
    }

    // Load your resources here
    function onLayout(dc) {
    	System.println("on layout view 4");
    	moleBitmap = new WatchUi.Bitmap({:rezId=>Rez.Drawables.mole});
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    	System.println("on show view 4");
    	// start mole timer
    	commons.startTimer();
    	commons.startFinishTimer();
    }

    // Update the view
    function onUpdate(dc) {
    	dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
        dc.clear();
        if (!commons.stopped) {
        	commons.drawGame(moleBitmap, dc);
        } else {
			var font = Graphics.FONT_MEDIUM;
			var fontHeight = dc.getFontHeight(font);
			var textX = dc.getWidth() / 2;
			var textY = dc.getHeight() / 2;
			var resultText = "Congratulations!";
			dc.drawText(textX, textY - 2 * fontHeight, font, resultText, Graphics.TEXT_JUSTIFY_CENTER );
			resultText = "total laps: " + commons.laps;
			dc.drawText(textX, textY - 1 * fontHeight, font, resultText, Graphics.TEXT_JUSTIFY_CENTER );
			resultText = "successful laps: " + commons.successLaps;
			dc.drawText(textX, textY, font, resultText, Graphics.TEXT_JUSTIFY_CENTER );
			resultText = "failed laps: " + commons.failedLaps;
			dc.drawText(textX, textY + 1 * fontHeight, font, resultText, Graphics.TEXT_JUSTIFY_CENTER );
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    	System.println("on hide view 4");
    	commons.timer.stop();
    	commons.finishTimer.stop();
    }

}
