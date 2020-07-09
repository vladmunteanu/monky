using Toybox.WatchUi;

function pushActivitiesMenu() {
    var customMenu = new WatchUi.Menu2({:title=>"Activities Menu"});
    customMenu.addItem(new WatchUi.MenuItem("Simon says", null, Constants.ACTIVITY_SIMON, null));
    customMenu.addItem(new WatchUi.MenuItem("Whack that mole!", null, Constants.ACTIVITY_WAM, null));
    customMenu.addItem(new WatchUi.MenuItem("TicTacToe", null, Constants.ACTIVITY_TTT, null));
    customMenu.addItem(new WatchUi.MenuItem("TicTacToe friends", null, Constants.ACTIVITY_TTTF, null));
    customMenu.addItem(new WatchUi.MenuItem("Swipe that way!", null, Constants.ACTIVITY_SWIPE, null));
    customMenu.addItem(new WatchUi.MenuItem("Bubble bath", null, Constants.ACTIVITY_BATH, null));
    WatchUi.pushView(customMenu, new ActivitiesMenuDelegate(), WatchUi.SLIDE_DOWN );
}

class ActivitiesMenuDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) {
        if( item.getId().equals(Constants.ACTIVITY_SWIPE) ) {
            var view = new SwipeGameView();
            var delegate = new SwipeGameDelegate(view);
            WatchUi.pushView(view, delegate, WatchUi.SLIDE_LEFT);
        }
        else if ( item.getId().equals(Constants.ACTIVITY_WAM) ) {
            var view = new WAMGameView();
            var delegate =  new WAMGameDelegate(view);
            WatchUi.pushView(view, delegate, WatchUi.SLIDE_LEFT);
        }
        else if ( item.getId().equals(Constants.ACTIVITY_BATH) ) {
            var view = new BubbleBathView();
            var delegate =  null;
            WatchUi.pushView(view, delegate, WatchUi.SLIDE_LEFT);
        }
        else if (item.getId().equals(Constants.ACTIVITY_SIMON)) {
            var view = new SimonGameView();
            var delegate = new SimonGameDelegate(view);
            WatchUi.pushView(view, delegate, WatchUi.SLIDE_LEFT);
        }
        else if (item.getId().equals(Constants.ACTIVITY_TTT)) {
            var multiplayer = false;
            var view = new TicTacToeView(multiplayer);
            var delegate = new TicTacToeDelegate(view);
            WatchUi.pushView(view, delegate, WatchUi.SLIDE_LEFT);
        }
        else if (item.getId().equals(Constants.ACTIVITY_TTTF)) {
            var multiplayer = true;
            var view = new TicTacToeView(multiplayer);
            var delegate = new TicTacToeDelegate(view);
            WatchUi.pushView(view, delegate, WatchUi.SLIDE_LEFT);
        }
        else {
            WatchUi.requestUpdate();
        }
    }

    function onBack() {
        WatchUi.popView(WatchUi.SLIDE_UP);
    }
}
