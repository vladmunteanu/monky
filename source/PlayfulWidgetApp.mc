using Toybox.Application;
using Toybox.Background;
using Toybox.Math;
using Toybox.System;
using Toybox.Time;
using Toybox.WatchUi;

(:background)
class PlayfulWidgetApp extends Application.AppBase {

	var mainView, mainDelegate;
	var currentState;

    function initialize() {
        AppBase.initialize();
        Math.srand(System.getTimer());    
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    	if (mainView) {
//    		startGameService();
    		// save state
    		setGameState(currentState);
    	}
    }

    // Return the initial view of your application here
    function getInitialView() {
    	mainView = new PlayfulWidgetView();
    	mainDelegate = new PlayfulWidgetDelegate();
		startGameService();
		
    	currentState = getGameState();
        return [mainView, mainDelegate];
    }

    // This method is called when data is returned from our
    // Background process.
    function onBackgroundData(data) {
    	System.println("Application got: " + data);
        if (data != null) {
            setGameState(data);
        }
    }

    // This method runs each time the background process starts.
    function getServiceDelegate(){
        return [new GameServiceDelegate()];
    }
    
    function getGameState() {
    	var gameState = getProperty(Constants.STATE_KEY);
	    if (gameState == null) {
	        // the initial game state
	        gameState = {
	            Constants.STATE_KEY_HEALTH => 100,
	            Constants.STATE_KEY_HAPPY => 50,
	            Constants.STATE_KEY_CLEAN => 50,
	            Constants.STATE_KEY_FIT => 50,
	            Constants.STATE_KEY_XP => 0,
	            Constants.STATE_KEY_ILVL => 0,
	        };
	    }
	    return gameState;
    }
    
    function setGameState(state) {
    	if (currentState != null) {
    		currentState = state;
    		WatchUi.requestUpdate();
    	}
    	setProperty(Constants.STATE_KEY, state);
	}
	
    function incrCurrentStateItem(key, incr, max) {
    	var currentValue = currentState.get(key);
    	if (currentValue == null) {
    		currentValue = 0;
    	}
    	currentValue += incr;
		if (max != null && currentValue > max) {
			currentValue = max;
		}
    	currentState.put(key, currentValue);
    	WatchUi.requestUpdate();
    }
    
    function decrCurrentStateItem(key, decr, min) {
    	var currentValue = currentState.get(key);
    	if (currentValue == null) {
    		currentValue = 0;
    	}
    	currentValue -= decr;
		if (min != null && currentValue < min) {
			currentValue = min;
		}
    	currentState.put(key, currentValue);
    	WatchUi.requestUpdate();
    }
}

function stopGameService() {
    Background.deleteTemporalEvent();
    Background.deleteGoalEvent(Application.GOAL_TYPE_STEPS);
    Background.deleteGoalEvent(Application.GOAL_TYPE_FLOORS_CLIMBED);
    Background.deleteGoalEvent(Application.GOAL_TYPE_ACTIVE_MINUTES);
}

function startGameService() {
    var time = new Time.Duration(300);
    Background.registerForTemporalEvent(time);
    Background.registerForGoalEvent(Application.GOAL_TYPE_STEPS);
    Background.registerForGoalEvent(Application.GOAL_TYPE_FLOORS_CLIMBED);
    Background.registerForGoalEvent(Application.GOAL_TYPE_ACTIVE_MINUTES);
}
