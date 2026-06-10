import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'src/core/theme/theme_engine.dart';
import 'src/features/desktop/glass_desktop.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final theme = ThemeEngine();
  await theme.loadSettings();
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  
  runApp(ZionOS(theme: theme));
}

class ZionOS extends StatelessWidget {
  final ThemeEngine theme;
  const ZionOS({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zion OS v3.0',
      debugShowCheckedModeBanner: false,
      theme: theme.lightTheme,
      darkTheme: theme.darkTheme,
      themeMode: ThemeMode.dark,
      home: const GlassDesktop(),
    );
  }
}
