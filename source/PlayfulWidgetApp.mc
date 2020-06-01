using Toybox.Application;

class PlayfulWidgetApp extends Application.AppBase {

	var mainView, mainDelegate;

    function initialize() {
        AppBase.initialize();        
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view of your application here
    function getInitialView() {
        return getMainView();
    }
    
    function getMainView() {
    	if (mainView == null) {
    		mainView = new PlayfulWidgetView();
    		mainDelegate = new PlayfulWidgetDelegate();
    	}
    	return [mainView, mainDelegate];
    }
}