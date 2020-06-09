using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Math;
using Toybox.Graphics;


class IndicatorView extends WatchUi.View {
    function initialize() {
        View.initialize();
    }
    // Load your resources here
    function onLayout(dc) {
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
    	dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
        dc.clear();
        displayStats(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }
    
    function displayStats(dc) {
    	var currentState = Application.getApp().currentState;
    	var happy = currentState.get(Constants.STATE_KEY_HAPPY);
    	var health = currentState.get(Constants.STATE_KEY_HEALTH);
    	var clean = currentState.get(Constants.STATE_KEY_CLEAN);
    	var fit = currentState.get(Constants.STATE_KEY_FIT);
    	var xp = currentState.get(Constants.STATE_KEY_XP);
    	var font = Graphics.FONT_TINY;
    	var fontHeight = Graphics.getFontHeight(font);
		
		var textX = dc.getWidth() / 2;
		var textY = 20;
    	dc.drawText( textX, textY, font, "Healthy: " + health + "%",   Graphics.TEXT_JUSTIFY_CENTER );
    	dc.drawText( textX, textY + fontHeight, font, "Happy: " + happy + "%",   Graphics.TEXT_JUSTIFY_CENTER );
    	dc.drawText( textX, textY + 2 * fontHeight, font, "Clean: " + clean + "%",   Graphics.TEXT_JUSTIFY_CENTER );
    	dc.drawText( textX, textY + 3 * fontHeight, font, "Fit: " + fit + "%",   Graphics.TEXT_JUSTIFY_CENTER );
    	dc.drawText( textX, textY + 4 * fontHeight, font, "XP: " + xp,   Graphics.TEXT_JUSTIFY_CENTER );
    }
}
