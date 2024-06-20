import 'dart:math';

import 'package:ludo/common_libs.dart';
import 'package:ludo/models/board_matrix.dart';
import 'package:ludo/models/board_path.dart';
import 'package:ludo/models/player_piece.dart';
import 'package:ludo/models/tile_color_data.dart';
import 'package:ludo/models/tile_data.dart';

class HomeController extends GetxController {
  final winDisplay = '++';
  final exitHomeDisplay = '+';
  final Random random = Random();

  /// generates a random row between 1 and 6.
  int get randomRoll => 1 + random.nextInt(6);

  /// current player has pressed the roll button.
  final RxBool _hasPlayerRolled = false.obs;

  /// double six
  final RxBool _isPlayerRollingAgain = false.obs;

  /// is player piece moving.
  final RxBool _isPieceMoving = false.obs;
  final RxInt _dice1 = 0.obs;
  final RxInt _dice2 = 0.obs;
  final RxInt _currentPlayer = BoardMatrix.green.obs;
  final RxList<String> _gameLogs = <String>[].obs;
  final RxList<TileColorData> _tileColorData = <TileColorData>[].obs;
  final RxList<PlayerPiece> _playerPieces = <PlayerPiece>[].obs;
  final RxList<BoardPath> _boardPaths = <BoardPath>[].obs;

  final RxInt _position = 1.obs;
  final RxList<int> _winnerList = <int>[].obs;

  bool get isPieceMoving => _isPieceMoving.value;
  int get currentPlayer => _currentPlayer.value;
  int get dice1 => _dice1.value;
  int get dice2 => _dice2.value;
  List<String> get gameLogs => _gameLogs;
  List<TileColorData> get tileColorData => _tileColorData;
  List<PlayerPiece> get playerPieces => _playerPieces;
  List<BoardPath> get boardPaths => _boardPaths;

  setPath(List<BoardPath> paths) {
    _boardPaths.clear();
    _boardPaths.addAll(paths);
    _boardPaths.refresh();
  }

  setPieceIsMoving(bool value) => _isPieceMoving(value);

  initPieces() {
    _playerPieces.clear();
    _playerPieces.addAll(BoardMatrix.piecePosition);
    _playerPieces.refresh();
  }

  refreshPieces() => _playerPieces.refresh();

  generateTileColorData() {
    _tileColorData.clear();
    for (final tile in BoardMatrix.tilePositions) {
      final data = createTileColorData(tile);
      tileColorData.addAll(data);
    }
    _tileColorData.refresh();
  }

  /// this is used to set up the tile color data. recreating all these data on each build is quite intensive.
  /// so it is better to create it on init instead since they don't need to be rebuilt each time.
  /// also it is sort of a matrix system (Check Boardmatrix class for explanation) so we need go generate all boxes between the x and y coordinates.
  List<TileColorData> createTileColorData(TileData tile) {
    final startX = tile.startX;
    final startY = tile.startY;

    final endX = tile.endX;
    final endY = tile.endY;

    final boxColor = tile.color;
    final centerTint = tile.center;

    final List<TileColorData> data = [];

    final color = BoardMatrix.getColor(boxColor);
    final centerColor = BoardMatrix.getColor(centerTint);

    for (int x = startX; x <= endX; x++) {
      for (int y = startY; y <= endY; y++) {
        final border = (centerTint != BoardMatrix.white) &&
                (centerTint != BoardMatrix.center)
            ? Border.all(color: black)
            : Border(
                top: BorderSide(color: y == startY ? black : color),
                bottom: BorderSide(color: y == endY ? black : color),
                left: BorderSide(color: x == startX ? black : color),
                right: BorderSide(color: x == endX ? black : color),
              );

        final tileColorData = TileColorData(
          x: x,
          y: y,
          color: BoardMatrix.isCenterColored(centerTint, boxColor, x, y)
              ? centerColor
              : color,
          border: border,
        );
        data.add(tileColorData);
      }
    }
    return data;
  }

  addGameLog(String log) {
    _gameLogs.add(log);
    _gameLogs.refresh();
  }

  rollDice() async {
    if (_hasPlayerRolled.value) {
      addGameLog("Kindly use the current roll to access the dice again.");
      return;
    }
    _hasPlayerRolled(true);

    final newDice1 = randomRoll;
    final newDice2 = randomRoll;

    await animateIncrement(_dice1, newDice1);
    await animateIncrement(_dice2, newDice2);

    // a double six.
    if (dice1 == 6 && dice2 == 6) {
      addGameLog(
          "Yay! you have a double six. You get to play agin after this round.");
      _isPlayerRollingAgain(true);
    }
    switchCurrentPlayerIfNeeded();
  }

  calculatePiecePath(PlayerPiece piece) {
    setPath([]);

    final isPieceWithinParent = BoardMatrix.isPieceWithinItsParent(piece);

    if (isPieceWithinParent) {
      if (dice1 == 6 || dice2 == 6) {
        // changes six to 1 so the piece just moves to the start position.
        calculatePiecePathWithRoll(
          piece,
          1,
          boardPaths,
          exitHomeDisplay,
        );
      } else {
        addGameLog("You need at least a six to bring out a piece.");
      }
    } else if (!BoardMatrix.isItemAtWinSection(piece)) {
      final totalRoll = dice1 + dice2;

      final List<BoardPath> boardPaths = [];

      if (dice1 != 0) {
        calculatePiecePathWithRoll(piece, dice1, boardPaths);
      }
      if (dice2 != 0) {
        calculatePiecePathWithRoll(piece, dice2, boardPaths);
      }
      if (totalRoll != 0) {
        calculatePiecePathWithRoll(piece, totalRoll, boardPaths);
      }

      setPath(boardPaths);
    }
  }

  calculatePiecePathWithRoll(
    PlayerPiece piece,
    int totalRow,
    List<BoardPath> boardPaths, [
    String? displayText,
  ]) {
    int x = piece.x;
    int y = piece.y;

    // named loop for easy termination.
    looper:
    for (var count = 0; count < totalRow; count++) {
      final playerPiece = PlayerPiece(x, y, piece.color);
      final (newX, newY) = BoardMatrix.calculatePieceNextPosition(playerPiece);

      final isLastLoop = count == totalRow - 1;

      //a value was generated for the next position. this check is important else the system would misbehave when the player
      //gets to the roll 1 to exit stage where both newX and newY would both be null is count is 1.
      if (newX != null || newY != null) {
        x = newX ?? x;
        y = newY ?? y;

        final newBoardPath = BoardPath(
          x,
          y,
          isLastLoop,
          totalRow,
          piece.x,
          piece.y,
          displayText ?? totalRow.toString(),
        );
        final clashingPath =
            boardPaths.firstWhereOrNull((path) => path.x == x && path.y == y);

        // if a current board path already exists that clash with the current we need to remove it and add the current one provided the current one is an end path.
        // else the current path would not reflect on the step.
        if (clashingPath != null) {
          // if the old one is not an end path and the new one is an end path.
          // if the old one is an end and the current one isn't then nothing is added or removed from the list.
          if (!clashingPath.isEnd && newBoardPath.isEnd) {
            boardPaths.remove(clashingPath);
            boardPaths.add(newBoardPath);
          }
        } else {
          boardPaths.add(newBoardPath);
        }
      }

      // this is to check if this is the last item in the loop and would the old position plus 1 equal a win.
      // this uses positions so there is no issue of it clashing with a normal piece movement.
      if (isLastLoop && BoardMatrix.isPieceAtAStepToWinning(playerPiece)) {
        final (winX, winY) = BoardMatrix.calculateWinLocation(playerPiece);
        if (winX != null && winY != null) {
          final winBoardPath = BoardPath(
            winX,
            winY,
            true,
            totalRow,
            piece.x,
            piece.y,
            winDisplay,
          );
          boardPaths.add(winBoardPath);
        }
      }
      // if no next move (i.e it is already home and needs 1 to exit) stop the loop.
      if (newX == null && newY == null) {
        break looper;
      }
    }
  }

  /// does the player have the capacity to make any move with the current roll data.
  bool isCurrentMovePossible() {
    bool isAnyPlayerAvailiable = false;

    final pieceForPlayer =
        playerPieces.where((piece) => piece.color == currentPlayer);

    looper:
    for (final piece in pieceForPlayer) {
      final isPieceOutside =
          BoardMatrix.isPieceOutsideItsParent(piece, piece.color);
      final isPieceAtWinLocation = BoardMatrix.isItemAtWinSection(piece);
      if (isPieceOutside && !isPieceAtWinLocation) {
        isAnyPlayerAvailiable = true;
        break looper;
      }
    }

    if (!isAnyPlayerAvailiable) {
      addGameLog(
          'You currently do not have a piece to play this move on. Kindly wait till your next turn.');
    }
    return isAnyPlayerAvailiable;
  }

  moveOnToNextAction(int playerCount, String displayText) {
    setPieceIsMoving(false);
    setPath([]);

    if (displayText == exitHomeDisplay) {
      // if the piece left home then either dice 1 or 2 has to be 6 so check which is which and clear it.
      if (dice1 == 6) {
        _dice1(0);
      } else {
        _dice2(0);
      }
    } else if (playerCount == dice1 + dice2) {
      _dice1(0);
      _dice2(0);
    } else if (playerCount == dice1) {
      _dice1(0);
    } else if (playerCount == dice2) {
      _dice2(0);
    }
    switchCurrentPlayerIfNeeded();
  }

  hasPlayerWon() {
    final data =
        playerPieces.where((piece) => BoardMatrix.isPieceAtCenter(piece));

    if (!_winnerList.contains(BoardMatrix.blue) &&
        data.where((element) => element.color == BoardMatrix.blue).length ==
            4) {
      addGameLog("Blue has won the game with the position ${_position.value}");
      _position(_position.value + 1);
      _winnerList.add(BoardMatrix.blue);
    } else if (!_winnerList.contains(BoardMatrix.green) &&
        data.where((element) => element.color == BoardMatrix.green).length ==
            4) {
      addGameLog("Green has won the game with the position ${_position.value}");
      _position(_position.value + 1);
      _winnerList.add(BoardMatrix.green);
    } else if (!_winnerList.contains(BoardMatrix.yellow) &&
        data.where((element) => element.color == BoardMatrix.yellow).length ==
            4) {
      addGameLog(
          "Yellow has won the game with the position ${_position.value}");
      _position(_position.value + 1);
      _winnerList.add(BoardMatrix.yellow);
    } else if (!_winnerList.contains(BoardMatrix.red) &&
        data.where((element) => element.color == BoardMatrix.red).length == 4) {
      addGameLog("Red has won the game with the position ${_position.value}");
      _position(_position.value + 1);
      _winnerList.add(BoardMatrix.red);
    }
  }

  switchCurrentPlayerIfNeeded() {
    if (dice1 != 6 && dice2 != 6) {
      final isMovePossible = isCurrentMovePossible();
      if (!isMovePossible) {
        _dice1(0);
        _dice2(0);
      }
    }
    if (dice1 == 6 || dice2 == 6) {
      // an error came up if a die had six when it had won.
      final data = playerPieces.where((piece) =>
          BoardMatrix.isPieceAtCenter(piece) && piece.color == currentPlayer);
      if (data.length == 4) {
        _dice1(0);
        _dice1(0);
      }
    }

    //if both move are used up then proceed.
    if (dice1 == 0 && dice2 == 0) {
      _hasPlayerRolled(false);
      if (_isPlayerRollingAgain.value) {
        _isPlayerRollingAgain(false);
      } else {
        if (currentPlayer == 4) {
          _currentPlayer(
              1); // player numbers are between 1 and 4 for green, yellow, red amd blue.
        } else {
          _currentPlayer(currentPlayer + 1);
        }
      }
    }

    hasPlayerWon();
  }

  resetDice() {
    _dice1(0);
    _dice2(0);
  }

  animateIncrement(RxInt value, int newValue) async {
    final oldValue = value.value;
    if (oldValue > newValue) {
      for (var count = oldValue; count >= newValue; count--) {
        await Future.delayed(fastDuration);
        value(count);
      }
    } else {
      for (var count = oldValue; count <= newValue; count++) {
        await Future.delayed(fastDuration);
        value(count);
      }
    }
  }
}
