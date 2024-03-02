using Toybox.Application;
using Toybox.WatchUi;
using Toybox.System;
using Toybox.Math;
using Toybox.Graphics;
using Toybox.Timer;


class TicTacToeCommons {
    const WIN_XP_BONUS = 50;

    // game states
    const GAME_ONGOING = 1;
    const GAME_OVER = 2;
    const GAME_TIED = 3;
    var state;

    // board
    const X_VALUE = 1;
    const O_VALUE = 0;
    var board, boardCoordinates;

    var isXTurn, winningPath, displayWinningPath, timer;

    var maxHeight, maxWidth;
    var borderWidth;
    var multiplayer;

    function initialize(mp) {
        board = [[null, null, null],[null, null, null],[null, null, null]];

        state = GAME_ONGOING;
        isXTurn = true;
        winningPath = null;
        displayWinningPath = false;
        timer = new Timer.Timer();
        multiplayer = mp;
    }

    function loadResources() {
        borderWidth = WatchUi.loadResource(Rez.JsonData.tttBorderWidth);
    }

    function setupLayout(dc) {
        maxHeight = dc.getHeight();
        maxWidth = dc.getWidth();

        var cell00 = [[borderWidth, borderWidth], [maxWidth / 2 - borderWidth, maxHeight / 2 - borderWidth]];
        var cell01 = [[maxWidth / 2 - borderWidth, borderWidth], [maxWidth / 2 + borderWidth, maxHeight / 2 - borderWidth]];
        var cell02 = [[maxWidth / 2 + borderWidth, borderWidth], [maxWidth - borderWidth, maxHeight / 2 - borderWidth]];

        var cell10 = [[borderWidth, maxHeight / 2 - borderWidth], [maxWidth / 2 - borderWidth, maxHeight / 2 + borderWidth]];
        var cell11 = [[maxWidth / 2 - borderWidth, maxHeight / 2 - borderWidth], [maxWidth / 2 + borderWidth, maxHeight / 2 + borderWidth]];
        var cell12 = [[maxWidth / 2 + borderWidth, maxHeight / 2 - borderWidth], [maxWidth - borderWidth, maxHeight / 2 + borderWidth]];

        var cell20 = [[borderWidth, maxHeight / 2 + borderWidth], [maxWidth / 2 - borderWidth, maxHeight - borderWidth]];
        var cell21 = [[maxWidth / 2 - borderWidth, maxHeight / 2 + borderWidth], [maxWidth / 2 + borderWidth, maxHeight - borderWidth]];
        var cell22 = [[maxWidth / 2 + borderWidth, maxHeight / 2 + borderWidth], [maxWidth - borderWidth, maxHeight - borderWidth]];

        boardCoordinates = [[cell00, cell01, cell02], [cell10, cell11, cell12], [cell20, cell21, cell22]];
    }

    function getAvailableMoves(boardState) {
        var moves = [];
        for (var i = 0; i < 3; i++) {
            for (var j = 0; j < 3; j++) {
                if (boardState[i][j] == null) {
                    moves.add([i, j]);
                }
            }
        }
        return moves;
    }

    function makeMove() {
        if (isXTurn || multiplayer) {
            return null;
        }

        var bestMove = null;
        var availableMoves = getAvailableMoves(board);
        var numAvailableMoves = availableMoves.size();

        if (numAvailableMoves == 0) {
            return null;
        }

        // go through available moves
        // place O, pick winning move if available
        for (var i = 0; i < numAvailableMoves; i++) {
            var move = availableMoves[i];
            var initialVal = board[move[0]][move[1]];
            board[move[0]][move[1]] = O_VALUE;
            var currentState = getGameState(board);
            // revert the board move
            board[move[0]][move[1]] = initialVal;

            if (currentState[0] == GAME_OVER) {
                bestMove = move;
                break;
            }
        }

        // go through available moves
        // place X, pick winning move if available and put O there
        if (bestMove == null) {
            for (var i = 0; i < numAvailableMoves; i++) {
                var move = availableMoves[i];
                var initialVal = board[move[0]][move[1]];
                board[move[0]][move[1]] = X_VALUE;
                var currentState = getGameState(board);
                // revert the board move
                board[move[0]][move[1]] = initialVal;

                if (currentState[0] == GAME_OVER) {
                    bestMove = move;
                    break;
                }
            }
        }
        // otherwise get a random cell
        if (bestMove == null) {
            bestMove = availableMoves[Math.rand() % (numAvailableMoves - 1)];
        }

        saveMove(bestMove[0], bestMove[1]);
    }

    function saveMove(i, j) {
        if (state == GAME_OVER || state == GAME_TIED) {
            return;
        }
        if (isXTurn) {
            board[i][j] = X_VALUE;
        } else {
            board[i][j] = O_VALUE;
        }

        // switch turns
        isXTurn = !isXTurn;

        var gameState = getGameState(board);
        if (gameState[0] == GAME_OVER) {
            winningPath = gameState[1];
            displayWinningPath = true;
            if (!isXTurn && !multiplayer) {
                Application.getApp().incrCurrentStateItem(Constants.STATE_KEY_HAPPY, 20, Constants.MAX_HAPPY);
                Application.getApp().incrCurrentStateItem(Constants.STATE_KEY_XP, WIN_XP_BONUS, null);
            }
        }
        state = gameState[0];
        WatchUi.requestUpdate();

        if (!isXTurn && !multiplayer && gameState[0] == GAME_ONGOING) {
            // start the timer for an AI move after 500 ms
            timer.start(self.method(:makeMove), 500, false);
        }
    }

    function getGameState(boardState) {
        if (boardState[0][0] != null && boardState[0][0] == boardState[0][1] && boardState[0][1] == boardState[0][2]) {
            return [GAME_OVER, [boardCoordinates[0][0], boardCoordinates[0][1], boardCoordinates[0][2]]];
        } else if (boardState[1][0] != null && boardState[1][0] == boardState[1][1] && boardState[1][1] == boardState[1][2]) {
            return [GAME_OVER, [boardCoordinates[1][0], boardCoordinates[1][1], boardCoordinates[1][2]]];
        } else if (boardState[2][0] != null && boardState[2][0] == boardState[2][1] && boardState[2][1] == boardState[2][2]) {
            return [GAME_OVER, [boardCoordinates[2][0], boardCoordinates[2][1], boardCoordinates[2][2]]];
        } else if (boardState[0][0] != null && boardState[0][0] == boardState[1][0] && boardState[1][0] == boardState[2][0]) {
            return [GAME_OVER, [boardCoordinates[0][0], boardCoordinates[1][0], boardCoordinates[2][0]]];
        } else if (boardState[0][1] != null && boardState[0][1] == boardState[1][1] && boardState[1][1] == boardState[2][1]) {
            return [GAME_OVER, [boardCoordinates[0][1], boardCoordinates[1][1], boardCoordinates[2][1]]];
        } else if (boardState[0][2] != null && boardState[0][2] == boardState[1][2] && boardState[1][2] == boardState[2][2]) {
            return [GAME_OVER, [boardCoordinates[0][2], boardCoordinates[1][2], boardCoordinates[2][2]]];
        } else if (boardState[0][0] != null && boardState[0][0] == boardState[1][1] && boardState[1][1] == boardState[2][2]) {
            return [GAME_OVER, [boardCoordinates[0][0], boardCoordinates[1][1], boardCoordinates[2][2]]];
        } else if (boardState[0][2] != null && boardState[0][2] == boardState[1][1] && boardState[1][1] == boardState[2][0]) {
            return [GAME_OVER, [boardCoordinates[0][2], boardCoordinates[1][1], boardCoordinates[2][0]]];
        } else if (getAvailableMoves(boardState).size() == 0) {
            return [GAME_TIED, null];
        } else {
            return [GAME_ONGOING, null];
        }
    }

    function drawGame(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.setPenWidth(5);

        // draw the board
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        // vertical lines
        dc.drawLine(maxWidth / 2 - borderWidth, borderWidth, maxWidth / 2 - borderWidth, maxHeight - borderWidth);
        dc.drawLine(maxWidth / 2 + borderWidth, borderWidth, maxWidth / 2 + borderWidth, maxHeight - borderWidth);

        // horizontal lines
        dc.drawLine(borderWidth, maxHeight / 2 - borderWidth, maxWidth - borderWidth, maxHeight / 2 - borderWidth);
        dc.drawLine(borderWidth, maxHeight / 2 + borderWidth, maxWidth - borderWidth, maxHeight / 2 + borderWidth);

        // draw checked items
        for (var i = 0; i < 3; i++) {
            for (var j = 0; j < 3; j++) {
                var font = Graphics.FONT_LARGE;
                var cellCoordinates = boardCoordinates[i][j];
                var border = 10;
                var cellText = "";
                var textX = (cellCoordinates[1][0] - cellCoordinates[0][0]) / 2 + cellCoordinates[0][0];
                var textY = (cellCoordinates[1][1] - cellCoordinates[0][1]) / 2 + cellCoordinates[0][1] - dc.getFontHeight(font) / 2;
                if (board[i][j] == X_VALUE) {
                    cellText = "X";
                } else if (board[i][j] == O_VALUE) {
                    cellText = "0";
                }
                dc.drawText(textX, textY, font, cellText, Graphics.TEXT_JUSTIFY_CENTER);
            }
        }
    }

    function drawWinningPath(dc) {
        // draw the game as usual
        if (!displayWinningPath || winningPath == null) {
            return;
        }
        var firstCell = winningPath[0];
        var lastCell = winningPath[winningPath.size() - 1];

        var pathX1 = (firstCell[1][0] - firstCell[0][0]) / 2 + firstCell[0][0];
        var pathY1 = (firstCell[1][1] - firstCell[0][1]) / 2 + firstCell[0][1];
        var pathX2 = (lastCell[1][0] - lastCell[0][0]) / 2 + lastCell[0][0];
        var pathY2 = (lastCell[1][1] - lastCell[0][1]) / 2 + lastCell[0][1];

        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_BLACK);
        dc.drawLine(pathX1, pathY1, pathX2, pathY2);

        // start the timer to show the final outcome after 2 seconds
        timer.start(self.method(:triggerGameOverRefresh), 2000, false);
    }

    function triggerGameOverRefresh() {
        displayWinningPath = false;
        WatchUi.requestUpdate();
    }

    function processTap(x, y) {
        if (!isXTurn && !multiplayer) {
            return;
        }
        var availableMoves = getAvailableMoves(board);

        var chosenMove = null;
        for (var i = 0; i < 3; i++) {
            for (var j = 0; j < 3; j++) {
                var cellCoordinates = boardCoordinates[i][j];
                if (x > cellCoordinates[0][0] && y > cellCoordinates[0][1] && x < cellCoordinates[1][0] && y < cellCoordinates[1][1]) {
                    chosenMove = [i, j];
                }
            }
        }

        if (chosenMove == null) {
            return;
        }
        for (var i = 0; i < availableMoves.size(); i++) {
            if (availableMoves[i][0] == chosenMove[0] && availableMoves[i][1] == chosenMove[1]) {
                // register move
                saveMove(chosenMove[0], chosenMove[1]);
            }
        }

        return;
    }
}


class TicTacToeView extends WatchUi.View {

    var commons;
    function initialize(multiplayer) {
        View.initialize();
        commons = new TicTacToeCommons(multiplayer);
    }

    function onLayout(dc) {
        commons.loadResources();
        commons.setupLayout(dc);
    }

    function onShow() {
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
        dc.clear();
        if (commons.state == commons.GAME_ONGOING) {
            commons.drawGame(dc);
        } else if (commons.displayWinningPath) {
            commons.drawGame(dc);
            commons.drawWinningPath(dc);
        } else {
            var font = Graphics.FONT_MEDIUM;
            var fontHeight = dc.getFontHeight(font);
            var textX = dc.getWidth() / 2;
            var textY = dc.getHeight() / 2;
            var resultText = "Game over!";
            var otherText = "";
            dc.drawText(textX, textY - 2 * fontHeight, font, resultText, Graphics.TEXT_JUSTIFY_CENTER );
            if (commons.state == commons.GAME_OVER) {
                if (commons.isXTurn) {
                    resultText = "O";
                }
                else if (commons.multiplayer) {
                    resultText = "X";
                }
                else {
                    resultText = "You";
                    otherText += "+" + commons.WIN_XP_BONUS + "xp";
                }
                resultText += " won";
            } else if (commons.state == commons.GAME_TIED) {
                resultText = "- tie -";
            }
            dc.drawText(textX, textY - 1 * fontHeight, font, resultText, Graphics.TEXT_JUSTIFY_CENTER );
            dc.drawText(textX, textY, font, otherText, Graphics.TEXT_JUSTIFY_CENTER );
        }
    }

    function onHide() {
        commons.timer.stop();
    }

}
