(:background)
module Constants {
    // character attributes
    const MIN_HEALTH = 1;
    const MAX_HEALTH = 100;
    const MIN_HAPPY = 1;
    const MAX_HAPPY = 100;
    const MIN_FIT = 1;
    const MAX_FIT = 100;
    const MIN_CLEAN = 1;
    const MAX_CLEAN = 100;

    // character animation
    const MAX_ANIMATION_REPETITIONS = 3;
    const ANIMATION_SPEED = 300;
    const ANIMATION_PAUSE = 5000;

    const XP_PER_LEVEL = {
        [0, 5000] => 1000,
        [5000, 10000] => 2000,
        [10000, 20000] => 4000,
        [20000, 40000] => 8000,
        [40000, 80000] => 16000,
        [80000, 160000] => 32000,
        [160000, 320000] => 64000,
        [320000, 640000] => 128000,
    };
    const DAILY_XP_REWARD = 500;
    const GOAL_XP_REWARD = 100;

    const FOOD_VEGETABLES = "vegetables";
    const FOOD_STEAK = "steak";
    const FOOD_COOKIE = "cookie";

    const ACTIVITY_SWIPE = "swipe";
    const ACTIVITY_WAM = "wam";
    const ACTIVITY_BATH = "bath";

    // state key constants
    const STATE_KEY = "game-state";
    const STATE_KEY_HEALTH = "health";
    const STATE_KEY_HAPPY = "happy";
    const STATE_KEY_CLEAN = "clean";
    const STATE_KEY_FIT = "fit";
    const STATE_KEY_XP = "xp";
    const STATE_KEY_ILVL = "ilvl";
    const STATE_KEY_LAST_UPDATE = "last-update";
    const STATE_KEY_LAST_NOTIF = "last-notif";

    const NOTIFICATION_FREQUENCY = 60 * 60 * 3;
    const NOTIFICATION_THRESHOLD = 30;
}
