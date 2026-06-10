import 'package:flutter/material.dart';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'dart:async';

class NetworkControlCenter extends StatefulWidget {
  const NetworkControlCenter({super.key});

  @override
  State<NetworkControlCenter> createState() => _NetworkControlCenterState();
}

class _NetworkControlCenterState extends State<NetworkControlCenter> {
  final Connectivity _connectivity = Connectivity();
  final NetworkInfo _networkInfo = NetworkInfo();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  
  bool _isWifiEnabled = true;
  bool _isMobileDataEnabled = true;
  bool _isBluetoothEnabled = false;
  bool _isHotspotEnabled = false;
  String _currentNetwork = 'Unknown';
  String _ipAddress = '0.0.0.0';
  String _signalStrength = '0%';
  int _downloadSpeed = 0;
  int _uploadSpeed = 0;
  List<NetworkDevice> _connectedDevices = [];

  @override
  void initState() {
    super.initState();
    _initNetworkInfo();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _loadConnectedDevices();
    _startSpeedTest();
  }

  Future<void> _initNetworkInfo() async {
    final connectivityResult = await _connectivity.checkConnectivity();
    _updateConnectionStatus(connectivityResult);
    
    final ip = await _networkInfo.getWifiIP();
    setState(() => _ipAddress = ip ?? '0.0.0.0');
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
    setState(() {
      switch (result) {
        case ConnectivityResult.wifi:
          _currentNetwork = 'WiFi Connected';
          _signalStrength = '85%';
          break;
        case ConnectivityResult.mobile:
          _currentNetwork = 'Mobile Data';
          _signalStrength = '70%';
          break;
        case ConnectivityResult.ethernet:
          _currentNetwork = 'Ethernet';
          _signalStrength = '100%';
          break;
        default:
          _currentNetwork = 'No Connection';
          _signalStrength = '0%';
      }
    });
  }

  void _loadConnectedDevices() {
    _connectedDevices = [
      NetworkDevice(name: 'Zion Phone', ip: '192.168.1.100', mac: 'AA:BB:CC:DD:EE:FF', isLocal: true),
      NetworkDevice(name: 'Laptop', ip: '192.168.1.101', mac: '11:22:33:44:55:66', isLocal: false),
      NetworkDevice(name: 'Smart TV', ip: '192.168.1.102', mac: '77:88:99:AA:BB:CC', isLocal: false),
      NetworkDevice(name: 'Printer', ip: '192.168.1.103', mac: 'DD:EE:FF:00:11:22', isLocal: false),
    ];
  }

  void _startSpeedTest() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          _downloadSpeed = 50 + (DateTime.now().millisecondsSinceEpoch % 100);
          _uploadSpeed = 20 + (DateTime.now().millisecondsSinceEpoch % 50);
        });
      }
    });
  }

  void _toggleWifi() {
    setState(() => _isWifiEnabled = !_isWifiEnabled);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_isWifiEnabled ? 'WiFi Enabled' : 'WiFi Disabled')),
    );
  }

  void _toggleMobileData() {
    setState(() => _isMobileDataEnabled = !_isMobileDataEnabled);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_isMobileDataEnabled ? 'Mobile Data Enabled' : 'Mobile Data Disabled')),
    );
  }

  void _toggleBluetooth() {
    setState(() => _isBluetoothEnabled = !_isBluetoothEnabled);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_isBluetoothEnabled ? 'Bluetooth Enabled' : 'Bluetooth Disabled')),
    );
  }

  void _toggleHotspot() {
    setState(() => _isHotspotEnabled = !_isHotspotEnabled);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_isHotspotEnabled ? 'Hotspot Enabled' : 'Hotspot Disabled')),
    );
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Network Control Center'),
        backgroundColor: Colors.cyan.shade900,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildConnectionStatus()),
          SliverToBoxAdapter(child: _buildQuickToggles()),
          SliverToBoxAdapter(child: _buildSpeedCard()),
          SliverToBoxAdapter(child: _buildConnectedDevices()),
        ],
      ),
    );
  }

  Widget _buildConnectionStatus() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.cyan.shade900, Colors.black],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(
              _getNetworkIcon(),
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_currentNetwork, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('IP: $_ipAddress', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                Text('Signal: $_signalStrength', style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _getSignalColor(),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(_signalStrength, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  IconData _getNetworkIcon() {
    if (_currentNetwork.contains('WiFi')) return Icons.wifi;
    if (_currentNetwork.contains('Mobile')) return Icons.signal_cellular_alt;
    if (_currentNetwork.contains('Ethernet')) return Icons.settings_ethernet;
    return Icons.signal_wifi_off;
  }

  Color _getSignalColor() {
    final value = int.tryParse(_signalStrength.replaceAll('%', '')) ?? 0;
    if (value >= 70) return Colors.green;
    if (value >= 30) return Colors.orange;
    return Colors.red;
  }

  Widget _buildQuickToggles() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Quick Controls', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildToggleButton('WiFi', Icons.wifi, _isWifiEnabled, _toggleWifi, Colors.blue),
              _buildToggleButton('Mobile Data', Icons.signal_cellular_alt, _isMobileDataEnabled, _toggleMobileData, Colors.green),
              _buildToggleButton('Bluetooth', Icons.bluetooth, _isBluetoothEnabled, _toggleBluetooth, Colors.cyan),
              _buildToggleButton('Hotspot', Icons.wifi_tethering, _isHotspotEnabled, _toggleHotspot, Colors.orange),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String label, IconData icon, bool isEnabled, VoidCallback onTap, Color color) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: isEnabled ? color.withOpacity(0.2) : Colors.grey.shade800,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: isEnabled ? color : Colors.grey, width: 1),
            ),
            child: Icon(icon, color: isEnabled ? color : Colors.grey, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(color: isEnabled ? color : Colors.grey, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildSpeedCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Speed Test', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text('${_downloadSpeed} Mbps', style: const TextStyle(color: Colors.green, fontSize: 24, fontWeight: FontWeight.bold)),
                    const Text('Download', style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text('${_uploadSpeed} Mbps', style: const TextStyle(color: Colors.blue, fontSize: 24, fontWeight: FontWeight.bold)),
                    const Text('Upload', style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: _downloadSpeed / 100,
            backgroundColor: Colors.grey.shade800,
            color: Colors.green,
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: _uploadSpeed / 100,
            backgroundColor: Colors.grey.shade800,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildConnectedDevices() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.devices, color: Colors.cyan),
              SizedBox(width: 8),
              Text('Connected Devices', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          ..._connectedDevices.map((device) => ListTile(
            leading: CircleAvatar(
              backgroundColor: device.isLocal ? Colors.green.withOpacity(0.2) : Colors.blue.withOpacity(0.2),
              child: Icon(Icons.devices, color: device.isLocal ? Colors.green : Colors.blue),
            ),
            title: Text(device.name, style: const TextStyle(color: Colors.white)),
            subtitle: Text(device.ip, style: const TextStyle(color: Colors.grey)),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(device.mac, style: const TextStyle(color: Colors.grey, fontSize: 10)),
            ),
          )),
        ],
      ),
    );
  }
}

class NetworkDevice {
  final String name;
  final String ip;
  final String mac;
  final bool isLocal;

  NetworkDevice({
    required this.name,
    required this.ip,
    required this.mac,
    required this.isLocal,
  });
}
