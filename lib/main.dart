import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/services/settings_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/biometric_service.dart';
import 'screens/lock_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final settingsService = SettingsService();
  final notificationService = NotificationService();
  final biometricService = BiometricService();
  
  await settingsService.init();
  await notificationService.init();
  await biometricService.init();
  
  runApp(ZionOSApp(
    settingsService: settingsService,
    notificationService: notificationService,
    biometricService: biometricService,
  ));
}

class ZionOSApp extends StatelessWidget {
  final SettingsService settingsService;
  final NotificationService notificationService;
  final BiometricService biometricService;
  
  const ZionOSApp({
    super.key,
    required this.settingsService,
    required this.notificationService,
    required this.biometricService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: settingsService),
        ChangeNotifierProvider.value(value: notificationService),
        ChangeNotifierProvider.value(value: biometricService),
      ],
      child: Consumer<SettingsService>(
        builder: (context, settings, child) {
          return MaterialApp(
            title: 'Zion OS 2027',
            debugShowCheckedModeBanner: false,
            theme: _getThemeData(settings),
            home: const LockScreen(),
          );
        },
      ),
    );
  }
  
  ThemeData _getThemeData(SettingsService settings) {
    Color primaryColor;
    switch (settings.themeColor) {
      case 'Turquoise': primaryColor = const Color(0xFF00BCD4); break;
      case 'Cyan': primaryColor = Colors.cyan; break;
      case 'Green': primaryColor = Colors.green; break;
      case 'Blue': primaryColor = Colors.blue; break;
      case 'Purple': primaryColor = Colors.purple; break;
      default: primaryColor = const Color(0xFF00BCD4);
    }
    
    return ThemeData.dark().copyWith(
      primaryColor: primaryColor,
      colorScheme: ColorScheme.dark(primary: primaryColor),
      scaffoldBackgroundColor: Colors.black,
      textTheme: _getTextTheme(settings),
    );
  }
  
  TextTheme _getTextTheme(SettingsService settings) {
    return const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
    );
  }
}
