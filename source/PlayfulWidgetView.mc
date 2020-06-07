using Toybox.WatchUi;
using Toybox.System;
using Toybox.Math;
using Toybox.Graphics;


class PlayfulWidgetView extends WatchUi.View {

	// indicators
	var heart_bitmaps, fitLabel, notFitLabel, fitBitmap, hungryLabel, notHungryLabel, hungryBitmap;
	var hasHealth, isFit, isHungry;

	var font = Graphics.FONT_TINY;
	var lineSpacing = Graphics.getFontHeight(font);

    var characterRepr;
	
    function initialize() {
        View.initialize();

        hasHealth = true;
        isFit = false;
        isHungry = true;

        characterRepr = new GameCharacterRepresentation();
    }

    // Load your resources here
    function onLayout(dc) {
        // load the character resources
        characterRepr.loadResources(dc);

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
    	characterRepr.startAnimationTimer();
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
        characterRepr.animate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    	characterRepr.stopAnimationTimer();
    }

}
