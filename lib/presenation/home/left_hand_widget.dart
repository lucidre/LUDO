import 'package:ludo/common_libs.dart';

class LeftHandWidget extends StatelessWidget {
  const LeftHandWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(space16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(space12),
        color: white,
      ),
      child: buildBody(),
    );
  }

  buildBody() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'GAME LOGS',
          style: font500S14.copyWith(
            fontWeight: FontWeight.bold,
            height: 1,
          ),
        ).fadeInAndMoveFromBottom(),
        verticalSpacer4,
        Divider(color: black.withOpacity(.1)).fadeInAndMoveFromBottom(),
        verticalSpacer4,
        Expanded(
          child: GetX<HomeController>(builder: (controller) {
            final logs = controller.gameLogs;
            return ListView.separated(
              physics: const BouncingScrollPhysics(),
              itemCount: logs.length,
              itemBuilder: (ctx, index) {
                return Text(
                  '${index + 1}. ${logs[index]}',
                  style: font500S12.copyWith(
                    color: black,
                    fontWeight: FontWeight.bold,
                  ),
                ).fadeInAndMoveFromBottom(
                  delay: Duration.zero,
                  animationDuration: fastDuration,
                );
              },
              separatorBuilder: (_, __) {
                return Container(
                  margin: const EdgeInsets.only(top: space8, bottom: space8),
                  color: black.withOpacity(.1),
                  height: 1,
                  width: double.infinity,
                ).fadeInAndMoveFromBottom(
                  delay: Duration.zero,
                  animationDuration: fastDuration,
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
