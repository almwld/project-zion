import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';

class SecurityCenter extends StatefulWidget {
  const SecurityCenter({super.key});

  @override
  State<SecurityCenter> createState() => _SecurityCenterState();
}

class _SecurityCenterState extends State<SecurityCenter> {
  bool _isScanning = false;
  int _securityScore = 85;
  List<SecurityIssue> _issues = [];
  List<SecurityRecommendation> _recommendations = [];

  @override
  void initState() {
    super.initState();
    _loadSecurityData();
  }

  Future<void> _loadSecurityData() async {
    setState(() {
      _issues = [
        SecurityIssue(
          name: 'Root Access Detected',
          severity: 'Critical',
          description: 'Root access may compromise system security',
          icon: Icons.warning,
          color: Colors.red,
        ),
        SecurityIssue(
          name: 'Debug Mode Enabled',
          severity: 'High',
          description: 'Debug mode exposes sensitive information',
          icon: Icons.bug_report,
          color: Colors.orange,
        ),
        SecurityIssue(
          name: 'Outdated Security Patches',
          severity: 'Medium',
          description: 'System updates available',
          icon: Icons.update,
          color: Colors.yellow,
        ),
      ];
      
      _recommendations = [
        SecurityRecommendation(
          title: 'Enable Stealth Mode',
          description: 'Hide app traces and notifications',
          icon: Icons.invisible,
          color: Colors.purple,
          action: () => _enableStealthMode(),
        ),
        SecurityRecommendation(
          title: 'Run Security Scan',
          description: 'Scan for vulnerabilities',
          icon: Icons.security,
          color: Colors.blue,
          action: () => _startSecurityScan(),
        ),
        SecurityRecommendation(
          title: 'Change PIN Code',
          description: 'Update your lock screen PIN',
          icon: Icons.pin,
          color: Colors.green,
          action: () => _changePinCode(),
        ),
      ];
    });
  }

  Future<void> _startSecurityScan() async {
    setState(() {
      _isScanning = true;
      _securityScore = 85;
    });
    
    await Future.delayed(const Duration(seconds: 3));
    
    setState(() {
      _isScanning = false;
      _securityScore = 92;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Security scan completed! No new threats found.')),
    );
  }

  void _enableStealthMode() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Stealth Mode'),
        content: const Text('Enable stealth mode to hide notifications and app traces?'),
        backgroundColor: Colors.grey.shade900,
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Stealth mode enabled')),
              );
            },
            child: const Text('Enable'),
          ),
        ],
      ),
    );
  }

  void _changePinCode() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Change PIN'),
        backgroundColor: Colors.grey.shade900,
        content: TextField(
          controller: controller,
          obscureText: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Enter new PIN',
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('PIN changed successfully')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor() {
    if (_securityScore >= 80) return Colors.green;
    if (_securityScore >= 60) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Security Center'),
        backgroundColor: Colors.red.shade900,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildSecurityScoreCard()),
          SliverToBoxAdapter(child: _buildSecurityIssues()),
          SliverToBoxAdapter(child: _buildRecommendations()),
        ],
      ),
    );
  }

  Widget _buildSecurityScoreCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.red.shade900, Colors.black],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.shield, color: Colors.white, size: 32),
              SizedBox(width: 12),
              Text('Security Score', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 150,
                height: 150,
                child: CircularProgressIndicator(
                  value: _securityScore / 100,
                  strokeWidth: 12,
                  backgroundColor: Colors.grey.shade800,
                  color: _getScoreColor(),
                ),
              ),
              Column(
                children: [
                  Text('$_securityScore', style: TextStyle(color: _getScoreColor(), fontSize: 36, fontWeight: FontWeight.bold)),
                  const Text('Secure', style: TextStyle(color: Colors.white70)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _isScanning ? null : _startSecurityScan,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              minimumSize: const Size(double.infinity, 45),
            ),
            child: _isScanning
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('RUN SECURITY SCAN'),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityIssues() {
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
              Icon(Icons.warning, color: Colors.orange),
              SizedBox(width: 8),
              Text('Security Issues', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          ..._issues.map((issue) => ListTile(
            leading: Icon(issue.icon, color: issue.color),
            title: Text(issue.name, style: const TextStyle(color: Colors.white)),
            subtitle: Text(issue.description, style: const TextStyle(color: Colors.grey)),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: issue.color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(issue.severity, style: TextStyle(color: issue.color, fontSize: 11)),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildRecommendations() {
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
              Icon(Icons.lightbulb, color: Colors.yellow),
              SizedBox(width: 8),
              Text('Recommendations', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          ..._recommendations.map((rec) => ListTile(
            leading: Icon(rec.icon, color: rec.color),
            title: Text(rec.title, style: const TextStyle(color: Colors.white)),
            subtitle: Text(rec.description, style: const TextStyle(color: Colors.grey)),
            trailing: ElevatedButton(
              onPressed: rec.action,
              style: ElevatedButton.styleFrom(backgroundColor: rec.color),
              child: const Text('Apply'),
            ),
          )),
        ],
      ),
    );
  }
}

class SecurityIssue {
  final String name;
  final String severity;
  final String description;
  final IconData icon;
  final Color color;

  SecurityIssue({
    required this.name,
    required this.severity,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class SecurityRecommendation {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback action;

  SecurityRecommendation({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.action,
  });
}
