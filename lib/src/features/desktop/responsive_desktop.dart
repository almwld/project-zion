import 'package:flutter/material.dart';
import '../../core/navigation/navigation_service.dart';
import '../../core/utils/responsive_helper.dart';
import '../settings/main_settings.dart';
import '../wifi/zion_wifi_panel.dart';
import '../si/advanced_si_control_panel.dart';
import '../windows/advanced_file_explorer.dart';
import '../windows/advanced_web_browser.dart';
import '../windows/advanced_text_editor.dart';
import '../network/network_analyzer.dart';
import '../network_infra/network_infrastructure_center.dart';
import '../network_control/network_control_center.dart';
import '../system/process_manager.dart';
import '../system/system_monitor.dart';
import '../resources/resources_center.dart';
import '../performance/performance_monitor.dart';
import '../security/vulnerability_scanner.dart';
import '../security_center/security_center.dart';
import '../encryption/encryption_center.dart';
import '../stealth/stealth_mode.dart';
import '../scheduler/task_scheduler.dart';
import '../packages/package_manager.dart';
import '../backup/backup_manager.dart';
import '../logs/log_viewer.dart';
import '../storage/disk_usage_analyzer.dart';
import '../reports/report_generator.dart';
import '../analytics/analytics_center.dart';
import '../business/business_analytics.dart';
import '../predictive_analytics/predictive_analytics_center.dart';
import '../api_integration/api_integration_center.dart';
import '../cloud/cloud_center.dart';
import '../blockchain/blockchain_center.dart';
import '../integration/integration_center.dart';
import '../ai_control/ai_control_center.dart';
import '../predictive/predictive_center.dart';
import '../container/container_manager.dart';
import '../robotics/robotics_center.dart';
import '../energy/energy_center.dart';
import '../smart_city/smart_city_center.dart';
import '../geospatial/geospatial_center.dart';
import '../productivity/productivity_center.dart';
import '../developer/developer_center.dart';
import '../learning/learning_center.dart';
import '../docs/docs_center.dart';
import '../help/help_center.dart';
import '../info/info_center.dart';
import '../games/games_center.dart';
import '../media/media_center.dart';
import '../ar/ar_center.dart';
import '../qr/qr_scanner.dart';
import '../boot/boot_center.dart';
import '../power/power_management.dart';
import '../cleaner/system_cleaner.dart';
import '../maintenance/maintenance_center.dart';
import '../quality/quality_assurance.dart';
import '../governance/governance_center.dart';
import '../notifications/advanced_notification_center.dart';
import '../communication/communication_center.dart';
import '../store/app_store.dart';
import '../simulation/simulation_center.dart';
import '../automation/automation_center.dart';
import '../../../cosmic_terminal.dart';

class ResponsiveDesktop extends StatefulWidget {
  const ResponsiveDesktop({super.key});

  @override
  State<ResponsiveDesktop> createState() => _ResponsiveDesktopState();
}

class _ResponsiveDesktopState extends State<ResponsiveDesktop> {
  final List<DesktopWindow> _windows = [];
  int _nextWindowId = 1;
  DateTime _currentTime = DateTime.now();
  bool _menuOpen = false;
  int? _draggingWindowId;
  Offset? _dragStart;
  late Timer _clockTimer;

  @override
  void initState() {
    super.initState();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() => _currentTime = DateTime.now());
    });
  }

  void _openWindow(String title, Widget content, {Size size = const Size(850, 650)}) {
    setState(() {
      _windows.add(DesktopWindow(
        id: _nextWindowId++,
        title: title,
        content: content,
        position: Offset(50 + (_windows.length % 5) * 30, 50 + (_windows.length % 5) * 30),
        size: size,
        isMinimized: false,
        isMaximized: false,
      ));
    });
  }

  void _closeWindow(int id) {
    setState(() => _windows.removeWhere((w) => w.id == id));
  }

  void _minimizeWindow(int id) {
    setState(() {
      final index = _windows.indexWhere((w) => w.id == id);
      if (index != -1) _windows[index].isMinimized = true;
    });
  }

  void _restoreWindow(int id) {
    setState(() {
      final index = _windows.indexWhere((w) => w.id == id);
      if (index != -1) _windows[index].isMinimized = false;
    });
  }

  void _maximizeWindow(int id) {
    setState(() {
      final index = _windows.indexWhere((w) => w.id == id);
      if (index != -1) {
        _windows[index].isMaximized = !_windows[index].isMaximized;
        if (_windows[index].isMaximized) {
          _windows[index].savedSize = _windows[index].size;
          _windows[index].savedPosition = _windows[index].position;
          _windows[index].size = const Size(double.infinity, double.infinity);
          _windows[index].position = Offset.zero;
        } else {
          _windows[index].size = _windows[index].savedSize;
          _windows[index].position = _windows[index].savedPosition;
        }
      }
    });
  }

  void _bringToFront(int id) {
    final index = _windows.indexWhere((w) => w.id == id);
    if (index != -1 && index != _windows.length - 1) {
      setState(() {
        final window = _windows.removeAt(index);
        _windows.add(window);
      });
    }
  }

  void _startDragging(int id, Offset startPosition) {
    _draggingWindowId = id;
    _dragStart = startPosition;
  }

  void _updateDragging(Offset newPosition) {
    if (_draggingWindowId != null && _dragStart != null) {
      final index = _windows.indexWhere((w) => w.id == _draggingWindowId);
      if (index != -1 && !_windows[index].isMaximized) {
        setState(() {
          _windows[index].position += newPosition - _dragStart!;
          _dragStart = newPosition;
        });
      }
    }
  }

  void _stopDragging() {
    _draggingWindowId = null;
    _dragStart = null;
  }

  void _toggleMenu() => setState(() => _menuOpen = !_menuOpen);

  @override
  void dispose() {
    _clockTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final iconSize = ResponsiveHelper.isMobile(context) ? 40.0 : 48.0;
    final fontSize = ResponsiveHelper.isMobile(context) ? 10.0 : 12.0;
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildBackground(),
          _buildDesktopIcons(iconSize),
          ..._windows.where((w) => !w.isMinimized).map((w) => _buildWindow(w)),
          if (_menuOpen) _buildStartMenu(),
          _buildTaskbar(iconSize, fontSize),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF00FF41), Colors.black],
        ),
      ),
      child: const Center(
        child: Text(
          'ZION OS\nv3.3',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold, shadows: [
            Shadow(color: Color(0xFF00FF41), blurRadius: 10),
          ]),
        ),
      ),
    );
  }

  Widget _buildDesktopIcons(double iconSize) {
    final icons = [
      // التطبيقات الأساسية (الصف الأول)
      {'icon': Icons.terminal, 'label': 'Terminal', 'route': AppRoutes.terminal, 'color': Colors.green},
      {'icon': Icons.wifi, 'label': 'WiFi', 'route': AppRoutes.wifi, 'color': Colors.blue},
      {'icon': Icons.psychology, 'label': 'SI Agent', 'route': AppRoutes.siAgent, 'color': Colors.purple},
      {'icon': Icons.folder, 'label': 'Files', 'route': AppRoutes.fileManager, 'color': Colors.orange},
      {'icon': Icons.public, 'label': 'Browser', 'route': AppRoutes.browser, 'color': Colors.teal},
      {'icon': Icons.edit, 'label': 'Editor', 'route': AppRoutes.textEditor, 'color': Colors.pink},
      {'icon': Icons.settings, 'label': 'Settings', 'route': AppRoutes.settings, 'color': Colors.grey},
      
      // أدوات الشبكة (الصف الثاني)
      {'icon': Icons.network_check, 'label': 'Network', 'route': AppRoutes.networkAnalyzer, 'color': Colors.cyan},
      {'icon': Icons.device_hub, 'label': 'Infra', 'route': AppRoutes.networkInfra, 'color': Colors.blueGrey},
      {'icon': Icons.router, 'label': 'Net Ctrl', 'route': AppRoutes.networkControl, 'color': Colors.lightBlue},
      
      // أدوات النظام (الصف الثالث)
      {'icon': Icons.memory, 'label': 'Processes', 'route': AppRoutes.processManager, 'color': Colors.orange},
      {'icon': Icons.speed, 'label': 'Monitor', 'route': AppRoutes.systemMonitor, 'color': Colors.purple},
      {'icon': Icons.storage, 'label': 'Resources', 'route': AppRoutes.resourcesCenter, 'color': Colors.green},
      {'icon': Icons.speed, 'label': 'Performance', 'route': AppRoutes.performanceMonitor, 'color': Colors.teal},
      
      // أدوات الأمان (الصف الرابع)
      {'icon': Icons.bug_report, 'label': 'Scanner', 'route': AppRoutes.vulnerabilityScanner, 'color': Colors.red},
      {'icon': Icons.security, 'label': 'Security', 'route': AppRoutes.securityCenter, 'color': Colors.red},
      {'icon': Icons.lock, 'label': 'Encryption', 'route': AppRoutes.encryptionCenter, 'color': Colors.teal},
      {'icon': Icons.invisibility, 'label': 'Stealth', 'route': AppRoutes.stealthMode, 'color': Colors.purple},
      
      // أدوات الإدارة (الصف الخامس)
      {'icon': Icons.schedule, 'label': 'Scheduler', 'route': AppRoutes.taskScheduler, 'color': Colors.amber},
      {'icon': Icons.package, 'label': 'Packages', 'route': AppRoutes.packageManager, 'color': Colors.indigo},
      {'icon': Icons.backup, 'label': 'Backup', 'route': AppRoutes.backupManager, 'color': Colors.purple},
      {'icon': Icons.history, 'label': 'Logs', 'route': AppRoutes.logViewer, 'color': Colors.orange},
      {'icon': Icons.storage, 'label': 'Disk', 'route': AppRoutes.diskAnalyzer, 'color': Colors.deepOrange},
      
      // التقارير والتحليلات (الصف السادس)
      {'icon': Icons.description, 'label': 'Reports', 'route': AppRoutes.reportGenerator, 'color': Colors.blue},
      {'icon': Icons.analytics, 'label': 'Analytics', 'route': AppRoutes.analyticsCenter, 'color': Colors.indigo},
      {'icon': Icons.bar_chart, 'label': 'Business', 'route': AppRoutes.businessAnalytics, 'color': Colors.indigo},
      {'icon': Icons.trending_up, 'label': 'Predictive', 'route': AppRoutes.predictiveAnalytics, 'color': Colors.deepPurple},
      
      // التكامل والخدمات (الصف السابع)
      {'icon': Icons.api, 'label': 'API Hub', 'route': AppRoutes.apiIntegration, 'color': Colors.deepPurple},
      {'icon': Icons.cloud, 'label': 'Cloud', 'route': AppRoutes.cloudCenter, 'color': Colors.lightBlue},
      {'icon': Icons.currency_bitcoin, 'label': 'Blockchain', 'route': AppRoutes.blockchainCenter, 'color': Colors.amber},
      {'icon': Icons.share, 'label': 'Integration', 'route': AppRoutes.integrationCenter, 'color': Colors.deepPurple},
      
      // الذكاء الاصطناعي (الصف الثامن)
      {'icon': Icons.psychology, 'label': 'AI Control', 'route': AppRoutes.aiControl, 'color': Colors.cyan},
      {'icon': Icons.model_training, 'label': 'ML', 'route': AppRoutes.predictiveCenter, 'color': Colors.purple},
      
      // البنية التحتية (الصف التاسع)
      {'icon': Icons.dashboard, 'label': 'Containers', 'route': AppRoutes.containerManager, 'color': Colors.indigo},
      {'icon': Icons.android, 'label': 'Robotics', 'route': AppRoutes.roboticsCenter, 'color': Colors.cyan},
      {'icon': Icons.energy_savings_leaf, 'label': 'Energy', 'route': AppRoutes.energyCenter, 'color': Colors.green},
      {'icon': Icons.location_city, 'label': 'Smart City', 'route': AppRoutes.smartCityCenter, 'color': Colors.blue},
      {'icon': Icons.map, 'label': 'Geospatial', 'route': AppRoutes.geospatialCenter, 'color': Colors.green},
      
      // الإنتاجية (الصف العاشر)
      {'icon': Icons.work, 'label': 'Productivity', 'route': AppRoutes.productivityCenter, 'color': Colors.orange},
      {'icon': Icons.code, 'label': 'Developer', 'route': AppRoutes.developerCenter, 'color': Colors.deepPurple},
      {'icon': Icons.school, 'label': 'Learning', 'route': AppRoutes.learningCenter, 'color': Colors.teal},
      {'icon': Icons.book, 'label': 'Docs', 'route': AppRoutes.docsCenter, 'color': Colors.orange},
      {'icon': Icons.help, 'label': 'Help', 'route': AppRoutes.helpCenter, 'color': Colors.blue},
      {'icon': Icons.info, 'label': 'Info', 'route': AppRoutes.infoCenter, 'color': Colors.blue},
      
      // الترفيه (الصف الحادي عشر)
      {'icon': Icons.games, 'label': 'Games', 'route': AppRoutes.gamesCenter, 'color': Colors.amber},
      {'icon': Icons.audiotrack, 'label': 'Media', 'route': AppRoutes.mediaCenter, 'color': Colors.pink},
      {'icon': Icons.view_in_ar, 'label': 'AR', 'route': AppRoutes.arCenter, 'color': Colors.purple},
      {'icon': Icons.qr_code, 'label': 'QR', 'route': AppRoutes.qrScanner, 'color': Colors.cyan},
      
      // النظام (الصف الثاني عشر)
      {'icon': Icons.power_settings_new, 'label': 'Boot', 'route': AppRoutes.bootCenter, 'color': Colors.deepOrange},
      {'icon': Icons.battery_std, 'label': 'Power', 'route': AppRoutes.powerManagement, 'color': Colors.green},
      {'icon': Icons.cleaning_services, 'label': 'Cleaner', 'route': AppRoutes.systemCleaner, 'color': Colors.blue},
      {'icon': Icons.build, 'label': 'Maintenance', 'route': AppRoutes.maintenanceCenter, 'color': Colors.purple},
      {'icon': Icons.verified, 'label': 'Quality', 'route': AppRoutes.qualityAssurance, 'color': Colors.teal},
      {'icon': Icons.gavel, 'label': 'Governance', 'route': AppRoutes.governanceCenter, 'color': Colors.blue},
      
      // الإشعارات والتواصل (الصف الثالث عشر)
      {'icon': Icons.notifications, 'label': 'Notif', 'route': AppRoutes.notificationCenter, 'color': Colors.blue},
      {'icon': Icons.chat, 'label': 'Comms', 'route': AppRoutes.communicationCenter, 'color': Colors.green},
      
      // متجر وإضافات (الصف الرابع عشر)
      {'icon': Icons.store, 'label': 'App Store', 'route': AppRoutes.appStore, 'color': Colors.blue},
      {'icon': Icons.science, 'label': 'Simulation', 'route': AppRoutes.simulationCenter, 'color': Colors.cyan},
      {'icon': Icons.settings, 'label': 'Automation', 'route': AppRoutes.automationCenter, 'color': Colors.amber},
    ];

    return Positioned.fill(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Wrap(
                spacing: 30,
                runSpacing: 30,
                children: icons.map((icon) => _DesktopIcon(
                  icon: icon['icon'] as IconData,
                  label: icon['label'] as String,
                  color: icon['color'] as Color,
                  iconSize: iconSize,
                  onTap: () => _openWindow(icon['label'] as String, _getWidgetForRoute(icon['route'] as String)),
                )).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getWidgetForRoute(String route) {
    switch (route) {
      case AppRoutes.terminal: return const CosmicTerminal();
      case AppRoutes.wifi: return const ZionWifiPanel();
      case AppRoutes.siAgent: return const AdvancedSIControlPanel();
      case AppRoutes.fileManager: return const AdvancedFileExplorer();
      case AppRoutes.browser: return const AdvancedWebBrowser();
      case AppRoutes.textEditor: return const AdvancedTextEditor();
      case AppRoutes.settings: return const MainSettings();
      case AppRoutes.networkAnalyzer: return const NetworkAnalyzer();
      case AppRoutes.networkInfra: return const NetworkInfrastructureCenter();
      case AppRoutes.networkControl: return const NetworkControlCenter();
      case AppRoutes.processManager: return const ProcessManager();
      case AppRoutes.systemMonitor: return const SystemMonitor();
      case AppRoutes.resourcesCenter: return const ResourcesCenter();
      case AppRoutes.performanceMonitor: return const PerformanceMonitor();
      case AppRoutes.vulnerabilityScanner: return const VulnerabilityScanner();
      case AppRoutes.securityCenter: return const SecurityCenter();
      case AppRoutes.encryptionCenter: return const EncryptionCenter();
      case AppRoutes.stealthMode: return const StealthMode();
      case AppRoutes.taskScheduler: return const TaskScheduler();
      case AppRoutes.packageManager: return const PackageManager();
      case AppRoutes.backupManager: return const BackupManager();
      case AppRoutes.logViewer: return const LogViewer();
      case AppRoutes.diskAnalyzer: return const DiskUsageAnalyzer();
      case AppRoutes.reportGenerator: return const ReportGenerator();
      case AppRoutes.analyticsCenter: return const AnalyticsCenter();
      case AppRoutes.businessAnalytics: return const BusinessAnalytics();
      case AppRoutes.predictiveAnalytics: return const PredictiveAnalyticsCenter();
      case AppRoutes.apiIntegration: return const ApiIntegrationCenter();
      case AppRoutes.cloudCenter: return const CloudCenter();
      case AppRoutes.blockchainCenter: return const BlockchainCenter();
      case AppRoutes.integrationCenter: return const IntegrationCenter();
      case AppRoutes.aiControl: return const AIControlCenter();
      case AppRoutes.predictiveCenter: return const PredictiveCenter();
      case AppRoutes.containerManager: return const ContainerManager();
      case AppRoutes.roboticsCenter: return const RoboticsCenter();
      case AppRoutes.energyCenter: return const EnergyCenter();
      case AppRoutes.smartCityCenter: return const SmartCityCenter();
      case AppRoutes.geospatialCenter: return const GeospatialCenter();
      case AppRoutes.productivityCenter: return const ProductivityCenter();
      case AppRoutes.developerCenter: return const DeveloperCenter();
      case AppRoutes.learningCenter: return const LearningCenter();
      case AppRoutes.docsCenter: return const DocsCenter();
      case AppRoutes.helpCenter: return const HelpCenter();
      case AppRoutes.infoCenter: return const InfoCenter();
      case AppRoutes.gamesCenter: return const GamesCenter();
      case AppRoutes.mediaCenter: return const MediaCenter();
      case AppRoutes.arCenter: return const ARCenter();
      case AppRoutes.qrScanner: return const QRScanner();
      case AppRoutes.bootCenter: return const BootCenter();
      case AppRoutes.powerManagement: return const PowerManagement();
      case AppRoutes.systemCleaner: return const SystemCleaner();
      case AppRoutes.maintenanceCenter: return const MaintenanceCenter();
      case AppRoutes.qualityAssurance: return const QualityAssuranceCenter();
      case AppRoutes.governanceCenter: return const GovernanceCenter();
      case AppRoutes.notificationCenter: return const AdvancedNotificationCenter();
      case AppRoutes.communicationCenter: return const CommunicationCenter();
      case AppRoutes.appStore: return const AppStore();
      case AppRoutes.simulationCenter: return const SimulationCenter();
      case AppRoutes.automationCenter: return const AutomationCenter();
      default: return const Center(child: Text('Coming Soon', style: TextStyle(color: Colors.white)));
    }
  }

  Widget _buildWindow(DesktopWindow w) {
    return Positioned(
      left: w.position.dx.clamp(0, MediaQuery.of(context).size.width - 100),
      top: w.position.dy.clamp(0, MediaQuery.of(context).size.height - 100),
      child: GestureDetector(
        onTap: () => _bringToFront(w.id),
        onPanStart: (details) => _startDragging(w.id, details.localPosition),
        onPanUpdate: (details) => _updateDragging(details.localPosition),
        onPanEnd: (_) => _stopDragging(),
        child: Container(
          width: w.isMaximized ? MediaQuery.of(context).size.width - 40 : w.size.width,
          height: w.isMaximized ? MediaQuery.of(context).size.height - 100 : w.size.height,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.95),
            borderRadius: BorderRadius.circular(w.isMaximized ? 0 : 12),
            border: Border.all(color: const Color(0xFF00FF41), width: 1),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 10)],
          ),
          child: Column(
            children: [
              _buildTitleBar(w),
              Expanded(child: ClipRRect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(w.isMaximized ? 0 : 12),
                  bottomRight: Radius.circular(w.isMaximized ? 0 : 12),
                ),
                child: w.content,
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleBar(DesktopWindow w) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF00FF41).withOpacity(0.1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(w.isMaximized ? 0 : 12),
          topRight: Radius.circular(w.isMaximized ? 0 : 12),
        ),
        border: Border(bottom: BorderSide(color: const Color(0xFF00FF41).withOpacity(0.3))),
      ),
      child: Row(
        children: [
          Row(
            children: [
              _buildWindowButton(Colors.red, () => _closeWindow(w.id)),
              const SizedBox(width: 8),
              _buildWindowButton(Colors.amber, () => _minimizeWindow(w.id)),
              const SizedBox(width: 8),
              _buildWindowButton(Colors.green, () => _maximizeWindow(w.id)),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              w.title,
              style: const TextStyle(color: Color(0xFF00FF41), fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 16, color: Colors.white),
            onPressed: () => _closeWindow(w.id),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildWindowButton(Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
    );
  }

  Widget _buildStartMenu() {
    final List<Map<String, dynamic>> menuCategories = [
      {'title': 'Basic Tools', 'color': Colors.green, 'items': [
        {'icon': Icons.terminal, 'title': 'Terminal', 'route': AppRoutes.terminal},
        {'icon': Icons.wifi, 'title': 'WiFi', 'route': AppRoutes.wifi},
        {'icon': Icons.psychology, 'title': 'SI Agent', 'route': AppRoutes.siAgent},
        {'icon': Icons.folder, 'title': 'File Manager', 'route': AppRoutes.fileManager},
        {'icon': Icons.public, 'title': 'Browser', 'route': AppRoutes.browser},
        {'icon': Icons.edit, 'title': 'Editor', 'route': AppRoutes.textEditor},
        {'icon': Icons.settings, 'title': 'Settings', 'route': AppRoutes.settings},
      ]},
      {'title': 'Network & Security', 'color': Colors.cyan, 'items': [
        {'icon': Icons.network_check, 'title': 'Network Analyzer', 'route': AppRoutes.networkAnalyzer},
        {'icon': Icons.device_hub, 'title': 'Network Infra', 'route': AppRoutes.networkInfra},
        {'icon': Icons.router, 'title': 'Network Control', 'route': AppRoutes.networkControl},
        {'icon': Icons.bug_report, 'title': 'Vuln Scanner', 'route': AppRoutes.vulnerabilityScanner},
        {'icon': Icons.security, 'title': 'Security Center', 'route': AppRoutes.securityCenter},
        {'icon': Icons.lock, 'title': 'Encryption', 'route': AppRoutes.encryptionCenter},
      ]},
      {'title': 'System & Performance', 'color': Colors.orange, 'items': [
        {'icon': Icons.memory, 'title': 'Process Manager', 'route': AppRoutes.processManager},
        {'icon': Icons.speed, 'title': 'System Monitor', 'route': AppRoutes.systemMonitor},
        {'icon': Icons.storage, 'title': 'Resources', 'route': AppRoutes.resourcesCenter},
        {'icon': Icons.speed, 'title': 'Performance', 'route': AppRoutes.performanceMonitor},
        {'icon': Icons.schedule, 'title': 'Scheduler', 'route': AppRoutes.taskScheduler},
        {'icon': Icons.package, 'title': 'Package Manager', 'route': AppRoutes.packageManager},
      ]},
      {'title': 'Analytics & Reports', 'color': Colors.purple, 'items': [
        {'icon': Icons.description, 'title': 'Reports', 'route': AppRoutes.reportGenerator},
        {'icon': Icons.analytics, 'title': 'Analytics', 'route': AppRoutes.analyticsCenter},
        {'icon': Icons.bar_chart, 'title': 'Business', 'route': AppRoutes.businessAnalytics},
        {'icon': Icons.trending_up, 'title': 'Predictive', 'route': AppRoutes.predictiveAnalytics},
      ]},
      {'title': 'AI & Automation', 'color': Colors.cyan, 'items': [
        {'icon': Icons.psychology, 'title': 'AI Control', 'route': AppRoutes.aiControl},
        {'icon': Icons.model_training, 'title': 'ML Training', 'route': AppRoutes.predictiveCenter},
        {'icon': Icons.settings, 'title': 'Automation', 'route': AppRoutes.automationCenter},
      ]},
      {'title': 'Cloud & Integration', 'color': Colors.blue, 'items': [
        {'icon': Icons.cloud, 'title': 'Cloud Center', 'route': AppRoutes.cloudCenter},
        {'icon': Icons.api, 'title': 'API Hub', 'route': AppRoutes.apiIntegration},
        {'icon': Icons.currency_bitcoin, 'title': 'Blockchain', 'route': AppRoutes.blockchainCenter},
        {'icon': Icons.share, 'title': 'Integration', 'route': AppRoutes.integrationCenter},
      ]},
      {'title': 'Productivity', 'color': Colors.teal, 'items': [
        {'icon': Icons.work, 'title': 'Productivity', 'route': AppRoutes.productivityCenter},
        {'icon': Icons.code, 'title': 'Developer', 'route': AppRoutes.developerCenter},
        {'icon': Icons.school, 'title': 'Learning', 'route': AppRoutes.learningCenter},
        {'icon': Icons.book, 'title': 'Docs', 'route': AppRoutes.docsCenter},
      ]},
      {'title': 'System Tools', 'color': Colors.red, 'items': [
        {'icon': Icons.power_settings_new, 'title': 'Boot Center', 'route': AppRoutes.bootCenter},
        {'icon': Icons.battery_std, 'title': 'Power', 'route': AppRoutes.powerManagement},
        {'icon': Icons.cleaning_services, 'title': 'Cleaner', 'route': AppRoutes.systemCleaner},
        {'icon': Icons.build, 'title': 'Maintenance', 'route': AppRoutes.maintenanceCenter},
        {'icon': Icons.verified, 'title': 'Quality', 'route': AppRoutes.qualityAssurance},
        {'icon': Icons.gavel, 'title': 'Governance', 'route': AppRoutes.governanceCenter},
      ]},
    ];

    return Positioned(
      bottom: 70,
      left: 16,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 320,
          height: 500,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.95),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF00FF41)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFF00FF41),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                ),
                child: const Row(
                  children: [
                    CircleAvatar(radius: 24, backgroundColor: Colors.white, child: Icon(Icons.person, color: Colors.black)),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Zion User', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        Text('zion@os', style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: menuCategories.map((category) => Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              Container(width: 4, height: 16, color: category['color'] as Color),
                              const SizedBox(width: 8),
                              Text(category['title'] as String, style: TextStyle(color: category['color'] as Color, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        ...(category['items'] as List<Map<String, dynamic>>).map((item) => ListTile(
                          dense: true,
                          leading: Icon(item['icon'] as IconData, color: category['color'] as Color, size: 20),
                          title: Text(item['title'] as String, style: const TextStyle(color: Colors.white, fontSize: 13)),
                          onTap: () {
                            _toggleMenu();
                            _openWindow(item['title'] as String, _getWidgetForRoute(item['route'] as String));
                          },
                        )),
                        const Divider(color: Colors.white24, height: 1),
                      ],
                    )).toList(),
                  ),
                ),
              ),
              const Divider(color: Colors.white24),
              ListTile(
                leading: const Icon(Icons.exit_to_app, color: Colors.red),
                title: const Text('Exit', style: TextStyle(color: Colors.red)),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskbar(double iconSize, double fontSize) {
    return Positioned(
      bottom: 0, left: 0, right: 0,
      child: Container(
        height: ResponsiveHelper.isMobile(context) ? 40 : 50,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.9),
          border: Border(top: BorderSide(color: const Color(0xFF00FF41).withOpacity(0.3))),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: _toggleMenu,
              child: Container(
                width: ResponsiveHelper.isMobile(context) ? 50 : 60,
                height: ResponsiveHelper.isMobile(context) ? 40 : 50,
                decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF00FF41), Colors.black])),
                child: Icon(Icons.menu, color: Colors.white, size: ResponsiveHelper.isMobile(context) ? 20 : 24),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _windows.map((w) => GestureDetector(
                    onTap: () => w.isMinimized ? _restoreWindow(w.id) : _bringToFront(w.id),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      height: ResponsiveHelper.isMobile(context) ? 40 : 50,
                      decoration: BoxDecoration(
                        border: Border(left: BorderSide(color: Colors.white.withOpacity(0.1))),
                      ),
                      child: Center(
                        child: Text(
                          w.title,
                          style: TextStyle(color: Colors.white, fontSize: ResponsiveHelper.isMobile(context) ? 10 : 12),
                        ),
                      ),
                    ),
                  )).toList(),
                ),
              ),
            ),
            _buildSystemTray(iconSize),
            _buildClock(fontSize),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemTray(double iconSize) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () => _openWindow('Notifications', const AdvancedNotificationCenter(), size: const Size(400, 600)),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 8),
          Icon(Icons.battery_full, color: Colors.white, size: iconSize),
          SizedBox(width: ResponsiveHelper.isMobile(context) ? 4 : 8),
          Icon(Icons.wifi, color: Colors.white, size: iconSize),
          SizedBox(width: ResponsiveHelper.isMobile(context) ? 4 : 8),
          Icon(Icons.volume_up, color: Colors.white, size: iconSize),
        ],
      ),
    );
  }

  Widget _buildClock(double fontSize) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(_formatTime(_currentTime), style: TextStyle(color: Colors.white, fontSize: fontSize)),
          Text(_formatDate(_currentTime), style: TextStyle(color: Colors.white70, fontSize: fontSize - 2)),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) => '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  String _formatDate(DateTime time) => '${time.day}/${time.month}/${time.year}';
}

class _DesktopIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final double iconSize;
  final VoidCallback onTap;

  const _DesktopIcon({
    required this.icon,
    required this.label,
    required this.color,
    required this.iconSize,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color, width: 1),
            ),
            child: Icon(icon, color: color, size: iconSize * 0.5),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(color: Colors.white70, fontSize: iconSize * 0.15),
          ),
        ],
      ),
    );
  }
}

class DesktopWindow {
  final int id;
  final String title;
  final Widget content;
  Offset position;
  Size size;
  Size savedSize;
  Offset savedPosition;
  bool isMinimized;
  bool isMaximized;

  DesktopWindow({
    required this.id,
    required this.title,
    required this.content,
    required this.position,
    required this.size,
    required this.isMinimized,
    required this.isMaximized,
  }) : savedSize = size, savedPosition = position;
}

// إضافة في قائمة icons في _buildDesktopIcons
{'icon': Icons.snowflake, 'label': 'NixOS', 'route': '/nixos', 'color': Colors.indigo},
