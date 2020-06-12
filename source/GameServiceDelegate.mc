using Toybox.Application;
using Toybox.Background;
using Toybox.System;
using Toybox.Time;
using Toybox.UserProfile;

(:background)
class GameServiceDelegate extends System.ServiceDelegate {
    function initialize() {
        ServiceDelegate.initialize();
    }

    function incrGameStateItem(gameState, key, incr, max) {
        var currentValue = gameState.get(key);
        if (currentValue == null) {
            currentValue = 0;
        }
        currentValue += incr;
        if (max != null && currentValue > max) {
            currentValue = max;
        }
        gameState.put(key, currentValue);
        return gameState;
    }

    function decrGameStateItem(gameState, key, decr, min) {
        var currentValue = gameState.get(key);
        if (currentValue == null) {
            currentValue = 0;
        }
        currentValue -= decr;
        if (min != null && currentValue < min) {
            currentValue = min;
        }

        gameState.put(key, currentValue);
        return gameState;
    }

    function triggerNotification(gameState) {
        var currentTime = System.getTimer();
        var lastNotifiedAt = gameState.get(Constants.STATE_KEY_LAST_NOTIF);
        // Skip notification if recently displayed
        if (
            lastNotifiedAt
            && (currentTime - lastNotifiedAt) / 1000 < Constants.NOTIFICATION_FREQUENCY
        ) {
            return gameState;
        }

        // Skip notification if during sleep time
        var userProfile = UserProfile.getProfile();
        if (userProfile.wakeTime != null && userProfile.wakeTime.value() != null) {
            if (Time.now().value() < (Time.today().value() + userProfile.wakeTime.value())) {
                return gameState;
            }
        }

        // Skip notification if Do Not Disturb set
        var deviceSettings = System.getDeviceSettings();
        if (deviceSettings has :doNotDisturb) {
            if (deviceSettings.doNotDisturb) {
                return gameState;
            }
        }

        var appName = "Monky";
        if (gameState.get(Constants.STATE_KEY_HAPPY) < Constants.NOTIFICATION_THRESHOLD) {
            Background.requestApplicationWake(appName + " feels sad");
        }
        else if (gameState.get(Constants.STATE_KEY_HEALTH) < Constants.NOTIFICATION_THRESHOLD) {
            Background.requestApplicationWake(appName + " is feeling dizzy");
        }
        else if (gameState.get(Constants.STATE_KEY_CLEAN) < Constants.NOTIFICATION_THRESHOLD) {
            Background.requestApplicationWake(appName + " could use a bath!");
        }
        else if (gameState.get(Constants.STATE_KEY_FIT) < Constants.NOTIFICATION_THRESHOLD) {
            Background.requestApplicationWake(appName + " would really go for a walk!");
        }

        gameState.put(Constants.STATE_KEY_LAST_NOTIF, currentTime);

        return gameState;
    }

    function onTemporalEvent() {
        // read previously saved background data
        var gameState = Background.getBackgroundData();
        if (gameState == null) {
            // if empty, rely on game state
            gameState = Application.getApp().getGameState();
        }
        // update health
        gameState = decrGameStateItem(gameState, Constants.STATE_KEY_HEALTH, 1, Constants.MIN_HEALTH);
        // update happy
        gameState = decrGameStateItem(gameState, Constants.STATE_KEY_HAPPY, 5, Constants.MIN_HAPPY);
        // update clean
        gameState = decrGameStateItem(gameState, Constants.STATE_KEY_CLEAN, 1, Constants.MIN_CLEAN);

        gameState = triggerNotification(gameState);
        Background.exit(gameState);
    }

    function onGoalReached(goalType) {
        var gameState = Background.getBackgroundData();
        if (gameState == null) {
            // if empty, rely on game state
            gameState = Application.getApp().getGameState();
        }
        var happyIncr = 0;
        if (goalType == Application.GOAL_TYPE_STEPS) {
            happyIncr = 10;
        }
        else if (goalType == Application.GOAL_TYPE_FLOORS_CLIMBED) {
            happyIncr = 20;
        }
        else if (goalType == Application.GOAL_TYPE_ACTIVE_MINUTES) {
            happyIncr = 20;
        }
        gameState = incrGameStateItem(gameState, Constants.STATE_KEY_HAPPY, happyIncr, Constants.MAX_HAPPY);
        gameState = incrGameStateItem(gameState, Constants.STATE_KEY_HEALTH, 20, Constants.MAX_HEALTH);
        gameState = incrGameStateItem(gameState, Constants.STATE_KEY_FIT, 20, Constants.MAX_FIT);

        gameState = decrGameStateItem(gameState, Constants.STATE_KEY_CLEAN, 10, Constants.MIN_CLEAN);

        gameState = incrGameStateItem(gameState, Constants.STATE_KEY_XP, 100, null);

        gameState = triggerNotification(gameState);
        Background.exit(gameState);
    }
}
