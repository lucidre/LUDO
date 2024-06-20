import 'package:ludo/common_libs.dart';
import 'package:ludo/models/board_matrix.dart';
import 'package:ludo/models/board_path.dart';
import 'package:ludo/models/player_piece.dart';
import 'package:ludo/models/tile_color_data.dart';

class CenterWidget extends StatefulWidget {
  const CenterWidget({super.key});

  @override
  State<CenterWidget> createState() => _CenterWidgetState();
}

class _CenterWidgetState extends State<CenterWidget> {
  @override
  void initState() {
    super.initState();
    final controller = Get.find<HomeController>();
    controller.initPieces();
    controller.generateTileColorData();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(space12),
          color: white,
        ),
        padding: const EdgeInsets.all(space8),
        child: Container(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: black,
              strokeAlign: BorderSide.strokeAlignOutside,
            ),
            borderRadius: BorderRadius.circular(space12),
          ),
          child: buildBody(),
        ),
      ),
    );
  }

  buildBody() {
    return LayoutBuilder(builder: (_, constraint) {
      final width = constraint.maxWidth;
      final tileW = width / 15;

      return Stack(
        children: [
          // seperate getx to minimize rebuilds.
          GetX<HomeController>(
            builder: (controller) {
              final tiles = controller.tileColorData;
              final paths = controller.boardPaths;
              return Stack(
                children: tiles
                    .map((tile) => generateTile(tile, tileW, paths))
                    .toList(),
              );
            },
          ),
          GetX<HomeController>(
            builder: (controller) {
              final dices = controller.playerPieces;
              return Stack(
                children: dices
                    .map((dice) =>
                        generateDices(controller.currentPlayer, dice, tileW))
                    .toList(),
              );
            },
          ),
        ],
      );
    });
  }

  /// align uses the coordinate (0 for the center location, 1 for the positive and -1 for the negative on both axis.
  double calculatePosition(num coordinate) {
    if (coordinate == 0) return -1;
    if (coordinate == 14) return 1;
    return (coordinate - 7) / 7;
  }

  Widget generateTile(TileColorData tile, double width, List<BoardPath> paths) {
    final BoardPath? boardPath =
        paths.firstWhereOrNull((path) => tile.x == path.x && tile.y == path.y);

    return AnimatedAlign(
      duration: const Duration(milliseconds: 200),
      alignment:
          Alignment(calculatePosition(tile.x), calculatePosition(tile.y)),
      child: InkWell(
        onTap: () {
          if (boardPath?.isEnd == true) {
            final controller = Get.find<HomeController>();
            final piece = controller.playerPieces.firstWhereOrNull((element) =>
                element.x == boardPath!.pieceX &&
                element.y == boardPath.pieceY);

            if (piece != null) {
              onPieceClicked(piece, boardPath!);
            }
          }
        },
        child: AnimatedContainer(
          alignment: Alignment.center,
          duration: fastDuration,
          width: width,
          height: width,
          decoration: BoxDecoration(
            color: Color.lerp(
              boardPath != null ? pink : tile.color,
              tile.color,
              boardPath != null
                  ? boardPath.isEnd == true
                      ? 0.3
                      : 0.7
                  : 1,
            ),
            border: tile.border,
          ),
          child: Text(
            boardPath?.isEnd == true ? boardPath?.display ?? '' : '',
            style: font700S16.copyWith(
              color: white,
            ),
          ),
        ),
      ),
    );
  }

  onPieceClicked(PlayerPiece piece, BoardPath boardPath) {
    final controller = Get.find<HomeController>();
    final currentPlayer = controller.currentPlayer;
    if (controller.isPieceMoving) {
      controller.addGameLog('Please wait a little, a piece is still moving.');
      return;
    }
    if (currentPlayer != piece.color) {
      controller.addGameLog('Illegal move!!. It is not this player turn.');
      return;
    }

    controller.setPieceIsMoving(true);
    movePiece(
      boardPath.dieCount,
      boardPath.dieCount,
      piece,
      boardPath.display,
    );
  }

  movePiece(
    int count,
    int total,
    PlayerPiece player,
    String display,
  ) async {
    await Future.delayed(medDuration);

    final (int? x, int? y) = BoardMatrix.calculatePieceNextPosition(player);
    player.x = x ?? player.x;
    player.y = y ?? player.y;

    final controller = Get.find<HomeController>();
    controller.refreshPieces();

    if (count > 1) {
      count = count - 1;
      movePiece(count, total, player, display);
    } else {
      await Future.delayed(medDuration);
      final hasPieceKilled =
          BoardMatrix.killPieceOnCurrentPieceLocation(player);
      final isOneStepToWin = BoardMatrix.isPieceAtAStepToWinning(player);

      if (hasPieceKilled || isOneStepToWin) {
        if (isOneStepToWin) {
          BoardMatrix.movePieceToWinLocation(player);
        }
        controller
            .addGameLog('Great!. This piece has moved to the win location.');
        controller.refreshPieces();
      }

      controller.moveOnToNextAction(total, display);
    }
  }

  Widget generateDices(int current, PlayerPiece piece, double boxWidth) {
    final x = piece.x;
    final y = piece.y;
    final dieWidth = boxWidth - space16;
    final color = BoardMatrix.getColor(piece.color);

    return AnimatedAlign(
      duration: fastDuration,
      alignment: Alignment(calculatePosition(x), calculatePosition(y)),
      child: IgnorePointer(
        ignoring: !BoardMatrix.isPieceThePlayerPiece(piece, current),
        child: Container(
          width: dieWidth,
          height: dieWidth,
          margin: const EdgeInsets.all(space6),
          decoration: BoxDecoration(
            color: Color.lerp(black, color, 0.8), //adding some contrast.
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: black.withOpacity(.2),
                blurRadius: 5,
                offset: const Offset(2, 2),
              ),
            ],
            border: Border.all(
              color: white,
              width: 2,
            ),
          ),
          child: InkWell(
            onTap: () {
              final controller = Get.find<HomeController>();
              if (piece.color != controller.currentPlayer) {
                controller.addGameLog("It is not this player turn yet.");
                return;
              }
              controller.calculatePiecePath(piece);
            },
          ),
        ),
      ),
    );
  }
}
