import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'src/features/splash/splash_screen.dart';
import 'src/features/onboarding/onboarding_screen.dart';
import 'src/features/lock/lock_screen.dart';
import 'src/features/desktop/responsive_desktop.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
  ));
  
  runApp(const ZionOS());
}

class ZionOS extends StatelessWidget {
  const ZionOS({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zion OS v3.3',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.green,
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),
        '/lock': (context) => const LockScreen(),
        '/home': (context) => const ResponsiveDesktop(),
      },
    );
  }
}
