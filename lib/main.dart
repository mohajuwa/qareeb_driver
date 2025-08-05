import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:qareeb/config/config.dart';
import 'package:qareeb/screen/auth_screen/splash_screen.dart';
import 'package:qareeb/widget/dark_light_mode.dart';
import 'package:qareeb/widget/language_translate.dart';
import 'config/data_store.dart';
import 'firebase_options.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WakelockPlus.enable();
  await GetStorage.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ColorNotifier())],
      child: GetMaterialApp(
        scaffoldMessengerKey: scaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        translations: LocaleString(),
        locale: getData.read("lan2") != null
            ? Locale(getData.read("lan2"), getData.read("lan1"))
            : const Locale('en_US', 'en_US'),
        theme: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          dividerColor: Colors.transparent,
          useMaterial3: false,
        ),
        home: const SplashScreen(),
      ),
    ),
  );
}

Future<void> initPlatformState() async {
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize(Config.oneSignal);
  OneSignal.Notifications.requestPermission(true).then((value) {
    print("Signal value:- $value");
  });
}
