import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:riverpod/riverpod.dart';
import '../kali_agent_si.dart';

final unifiedCoreProvider = Provider<UnifiedCoreService>((ref) => UnifiedCoreService());

class UnifiedCoreService {
  final KaliAgentSi _si = KaliAgentSi();
  bool _siAwake = false;

  Future<String> execute(String command, {String? target, Map<String, String>? options}) async {
    try {
      if (command == 'awaken' || command == 'start_ai') {
        if (!_siAwake) { _siAwake = true; _si.awaken(); return '🗡️ Si المحارب استيقظ. Kali جاهزة. 600+ أداة تحت إمرتك.'; }
        return '🗡️ Si مستيقظ بالفعل.';
      }

      // أوامر Kali
      if (command == 'kali_report' || command == 'تقرير_كالي') {
        return const JsonEncoder.withIndent('  ').convert(_si.getKaliReport());
      }

      if (command == 'kali_tool' || command == 'أداة') {
        if (options == null || !options.containsKey('tool')) return '⚠️ استخدم: kali_tool tool=nmap args=-sV,-O';
        final tool = options['tool']!;
        final args = options['args']?.split(',') ?? [];
        final result = await _si.runKaliTool(tool, args: args);
        return const JsonEncoder.withIndent('  ').convert(result);
      }

      if (command == 'parallel_attack' || command == 'هجوم_متوازي') {
        final result = await _si.parallelAttack(target ?? '127.0.0.1');
        return const JsonEncoder.withIndent('  ').convert(result);
      }

      if (command == 'attack_category' || command == 'هجوم_فئة') {
        final category = options?['category'] ?? 'network';
        final result = await _si.attackCategory(target ?? '127.0.0.1', category);
        return const JsonEncoder.withIndent('  ').convert(result);
      }

      if (command == 'parallel_tools' || command == 'أدوات_متوازية') {
        // مثال: parallel_tools target=192.168.1.1 tools=nmap,nikto,dirb
        final toolsList = options?['tools']?.split(',') ?? [];
        final args = <String, List<String>>{};
        for (final t in toolsList) {
          args[t] = [target ?? '127.0.0.1'];
        }
        final result = await _si.runParallelTools(args);
        return const JsonEncoder.withIndent('  ').convert(result);
      }

      // أوامر شيطانية
      if (command == 'berserk' || command == 'هياج') { _si.activateBerserkMode(); return '💀 وضع الهياج مُفعّل.'; }
      if (command == 'total_war' || command == 'حرب_شاملة') { _si.activateTotalWar(); return '🔥 الحرب الشاملة مُفعّلة.'; }
      if (command == 'annihilate' || command == 'تدمير') return await _si.annihilate(target ?? 'unknown');
      if (command == 'ddos_hell' || command == 'جحيم') return await _si.ddosHell(target ?? 'unknown');
      if (command == 'apocalypse' || command == 'نهاية_العالم') return await _si.apocalypse();

      if (command == 'demon_report') return const JsonEncoder.withIndent('  ').convert(_si.getDemonReport());
      if (command == 'si_status') return const JsonEncoder.withIndent('  ').convert(_si.getStatus());
      if (command == 'si_sleep' || command == 'stop_ai') { _si.sleep(); _siAwake = false; return '😴 Si نام.'; }

      if (_siAwake) return await _si.executeUserCommand(command, target: target);

      switch (command) {
        case 'ping': return await _ping(target ?? '127.0.0.1');
        case 'port_scan': return await _portScan(target ?? '127.0.0.1');
        case 'system_info': return _systemInfo();
        case 'help': return _helpText();
        default: return 'Unknown command: $command';
      }
    } catch (e) { return 'Error: $e'; }
  }

  Future<String> _ping(String t) async { try { return (await Process.run('ping', ['-c', '4', t], runInShell: true)).stdout.toString(); } catch (e) { return 'Ping failed: $e'; } }
  Future<String> _portScan(String t) async { final p = [21,22,23,25,53,80,443,8080,8443]; final o = <String>[]; for (final x in p) { try { final s = await Socket.connect(t, x, timeout: const Duration(milliseconds: 500)); o.add('$x (open)'); s.destroy(); } catch (_) {} } return 'Port scan on $t:\n${o.isNotEmpty ? o.join('\n') : "No open ports found"}'; }
  String _systemInfo() => 'OS: ${Platform.operatingSystem}\nCPU: ${Platform.numberOfProcessors} cores\nDart: ${Platform.version}';

  String _helpText() => '''
=== PROJECT ZION - KALI AGENT Si ===
awaken / start_ai      - إيقاظ المحارب
kali_report            - تقرير Kali
kali_tool tool=X args=Y - تشغيل أداة
parallel_attack        - هجوم متوازي
attack_category cat=X  - هجوم فئة
parallel_tools tools=X - أدوات متوازية
berserk / هياج         - وضع الهياج
annihilate / تدمير     - تدمير هدف
apocalypse             - نهاية العالم
help                   - مساعدة
===================================
''';
}
