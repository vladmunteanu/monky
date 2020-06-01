using Toybox.WatchUi;
using Toybox.System;
using Toybox.Math;
using Toybox.Graphics;


class SwipeGameView extends WatchUi.View {
    function initialize() {
        View.initialize();
        System.println("initialize view 2");
    }
    // Load your resources here
    function onLayout(dc) {
    	System.println("on layout view 2");
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    	System.println("on show view 2");
    }

    // Update the view
    function onUpdate(dc) {
    	System.println("on update view 2");
    	dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
        dc.clear();
        dc.drawText( 50, 100, Graphics.FONT_TINY, "Swipe Game",   Graphics.TEXT_JUSTIFY_CENTER );
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    	System.println("on hide view 2");
    }

}
