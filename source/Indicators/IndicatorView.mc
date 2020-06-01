using Toybox.WatchUi;
using Toybox.System;
using Toybox.Math;
using Toybox.Graphics;


class IndicatorView extends WatchUi.View {
	var indicator;
    function initialize(indicates) {
    	indicator = indicates;
        View.initialize();
        System.println("initialize view 3 as: " + indicator);
    }
    // Load your resources here
    function onLayout(dc) {
    	System.println("on layout view 3");
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    	System.println("on show view 3");
    }

    // Update the view
    function onUpdate(dc) {
    	System.println("on update view 3");
    	dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
        dc.clear();
        dc.drawText( dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_TINY, "Indicator View:",   Graphics.TEXT_JUSTIFY_CENTER );
        dc.drawText( dc.getWidth() / 2, dc.getHeight() / 2 + Graphics.getFontHeight(Graphics.FONT_TINY), Graphics.FONT_TINY, indicator,   Graphics.TEXT_JUSTIFY_CENTER );
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    	System.println("on hide view 3");
    }

}
