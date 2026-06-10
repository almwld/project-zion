import 'package:flutter/material.dart';

class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<void> navigateTo(String routeName, {dynamic arguments}) async {
    await navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);
  }

  Future<void> navigateReplacementTo(String routeName, {dynamic arguments}) async {
    await navigatorKey.currentState!.pushReplacementNamed(routeName, arguments: arguments);
  }

  void goBack() {
    navigatorKey.currentState!.pop();
  }
}

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String lock = '/lock';
  static const String home = '/home';
  static const String terminal = '/terminal';
  static const String wifi = '/wifi';
  static const String siAgent = '/si_agent';
  static const String fileManager = '/file_manager';
  static const String browser = '/browser';
  static const String textEditor = '/text_editor';
  static const String settings = '/settings';
  static const String networkAnalyzer = '/network_analyzer';
  static const String networkInfra = '/network_infra';
  static const String networkControl = '/network_control';
  static const String processManager = '/process_manager';
  static const String systemMonitor = '/system_monitor';
  static const String resourcesCenter = '/resources_center';
  static const String performanceMonitor = '/performance_monitor';
  static const String vulnerabilityScanner = '/vulnerability_scanner';
  static const String securityCenter = '/security_center';
  static const String encryptionCenter = '/encryption_center';
  static const String stealthMode = '/stealth_mode';
  static const String taskScheduler = '/task_scheduler';
  static const String packageManager = '/package_manager';
  static const String backupManager = '/backup_manager';
  static const String logViewer = '/log_viewer';
  static const String diskAnalyzer = '/disk_analyzer';
  static const String reportGenerator = '/report_generator';
  static const String analyticsCenter = '/analytics_center';
  static const String businessAnalytics = '/business_analytics';
  static const String predictiveAnalytics = '/predictive_analytics';
  static const String apiIntegration = '/api_integration';
  static const String cloudCenter = '/cloud_center';
  static const String blockchainCenter = '/blockchain_center';
  static const String integrationCenter = '/integration_center';
  static const String aiControl = '/ai_control';
  static const String predictiveCenter = '/predictive_center';
  static const String containerManager = '/container_manager';
  static const String roboticsCenter = '/robotics_center';
  static const String energyCenter = '/energy_center';
  static const String smartCityCenter = '/smart_city_center';
  static const String geospatialCenter = '/geospatial_center';
  static const String productivityCenter = '/productivity_center';
  static const String developerCenter = '/developer_center';
  static const String learningCenter = '/learning_center';
  static const String docsCenter = '/docs_center';
  static const String helpCenter = '/help_center';
  static const String infoCenter = '/info_center';
  static const String gamesCenter = '/games_center';
  static const String mediaCenter = '/media_center';
  static const String arCenter = '/ar_center';
  static const String qrScanner = '/qr_scanner';
  static const String bootCenter = '/boot_center';
  static const String powerManagement = '/power_management';
  static const String systemCleaner = '/system_cleaner';
  static const String maintenanceCenter = '/maintenance_center';
  static const String qualityAssurance = '/quality_assurance';
  static const String governanceCenter = '/governance_center';
  static const String notificationCenter = '/notification_center';
  static const String communicationCenter = '/communication_center';
  static const String appStore = '/app_store';
  static const String simulationCenter = '/simulation_center';
  static const String automationCenter = '/automation_center';
  static const String distros = '/distros';
  static const String nixos = '/nixos';
}
