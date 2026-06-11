import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/features/splash/splash_screen.dart';
import 'src/features/onboarding/onboarding_screen.dart';
import 'src/features/lock/lock_screen.dart';
import 'src/features/desktop/responsive_desktop.dart';

// استيراد التطبيقات (بالمسارات الصحيحة من الشجرة)
import 'cosmic_terminal.dart';
import 'src/features/wifi/zion_wifi_panel.dart';
import 'src/features/si/advanced_si_control_panel.dart';
import 'src/features/windows/advanced_file_explorer.dart';
import 'src/features/windows/advanced_web_browser.dart';
import 'src/features/windows/advanced_text_editor.dart';
import 'src/features/settings/main_settings.dart';
import 'src/features/network/network_analyzer.dart';
import 'src/features/system/process_manager.dart';
import 'src/features/system/system_monitor.dart';
import 'src/features/security/vulnerability_scanner.dart';
import 'src/features/security_center/security_center.dart';

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
  
  final prefs = await SharedPreferences.getInstance();
  final isFirstLaunch = prefs.getBool('first_launch') ?? true;
  
  if (isFirstLaunch) {
    await prefs.setBool('first_launch', false);
  }
  
  runApp(ZionOS(isFirstLaunch: isFirstLaunch));
}

class ZionOS extends StatelessWidget {
  final bool isFirstLaunch;
  const ZionOS({super.key, required this.isFirstLaunch});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zion OS v3.3',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.green,
      ),
      initialRoute: isFirstLaunch ? '/onboarding' : '/lock',
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/lock': (context) => const LockScreen(),
        '/home': (context) => const ResponsiveDesktop(),
        
        // التطبيقات (بالمسارات الصحيحة)
        '/terminal': (context) => const CosmicTerminal(),
        '/wifi': (context) => const ZionWifiPanel(),
        '/si_agent': (context) => const AdvancedSIControlPanel(),
        '/file_manager': (context) => const AdvancedFileExplorer(),
        '/browser': (context) => const AdvancedWebBrowser(),
        '/text_editor': (context) => const AdvancedTextEditor(),
        '/settings': (context) => const MainSettings(),
        '/network': (context) => const NetworkAnalyzer(),
        '/processes': (context) => const ProcessManager(),
        '/monitor': (context) => const SystemMonitor(),
        '/scanner': (context) => const VulnerabilityScanner(),
        '/security': (context) => const SecurityCenter(),
      },
    );
  }
}
