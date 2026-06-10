import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/core/navigation/navigation_service.dart';
import 'src/features/splash/splash_screen.dart';
import 'src/features/onboarding/onboarding_screen.dart';
import 'src/features/lock/lock_screen.dart';
import 'src/features/desktop/responsive_desktop.dart';

// استيراد جميع التطبيقات
import 'src/features/terminal/cosmic_terminal.dart';
import 'src/features/wifi/zion_wifi_panel.dart';
import 'src/features/si/advanced_si_control_panel.dart';
import 'src/features/windows/advanced_file_explorer.dart';
import 'src/features/windows/advanced_web_browser.dart';
import 'src/features/windows/advanced_text_editor.dart';
import 'src/features/settings/main_settings.dart';
import 'src/features/network/network_analyzer.dart';
import 'src/features/network_infra/network_infrastructure_center.dart';
import 'src/features/network_control/network_control_center.dart';
import 'src/features/system/process_manager.dart';
import 'src/features/system/system_monitor.dart';
import 'src/features/resources/resources_center.dart';
import 'src/features/performance/performance_monitor.dart';
import 'src/features/security/vulnerability_scanner.dart';
import 'src/features/security_center/security_center.dart';
import 'src/features/encryption/encryption_center.dart';
import 'src/features/stealth/stealth_mode.dart';
import 'src/features/scheduler/task_scheduler.dart';
import 'src/features/packages/package_manager.dart';
import 'src/features/backup/backup_manager.dart';
import 'src/features/logs/log_viewer.dart';
import 'src/features/storage/disk_usage_analyzer.dart';
import 'src/features/reports/report_generator.dart';
import 'src/features/analytics/analytics_center.dart';
import 'src/features/business/business_analytics.dart';
import 'src/features/predictive_analytics/predictive_analytics_center.dart';
import 'src/features/api_integration/api_integration_center.dart';
import 'src/features/cloud/cloud_center.dart';
import 'src/features/blockchain/blockchain_center.dart';
import 'src/features/integration/integration_center.dart';
import 'src/features/ai_control/ai_control_center.dart';
import 'src/features/predictive/predictive_center.dart';
import 'src/features/container/container_manager.dart';
import 'src/features/robotics/robotics_center.dart';
import 'src/features/energy/energy_center.dart';
import 'src/features/smart_city/smart_city_center.dart';
import 'src/features/geospatial/geospatial_center.dart';
import 'src/features/productivity/productivity_center.dart';
import 'src/features/developer/developer_center.dart';
import 'src/features/learning/learning_center.dart';
import 'src/features/docs/docs_center.dart';
import 'src/features/help/help_center.dart';
import 'src/features/info/info_center.dart';
import 'src/features/games/games_center.dart';
import 'src/features/media/media_center.dart';
import 'src/features/ar/ar_center.dart';
import 'src/features/qr/qr_scanner.dart';
import 'src/features/boot/boot_center.dart';
import 'src/features/power/power_management.dart';
import 'src/features/cleaner/system_cleaner.dart';
import 'src/features/maintenance/maintenance_center.dart';
import 'src/features/quality/quality_assurance.dart';
import 'src/features/governance/governance_center.dart';
import 'src/features/notifications/advanced_notification_center.dart';
import 'src/features/communication/communication_center.dart';
import 'src/features/store/app_store.dart';
import 'src/features/simulation/simulation_center.dart';
import 'src/features/automation/automation_center.dart';

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
      navigatorKey: NavigationService().navigatorKey,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.green,
      ),
      initialRoute: isFirstLaunch ? AppRoutes.onboarding : AppRoutes.lock,
      routes: {
        AppRoutes.splash: (context) => const SplashScreen(),
        AppRoutes.onboarding: (context) => const OnboardingScreen(),
        AppRoutes.lock: (context) => const LockScreen(),
        AppRoutes.home: (context) => const ResponsiveDesktop(),
        
        // التطبيقات الأساسية
        AppRoutes.terminal: (context) => const CosmicTerminal(),
        AppRoutes.wifi: (context) => const ZionWifiPanel(),
        AppRoutes.siAgent: (context) => const AdvancedSIControlPanel(),
        AppRoutes.fileManager: (context) => const AdvancedFileExplorer(),
        AppRoutes.browser: (context) => const AdvancedWebBrowser(),
        AppRoutes.textEditor: (context) => const AdvancedTextEditor(),
        AppRoutes.settings: (context) => const MainSettings(),
        
        // أدوات الشبكة
        AppRoutes.networkAnalyzer: (context) => const NetworkAnalyzer(),
        AppRoutes.networkInfra: (context) => const NetworkInfrastructureCenter(),
        AppRoutes.networkControl: (context) => const NetworkControlCenter(),
        
        // أدوات النظام
        AppRoutes.processManager: (context) => const ProcessManager(),
        AppRoutes.systemMonitor: (context) => const SystemMonitor(),
        AppRoutes.resourcesCenter: (context) => const ResourcesCenter(),
        AppRoutes.performanceMonitor: (context) => const PerformanceMonitor(),
        
        // أدوات الأمان
        AppRoutes.vulnerabilityScanner: (context) => const VulnerabilityScanner(),
        AppRoutes.securityCenter: (context) => const SecurityCenter(),
        AppRoutes.encryptionCenter: (context) => const EncryptionCenter(),
        AppRoutes.stealthMode: (context) => const StealthMode(),
        
        // أدوات الإدارة
        AppRoutes.taskScheduler: (context) => const TaskScheduler(),
        AppRoutes.packageManager: (context) => const PackageManager(),
        AppRoutes.backupManager: (context) => const BackupManager(),
        AppRoutes.logViewer: (context) => const LogViewer(),
        AppRoutes.diskAnalyzer: (context) => const DiskUsageAnalyzer(),
        
        // التقارير والتحليلات
        AppRoutes.reportGenerator: (context) => const ReportGenerator(),
        AppRoutes.analyticsCenter: (context) => const AnalyticsCenter(),
        AppRoutes.businessAnalytics: (context) => const BusinessAnalytics(),
        AppRoutes.predictiveAnalytics: (context) => const PredictiveAnalyticsCenter(),
        
        // التكامل والخدمات
        AppRoutes.apiIntegration: (context) => const ApiIntegrationCenter(),
        AppRoutes.cloudCenter: (context) => const CloudCenter(),
        AppRoutes.blockchainCenter: (context) => const BlockchainCenter(),
        AppRoutes.integrationCenter: (context) => const IntegrationCenter(),
        
        // الذكاء الاصطناعي
        AppRoutes.aiControl: (context) => const AIControlCenter(),
        AppRoutes.predictiveCenter: (context) => const PredictiveCenter(),
        
        // البنية التحتية
        AppRoutes.containerManager: (context) => const ContainerManager(),
        AppRoutes.roboticsCenter: (context) => const RoboticsCenter(),
        AppRoutes.energyCenter: (context) => const EnergyCenter(),
        AppRoutes.smartCityCenter: (context) => const SmartCityCenter(),
        AppRoutes.geospatialCenter: (context) => const GeospatialCenter(),
        
        // الإنتاجية
        AppRoutes.productivityCenter: (context) => const ProductivityCenter(),
        AppRoutes.developerCenter: (context) => const DeveloperCenter(),
        AppRoutes.learningCenter: (context) => const LearningCenter(),
        AppRoutes.docsCenter: (context) => const DocsCenter(),
        AppRoutes.helpCenter: (context) => const HelpCenter(),
        AppRoutes.infoCenter: (context) => const InfoCenter(),
        
        // الترفيه
        AppRoutes.gamesCenter: (context) => const GamesCenter(),
        AppRoutes.mediaCenter: (context) => const MediaCenter(),
        AppRoutes.arCenter: (context) => const ARCenter(),
        AppRoutes.qrScanner: (context) => const QRScanner(),
        
        // النظام
        AppRoutes.bootCenter: (context) => const BootCenter(),
        AppRoutes.powerManagement: (context) => const PowerManagement(),
        AppRoutes.systemCleaner: (context) => const SystemCleaner(),
        AppRoutes.maintenanceCenter: (context) => const MaintenanceCenter(),
        AppRoutes.qualityAssurance: (context) => const QualityAssuranceCenter(),
        AppRoutes.governanceCenter: (context) => const GovernanceCenter(),
        
        // الإشعارات والتواصل
        AppRoutes.notificationCenter: (context) => const AdvancedNotificationCenter(),
        AppRoutes.communicationCenter: (context) => const CommunicationCenter(),
        
        // متجر وإضافات
        AppRoutes.appStore: (context) => const AppStore(),
        AppRoutes.simulationCenter: (context) => const SimulationCenter(),
        AppRoutes.automationCenter: (context) => const AutomationCenter(),
      },
    );
  }
}
