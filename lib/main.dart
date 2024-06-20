import 'package:ludo/common_libs.dart';

void main() async {
  await initializeApplication();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = Get.find<RouterController>().router;

    return GetMaterialApp.router(
      routerDelegate: appRouter.delegate(),
      routeInformationParser: appRouter.defaultRouteParser(),
      debugShowCheckedModeBanner: false,
      title: appName,
    );
  }
}
