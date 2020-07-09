using Toybox.Application;
using Toybox.WatchUi;

function pushSettingsMenu() {
    var notificationsEnabled = Application.getApp().getProperty(Constants.NOTIFICATION_TOGGLE_PROP);
    var settingsMenu = new WatchUi.Menu2({:title=>"Settings"});
    settingsMenu.addItem(
        new WatchUi.ToggleMenuItem(
            "Notifications",
            {:enabled=>"on", :disabled=>"off"},
            Constants.NOTIFICATION_TOGGLE_PROP,
            notificationsEnabled,
            {:alignment=>WatchUi.MenuItem.MENU_ITEM_LABEL_ALIGN_LEFT}
        )
    );
    settingsMenu.addItem(new WatchUi.MenuItem("Reset", null, "reset", null));
    WatchUi.pushView(settingsMenu, new SettingsMenuDelegate(), WatchUi.SLIDE_UP );
}

class SettingsMenuDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) {
        if( item.getId().equals(Constants.NOTIFICATION_TOGGLE_PROP) ) {
            var notificationsEnabled = Application.getApp().getProperty(Constants.NOTIFICATION_TOGGLE_PROP);
            Application.getApp().setProperty(Constants.NOTIFICATION_TOGGLE_PROP, !notificationsEnabled);
        }
        else if ( item.getId().equals("reset") ) {
            var view = new WatchUi.Confirmation("Are you sure?");
            var delegate =  new ResetSettingsDelegate();
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


class ResetSettingsDelegate extends WatchUi.ConfirmationDelegate {
    function initialize() {
        ConfirmationDelegate.initialize();
    }

    function onResponse(response) {
        if (response == WatchUi.CONFIRM_YES) {
            var app = Application.getApp();
            var currentState = app.setGameState(app.getInitialState());
        }
    }
}
