import 'package:ludo/common_libs.dart';
import 'package:ludo/models/player_piece.dart';
import 'package:ludo/models/tile_data.dart';

/*

The board is basically composed of x and y coordinates from [0,0] to [14,14]. 
The pieces are always in one of these coordinates based on their color and the current move.

green     y|w      yellow
[00,00]		[07,00]		[10,00]		//start coordinate of rectangle 
[06,06]		[09,06]		[15,06]		//end coordinate of rectangle	
[01,00]		[00,02]		[02,00]		//color combination of squares within the rectangle. the color combination is in the format [color, center] the color is for the fill while the center is used if it is a mixed tile like y|w..

g|w       center   b|w
[00,07]		[07,07]		[10,07]   
[06,09]		[09,09]		[15,09]
[00,01]		[06,06]		[00,04]	

red       r|w     blue
[00,10]		[07,10]		[10,10] 
[06,15]		[09,15]		[15,15]
[03,00]		[00,03]	 [04,00]
 
*/

class BoardMatrix {
  static const centerX = 7;
  static const centerY = 7;

  static const startGX = 0;
  static const startGY = 0;
  static const endGX = 5;
  static const endGY = 5;

  static const startYX = 9;
  static const startYY = 0;
  static const endYX = 14;
  static const endYY = 5;

  static const startRX = 0;
  static const startRY = 9;
  static const endRX = 5;
  static const endRY = 14;

  static const startBX = 9;
  static const startBY = 9;
  static const endBX = 14;
  static const endBY = 14;

  static const white = 0;
  static const green = 1;
  static const yellow = 2;
  static const red = 3;
  static const blue = 4;
  static const center = 6;
  static final List<TileData> tilePositions = [
    //Set 1
    TileData(startGX, startGY, endGX, endGY, green, white), //green
    TileData(6, 0, 8, 5, white, yellow), // y|w
    TileData(startYX, startYY, endYX, endYY, yellow, white), //yellow

    //Set 2
    TileData(0, 6, 5, 8, white, green), // g|w
    TileData(6, 6, 8, 8, center, center), //center
    TileData(9, 6, 14, 8, white, blue), //b|w

    //Set 3
    TileData(startRX, startRY, endRX, endRY, red, white), //red
    TileData(6, 9, 8, 14, white, red), //r|w
    TileData(startBX, startBY, endBX, endBY, blue, white), //blue
  ];

  static final piecePosition = [
    //green
    PlayerPiece(1, 1, green),
    PlayerPiece(1, 4, green),
    PlayerPiece(4, 4, green),
    PlayerPiece(4, 1, green),

    //yellow

    PlayerPiece(10, 1, yellow),
    PlayerPiece(10, 4, yellow),
    PlayerPiece(13, 1, yellow),
    PlayerPiece(13, 4, yellow),

    //red
    PlayerPiece(1, 10, red),
    PlayerPiece(1, 13, red),
    PlayerPiece(4, 10, red),
    PlayerPiece(4, 13, red),

    //blue
    PlayerPiece(10, 10, blue),
    PlayerPiece(10, 13, blue),
    PlayerPiece(13, 10, blue),
    PlayerPiece(13, 13, blue),
  ];

  static Color getColor(int color) {
    if (color == green) {
      return Colors.green;
    } else if (color == yellow) {
      return Colors.yellow;
    } else if (color == red) {
      return Colors.red;
    } else if (color == blue) {
      return Colors.blue;
    } else if (color == white) {
      return Colors.white;
    } else if (color == center) {
      return Colors.white;
    } else {
      return Colors.green;
    }
  }

  /// It basically checks if the piece is the same color as the parent and if it is then checks which color and if it is within the boundary of that color.
  static bool isPieceOutsideItsParent(PlayerPiece piece, int parent) {
    if (piece.color != parent) {
      return false;
    }

    // if piece is within the win section then fail.
    if (piece.x >= centerX - 1 &&
        piece.x <= centerX + 1 &&
        piece.y >= centerY - 1 &&
        piece.y <= centerY + 1) {
      return false;
    }

    if (piece.color == green &&
        piece.x > startGX &&
        piece.x < endGX &&
        piece.y > startGY &&
        piece.y < endGY) {
      return false;
    }

    if (piece.color == yellow &&
        piece.x > startYX &&
        piece.x < endYX &&
        piece.y > startYY &&
        piece.y < endYY) {
      return false;
    }

    if (piece.color == red &&
        piece.x > startRX &&
        piece.x < endRX &&
        piece.y > startRY &&
        piece.y < endRY) {
      return false;
    }

    if (piece.color == blue &&
        piece.x > startBX &&
        piece.x < endBX &&
        piece.y > startBY &&
        piece.y < endBY) {
      return false;
    }

    return true;
  }

  static bool isItemAtWinSection(PlayerPiece piece) {
    return (piece.x > centerX - 2 &&
        piece.x < centerX + 2 &&
        piece.y > centerY - 2 &&
        piece.y < centerY + 2);
  }

  static bool isPieceWithinItsParent(PlayerPiece piece) {
    if (piece.color == green &&
        piece.x > startGX &&
        piece.x < endGX &&
        piece.y > startGY &&
        piece.y < endGY) {
      return true;
    }

    if (piece.color == yellow &&
        piece.x > startYX &&
        piece.x < endYX &&
        piece.y > startYY &&
        piece.y < endYY) {
      return true;
    }

    if (piece.color == red &&
        piece.x > startRX &&
        piece.x < endRX &&
        piece.y > startRY &&
        piece.y < endRY) {
      return true;
    }

    if (piece.color == blue &&
        piece.x > startBX &&
        piece.x < endBX &&
        piece.y > startBY &&
        piece.y < endBY) {
      return true;
    }

    return false;
  }

  static bool isPieceThePlayerPiece(PlayerPiece piece, int player) =>
      piece.color == player;

  static bool isPieceAtCenter(
    PlayerPiece piece,
  ) =>
      piece.x >= centerX - 1 &&
      piece.x <= centerX + 1 &&
      piece.y >= centerY - 1 &&
      piece.y <= centerY + 1;

  /// This is to check if it is a g|w kind of piece or just a g piece. the same applies for all other colors.
  static bool isCenterColored(int center, int color, int x, int y) {
    // if white then the set is entirely the ddefault color.
    if (center == white) {
      return false;
    }

    // does the color at the middle section between the player decks since they are all on the centerX or cenerY axis.
    // if checks if it not equals to the first one for each player since that tile should be white.
    else if (x == BoardMatrix.centerX || y == BoardMatrix.centerY) {
      if (center == green) {
        return x != startGX;
      } else if (center == yellow) {
        return y != startYY;
      } else if (center == red) {
        return y != endRY;
      } else if (center == blue) {
        return x != endBX;
      } else {
        return true;
      }
    }

    //this basically checks if it is at the start of each parent.
    else if (x == centerX + 1 && center == yellow && y == startYY + 1) {
      return true;
    } else if (x == centerX - 1 && center == red && y == endRY - 1) {
      return true;
    } else if (y == centerY - 1 && center == green && x == startGX + 1) {
      return true;
    } else if (y == centerY + 1 && center == blue && x == endBX - 1) {
      return true;
    } else {
      return false;
    }
  }

  static bool killPieceOnCurrentPieceLocation(PlayerPiece piece) {
    final data = piecePosition.where((element) =>
        element.x == piece.x &&
        element.y == piece.y &&
        element.color != piece.color);

    if (data.isNotEmpty) {
      for (final item in data) {
        item.x = item.initX;
        item.y = item.initY;
      }

      movePieceToWinLocation(piece);
      return true;
    }
    return false;
  }

  static movePieceToWinLocation(PlayerPiece piece) {
    if (piece.color == green) {
      piece.x = centerX - 1;
      piece.y = centerY - 1;
    } else if (piece.color == yellow) {
      piece.x = centerX + 1;
      piece.y = centerY - 1;
    } else if (piece.color == blue) {
      piece.x = centerX + 1;
      piece.y = centerY + 1;
    } else if (piece.color == red) {
      piece.x = centerX - 1;
      piece.y = centerY + 1;
    }
  }

  ///checks if the piece is just at the edge where 1 is needed to move to win.
  static bool isPieceAtAStepToWinning(PlayerPiece piece) {
    if (piece.color == green && piece.x == centerX - 2 && piece.y == centerY) {
      return true;
    } else if (piece.color == yellow &&
        piece.x == centerX &&
        piece.y == centerY - 2) {
      return true;
    } else if (piece.color == red &&
        piece.x == centerX &&
        piece.y == centerY + 2) {
      return true;
    } else if (piece.color == blue &&
        piece.y == centerY &&
        piece.x == centerX + 2) {
      return true;
    } else {
      return false;
    }
  }

//returns where the piece should go to on win.
  static (int?, int?) calculateWinLocation(PlayerPiece piece) {
    if (piece.color == green && piece.x == centerX - 2 && piece.y == centerY) {
      return (centerX - 1, centerY);
    } else if (piece.color == yellow &&
        piece.x == centerX &&
        piece.y == centerY - 2) {
      return (centerX, centerY - 1);
    } else if (piece.color == red &&
        piece.x == centerX &&
        piece.y == centerY + 2) {
      return (centerX, centerY + 1);
    } else if (piece.color == blue &&
        piece.y == centerY &&
        piece.x == centerX + 2) {
      return (centerX + 1, centerY);
    } else {
      return (null, null);
    }
  }

  static (int?, int?) calculatePieceNextPosition(PlayerPiece piece) {
    //start green
    if (piece.x < endGX && piece.y < endGY && piece.color == green) {
      return (startGX + 1, endGY + 1);
    }

    //start yellow
    else if (piece.x > startYX && piece.y < endYY && piece.color == yellow) {
      return (startYX - 1, startYY + 1);
    }

    //start blue
    else if (piece.x > startBX && piece.y > startBY && piece.color == blue) {
      return (endBX - 1, startBY - 1);
    }

    //start red
    else if (piece.x < endRX && piece.y > startRY && piece.color == red) {
      return (endRX + 1, piece.y = endRY - 1);
    }

    //upper green && upper blue
    else if (piece.y == centerY - 1) {
      int? y, x;
      if (piece.x == centerX - 2) {
        y = piece.y - 1;
      } else if (piece.x == 14) {
        y = piece.y + 1;
      }

      if (piece.x < 14) {
        x = piece.x + 1;
      }
      return (x, y);
    }

    // lower blue && lower green
    else if (piece.y == centerY + 1) {
      int? y, x;
      if (piece.x == centerX + 2) {
        y = piece.y + 1;
      } else if (piece.x == 0) {
        y = piece.y - 1;
      }

      if (piece.x > 0) {
        x = piece.x - 1;
      }
      return (x, y);
    }

    // left yellow && left red
    else if (piece.x == centerX - 1) {
      int? y, x;
      if (piece.y == centerY + 2) {
        x = piece.x - 1;
      } else if (piece.y == 0) {
        x = piece.x + 1;
      }

      if (piece.y > 0) {
        y = piece.y - 1;
      }
      return (x, y);
    }

    //right yellow && right blue
    else if (piece.x == centerX + 1) {
      int? y, x;
      if (piece.y == centerY - 2) {
        x = piece.x + 1;
      } else if (piece.y == 14) {
        x = piece.x - 1;
      }

      if (piece.y < 14) {
        y = piece.y + 1;
      }
      return (x, y);
    }

    // center yellow
    else if (piece.x == centerX && piece.y < centerY - 2) {
      int? y, x;
      if (piece.color == yellow) {
        y = piece.y + 1;
      } else if (piece.color != yellow) {
        x = piece.x + 1;
      }
      return (x, y);
    }

    // center red
    else if (piece.x == centerX && piece.y > centerY + 2) {
      int? y, x;
      if (piece.color == red) {
        y = piece.y - 1;
      } else if (piece.color != red) {
        x = piece.x - 1;
      }
      return (x, y);
    }

    // center blue
    else if (piece.y == centerY && piece.x > centerX + 2) {
      int? y, x;
      if (piece.color == blue) {
        x = piece.x - 1;
      } else if (piece.color != blue) {
        y = piece.y + 1;
      }
      return (x, y);
    }

    // center green
    else if (piece.y == centerY && piece.x < centerX - 2) {
      int? y, x;
      if (piece.color == green) {
        x = piece.x + 1;
      } else if (piece.color != green) {
        y = piece.y - 1;
      }
      return (x, y);
    } else {
      return (null, null);
    }
  }
}
