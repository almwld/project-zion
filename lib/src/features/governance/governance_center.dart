import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

class GovernanceCenter extends StatefulWidget {
  const GovernanceCenter({super.key});

  @override
  State<GovernanceCenter> createState() => _GovernanceCenterState();
}

class _GovernanceCenterState extends State<GovernanceCenter> {
  int _selectedTab = 0;
  
  // Compliance Standards
  List<ComplianceStandard> _standards = [];
  double _overallCompliance = 0.0;
  Map<String, double> _standardProgress = {};
  
  // Audit Logs
  List<AuditLog> _auditLogs = [];
  String _selectedLogFilter = 'All';
  final List<String> _logFilters = ['All', 'Security', 'System', 'User', 'Compliance'];
  
  // Policies
  List<Policy> _policies = [];
  List<Policy> _pendingPolicies = [];
  
  // Risk Management
  List<RiskAssessment> _risks = [];
  double _riskScore = 0.0;
  List<RiskMitigation> _mitigations = [];

  @override
  void initState() {
    super.initState();
    _loadStandards();
    _loadAuditLogs();
    _loadPolicies();
    _loadRisks();
    _calculateOverallCompliance();
  }

  void _loadStandards() {
    _standards = [
      ComplianceStandard('ISO 27001', 'Information Security Management', 85, 120, Colors.blue),
      ComplianceStandard('GDPR', 'Data Protection', 92, 150, Colors.green),
      ComplianceStandard('HIPAA', 'Healthcare Data', 78, 100, Colors.red),
      ComplianceStandard('PCI DSS', 'Payment Card Security', 88, 95, Colors.orange),
      ComplianceStandard('SOC 2', 'Service Organizations', 82, 110, Colors.purple),
      ComplianceStandard('NIST', 'Cybersecurity Framework', 75, 130, Colors.cyan),
    ];
    
    for (var standard in _standards) {
      _standardProgress[standard.name] = standard.currentScore / 100;
    }
  }

  void _loadAuditLogs() {
    _auditLogs = [
      AuditLog('User Login', 'User', DateTime.now().subtract(const Duration(minutes: 5)), 'INFO', '192.168.1.100'),
      AuditLog('Security Policy Updated', 'Security', DateTime.now().subtract(const Duration(minutes: 25)), 'WARNING', 'Admin'),
      AuditLog('Compliance Check', 'Compliance', DateTime.now().subtract(const Duration(hours: 1)), 'SUCCESS', 'System'),
      AuditLog('Data Export', 'User', DateTime.now().subtract(const Duration(hours: 2)), 'INFO', '192.168.1.105'),
      AuditLog('Failed Login Attempt', 'Security', DateTime.now().subtract(const Duration(hours: 3)), 'ERROR', '192.168.1.200'),
      AuditLog('Policy Violation', 'Compliance', DateTime.now().subtract(const Duration(hours: 5)), 'WARNING', '192.168.1.50'),
    ];
  }

  void _loadPolicies() {
    _policies = [
      Policy('POL-001', 'Data Retention Policy', 'Active', DateTime.now().subtract(const Duration(days: 30)), DateTime.now().add(const Duration(days: 335))),
      Policy('POL-002', 'Access Control Policy', 'Active', DateTime.now().subtract(const Duration(days: 60)), DateTime.now().add(const Duration(days: 305))),
      Policy('POL-003', 'Incident Response Plan', 'Review', DateTime.now().subtract(const Duration(days: 15)), DateTime.now().add(const Duration(days: 350))),
      Policy('POL-004', 'Acceptable Use Policy', 'Active', DateTime.now().subtract(const Duration(days: 90)), DateTime.now().add(const Duration(days: 275))),
    ];
    
    _pendingPolicies = [
      Policy('POL-005', 'Remote Access Policy', 'Draft', DateTime.now(), DateTime.now().add(const Duration(days: 365))),
      Policy('POL-006', 'Vendor Security Policy', 'Draft', DateTime.now(), DateTime.now().add(const Duration(days: 365))),
    ];
  }

  void _loadRisks() {
    _risks = [
      RiskAssessment('R-001', 'Data Breach Risk', 4.5, 8.5, 38.25, 'High', DateTime.now().subtract(const Duration(days: 15))),
      RiskAssessment('R-002', 'Compliance Violation', 3.0, 7.0, 21.0, 'Medium', DateTime.now().subtract(const Duration(days: 30))),
      RiskAssessment('R-003', 'System Availability', 2.0, 5.0, 10.0, 'Low', DateTime.now().subtract(const Duration(days: 45))),
      RiskAssessment('R-004', 'Third Party Risk', 3.5, 6.0, 21.0, 'Medium', DateTime.now().subtract(const Duration(days: 10))),
    ];
    
    _mitigations = [
      RiskMitigation('M-001', 'Implement MFA', 'R-001', 'In Progress', DateTime.now().add(const Duration(days: 30))),
      RiskMitigation('M-002', 'Regular Security Audits', 'R-002', 'Completed', DateTime.now().subtract(const Duration(days: 5))),
      RiskMitigation('M-003', 'Backup Strategy', 'R-003', 'Planned', DateTime.now().add(const Duration(days: 60))),
    ];
    
    _calculateRiskScore();
  }

  void _calculateOverallCompliance() {
    double total = 0;
    for (var standard in _standards) {
      total += standard.currentScore;
    }
    _overallCompliance = total / _standards.length;
  }

  void _calculateRiskScore() {
    double total = 0;
    for (var risk in _risks) {
      total += risk.riskScore;
    }
    _riskScore = total / _risks.length;
  }

  void _approvePolicy(Policy policy) {
    setState(() {
      policy.status = 'Active';
      policy.effectiveDate = DateTime.now();
      policy.expiryDate = DateTime.now().add(const Duration(days: 365));
      _pendingPolicies.remove(policy);
      _policies.add(policy);
    });
    _addAuditLog('Policy Approved', 'Compliance', policy.name);
  }

  void _rejectPolicy(Policy policy) {
    setState(() {
      _pendingPolicies.remove(policy);
    });
    _addAuditLog('Policy Rejected', 'Compliance', policy.name);
  }

  void _addAuditLog(String action, String category, String details) {
    _auditLogs.insert(0, AuditLog(action, category, DateTime.now(), 'INFO', details));
    setState(() {});
  }

  String _getRiskLevelColor(String level) {
    switch (level) {
      case 'High': return Colors.red.value.toRadixString(16);
      case 'Medium': return Colors.orange.value.toRadixString(16);
      default: return Colors.green.value.toRadixString(16);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Governance Center'),
        backgroundColor: Colors.blue.shade900,
        bottom: TabBar(
          tabs: const [
            Tab(icon: Icon(Icons.verified), text: 'Compliance'),
            Tab(icon: Icon(Icons.history), text: 'Audit Logs'),
            Tab(icon: Icon(Icons.description), text: 'Policies'),
            Tab(icon: Icon(Icons.warning), text: 'Risk Mgmt'),
          ],
          onTap: (index) => setState(() => _selectedTab = index),
        ),
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          _buildComplianceTab(),
          _buildAuditLogsTab(),
          _buildPoliciesTab(),
          _buildRiskManagementTab(),
        ],
      ),
    );
  }

  Widget _buildComplianceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blue.shade900, Colors.purple.shade900],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text('Overall Compliance Score', style: TextStyle(color: Colors.white, fontSize: 18)),
                const SizedBox(height: 16),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: CircularProgressIndicator(
                        value: _overallCompliance / 100,
                        strokeWidth: 12,
                        backgroundColor: Colors.grey.shade800,
                        color: Colors.green,
                      ),
                    ),
                    Column(
                      children: [
                        Text('${_overallCompliance.toStringAsFixed(1)}%', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                        const Text('Compliant', style: TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ..._standards.map((standard) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(12),
              border: Border(left: BorderSide(color: standard.color, width: 4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(standard.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Text('${standard.currentScore}%', style: TextStyle(color: standard.color)),
                  ],
                ),
                Text('${standard.controlsMet}/${standard.totalControls} controls met', style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: standard.currentScore / 100,
                  backgroundColor: Colors.grey.shade800,
                  color: standard.color,
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildAuditLogsTab() {
    final filteredLogs = _selectedLogFilter == 'All' 
        ? _auditLogs 
        : _auditLogs.where((log) => log.category == _selectedLogFilter).toList();
    
    return Column(
      children: [
        Container(
          height: 50,
          margin: const EdgeInsets.all(16),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _logFilters.length,
            itemBuilder: (ctx, i) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: FilterChip(
                label: Text(_logFilters[i]),
                selected: _selectedLogFilter == _logFilters[i],
                onSelected: (_) => setState(() => _selectedLogFilter = _logFilters[i]),
                backgroundColor: Colors.grey.shade800,
                selectedColor: Colors.blue,
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredLogs.length,
            itemBuilder: (ctx, i) {
              final log = filteredLogs[i];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      log.severity == 'ERROR' ? Icons.error :
                      log.severity == 'WARNING' ? Icons.warning :
                      Icons.info,
                      color: log.severity == 'ERROR' ? Colors.red :
                             log.severity == 'WARNING' ? Colors.orange : Colors.blue,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(log.action, style: const TextStyle(color: Colors.white)),
                          Text('${log.category} • ${log.details} • ${log.source}', style: const TextStyle(color: Colors.grey, fontSize: 11)),
                        ],
                      ),
                    ),
                    Text(_formatTime(log.timestamp), style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPoliciesTab() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: Colors.grey.shade900,
            child: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.check_circle), text: 'Active'),
                Tab(icon: Icon(Icons.pending), text: 'Pending'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                ListView.builder(
                  itemCount: _policies.length,
                  itemBuilder: (ctx, i) {
                    final policy = _policies[i];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(policy.id, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                              const SizedBox(width: 8),
                              Expanded(child: Text(policy.name, style: const TextStyle(color: Colors.white))),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: policy.status == 'Active' ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(policy.status, style: TextStyle(color: policy.status == 'Active' ? Colors.green : Colors.orange)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text('Effective: ${_formatDate(policy.effectiveDate)}', style: const TextStyle(color: Colors.grey)),
                          Text('Expires: ${_formatDate(policy.expiryDate)}', style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                    );
                  },
                ),
                ListView.builder(
                  itemCount: _pendingPolicies.length,
                  itemBuilder: (ctx, i) {
                    final policy = _pendingPolicies[i];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade900,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(policy.id, style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                              const SizedBox(width: 8),
                              Expanded(child: Text(policy.name, style: const TextStyle(color: Colors.white))),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(policy.status, style: const TextStyle(color: Colors.orange)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => _approvePolicy(policy),
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                  child: const Text('APPROVE'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => _rejectPolicy(policy),
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                  child: const Text('REJECT'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiskManagementTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text('Overall Risk Score', style: TextStyle(color: Colors.white, fontSize: 18)),
                const SizedBox(height: 16),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: CircularProgressIndicator(
                        value: _riskScore / 100,
                        strokeWidth: 10,
                        backgroundColor: Colors.grey.shade800,
                        color: _riskScore > 30 ? Colors.red : _riskScore > 15 ? Colors.orange : Colors.green,
                      ),
                    ),
                    Text('${_riskScore.toStringAsFixed(1)}%', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ..._risks.map((risk) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(12),
              border: Border(left: BorderSide(color: risk.severity == 'High' ? Colors.red : risk.severity == 'Medium' ? Colors.orange : Colors.green, width: 4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(risk.id, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Text('Risk Score: ${risk.riskScore}', style: TextStyle(color: risk.severity == 'High' ? Colors.red : Colors.orange)),
                  ],
                ),
                Text(risk.name, style: const TextStyle(color: Colors.white)),
                Text('Likelihood: ${risk.likelihood} | Impact: ${risk.impact}', style: const TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: risk.riskScore / 100,
                  backgroundColor: Colors.grey.shade800,
                  color: risk.severity == 'High' ? Colors.red : risk.severity == 'Medium' ? Colors.orange : Colors.green,
                ),
              ],
            ),
          )),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Risk Mitigation Plans', style: TextStyle(color: Colors.white, fontSize: 18)),
                const Divider(),
                ..._mitigations.map((mit) => ListTile(
                  leading: Icon(
                    mit.status == 'Completed' ? Icons.check_circle : 
                    mit.status == 'In Progress' ? Icons.hourglass_empty : Icons.pending,
                    color: mit.status == 'Completed' ? Colors.green : 
                           mit.status == 'In Progress' ? Colors.orange : Colors.blue,
                  ),
                  title: Text(mit.name, style: const TextStyle(color: Colors.white)),
                  subtitle: Text('Due: ${_formatDate(mit.dueDate)} • Status: ${mit.status}', style: const TextStyle(color: Colors.grey)),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class ComplianceStandard {
  final String name;
  final String description;
  final double currentScore;
  final int totalControls;
  final Color color;
  int controlsMet = 0;

  ComplianceStandard(this.name, this.description, this.currentScore, this.totalControls, this.color) {
    controlsMet = (totalControls * currentScore / 100).toInt();
  }
}

class AuditLog {
  final String action;
  final String category;
  final DateTime timestamp;
  final String severity;
  final String details;
  final String source;

  AuditLog(this.action, this.category, this.timestamp, this.severity, this.source, [this.details = '']);
}

class Policy {
  final String id;
  final String name;
  String status;
  DateTime effectiveDate;
  DateTime expiryDate;

  Policy(this.id, this.name, this.status, this.effectiveDate, this.expiryDate);
}

class RiskAssessment {
  final String id;
  final String name;
  final double likelihood;
  final double impact;
  final double riskScore;
  final String severity;
  final DateTime assessedDate;

  RiskAssessment(this.id, this.name, this.likelihood, this.impact, this.riskScore, this.severity, this.assessedDate);
}

class RiskMitigation {
  final String id;
  final String name;
  final String riskId;
  final String status;
  final DateTime dueDate;

  RiskMitigation(this.id, this.name, this.riskId, this.status, this.dueDate);
}
