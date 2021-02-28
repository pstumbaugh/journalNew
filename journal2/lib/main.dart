import 'imports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight
  ]);

  await DatabaseManager.initalize();
  runApp(JournalApp(preferences: await SharedPreferences.getInstance()));
}
