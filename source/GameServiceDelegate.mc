using Toybox.Application;
using Toybox.Background;
using Toybox.System;

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
    	
        Background.exit(gameState);
    }
}
