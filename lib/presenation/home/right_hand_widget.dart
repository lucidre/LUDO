import 'package:flutter/cupertino.dart';
import 'package:ludo/common_libs.dart';
import 'package:ludo/models/board_matrix.dart';

class RightHandWidget extends StatelessWidget {
  const RightHandWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(child: buildGameRules()),
        verticalSpacer32,
        buildCurrentPlayer(),
        verticalSpacer32,
        buildCurrentRoll(),
        verticalSpacer16,
        AppBtn.from(
          onPressed: () async {
            final controller = Get.find<HomeController>();
            await controller.rollDice();
          },
          isSecondary: false,
          padding: const EdgeInsets.all(space24),
          borderRadius: space12,
          text: 'ROLL',
          icon: CupertinoIcons.gamecontroller_fill,
        ),
      ],
    );
  }

  Container buildCurrentRoll() {
    return Container(
      height: 300,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(space16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(space12),
        color: white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CURRENT ROLL',
            style: font500S14.copyWith(
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ).fadeInAndMoveFromBottom(),
          verticalSpacer4,
          Divider(color: black.withOpacity(.1)).fadeInAndMoveFromBottom(),
          verticalSpacer4,
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GetX<HomeController>(builder: (controller) {
                  return Text(
                    '${controller.dice1}',
                    style: font700S24.copyWith(
                      fontSize: 180,
                      height: 1,
                    ),
                  ).fadeInAndMoveFromBottom();
                }),
                horizontalSpacer12,
                Container(
                  width: 5,
                  height: 150,
                  decoration: BoxDecoration(
                    color: black,
                    borderRadius: BorderRadius.circular(space8),
                  ),
                ).fadeInAndMoveFromBottom(),
                horizontalSpacer12,
                GetX<HomeController>(builder: (controller) {
                  return Text(
                    '${controller.dice2}',
                    style: font700S24.copyWith(
                      fontSize: 180,
                      height: 1,
                    ),
                  ).fadeInAndMoveFromBottom();
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container buildCurrentPlayer() {
    return Container(
      height: 300,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(space16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(space12),
        color: white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CURRENT PLAYER',
            style: font500S14.copyWith(
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ).fadeInAndMoveFromBottom(),
          verticalSpacer4,
          Divider(color: black.withOpacity(.1)).fadeInAndMoveFromBottom(),
          verticalSpacer4,
          Expanded(
            child: Center(
              child: GetX<HomeController>(builder: (controller) {
                final color = BoardMatrix.getColor(controller.currentPlayer);
                return Icon(
                  CupertinoIcons.person_crop_circle_fill,
                  color: color,
                  size: 200,
                ).fadeInAndMoveFromBottom();
              }),
            ),
          ),
        ],
      ),
    );
  }

  Container buildGameRules() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(space16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(space12),
        color: white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'RULES OF THE GAME',
            style: font500S14.copyWith(
              fontWeight: FontWeight.bold,
              height: 1,
            ),
          ).fadeInAndMoveFromBottom(),
          verticalSpacer4,
          Divider(color: black.withOpacity(.1)).fadeInAndMoveFromBottom(),
          verticalSpacer4,
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                gameRule,
                style: font500S14.copyWith(color: black),
              ),
            ),
          )
        ],
      ),
    );
  }
}
