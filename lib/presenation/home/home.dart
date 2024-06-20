import 'package:ludo/common_libs.dart';
import 'package:ludo/presenation/home/center_widget.dart';
import 'package:ludo/presenation/home/left_hand_widget.dart';
import 'package:ludo/presenation/home/right_hand_widget.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => AppScaffold(
        backgroundColor: Colors.grey[200],
        body: buildBody(),
      );

  buildBody() {
    return Padding(
      padding: const EdgeInsets.all(space16),
      child: Row(
        children: [
          const Expanded(child: LeftHandWidget()),
          horizontalSpacer16,
          const CenterWidget(),
          horizontalSpacer16,
          const Expanded(child: RightHandWidget()),
        ],
      ),
    );
  }
}
