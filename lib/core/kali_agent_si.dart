import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'demon_si.dart';

class KaliAgentSi extends DemonSi {
  // مسار توزيعة كالي المحلية
  String _kaliPath = '/data/local/kali-armhf';
  bool _kaliMounted = false;
  bool _kaliReady = false;

  // ذاكرة تخزين مؤقت للأدوات
  final Map<String, String> _toolCache = {};
  final Map<String, List<String>> _toolCategories = {};

  // نتائج متوازية
  final Map<String, Map<String, dynamic>> _parallelResults = {};

  @override
  Future<void> awaken() async {
    await super.awaken();
    _log('🗡️ تفعيل وكيل Kali');
    await _initializeKali();
  }

  /// تهيئة كالي
  Future<void> _initializeKali() async {
    _log('🔧 جاري تهيئة توزيعة Kali المحلية...');

    // 1. التحقق من وجود كالي
    final kaliDir = Directory(_kaliPath);
    if (!await kaliDir.exists()) {
      _log('⚠️ توزيعة Kali غير موجودة في $_kaliPath');
      _log('💡 جاري البحث عن التوزيعة...');
      _kaliPath = await _findKaliPath();
      if (_kaliPath.isEmpty) {
        _log('❌ لم يتم العثور على توزيعة Kali');
        return;
      }
    }

    // 2. تحميل البيئة
    _kaliMounted = await _mountKali();
    if (!_kaliMounted) {
      _log('❌ فشل تحميل بيئة Kali');
      return;
    }

    // 3. فهرسة الأدوات
    await _indexTools();

    // 4. تصنيف الأدوات
    _categorizeTools();

    _kaliReady = true;
    _log('✅ Kali جاهزة. ${_toolCache.length} أداة متاحة.');
  }

  /// البحث عن مسار كالي
  Future<String> _findKaliPath() async {
    final possiblePaths = [
      '/data/local/kali-armhf',
      '/data/local/kali',
      '/sdcard/kali-armhf',
      '/sdcard/kali',
    ];

    for (final path in possiblePaths) {
      final dir = Directory(path);
      if (await dir.exists()) {
        return path;
      }
    }
    return '';
  }

  /// تحميل بيئة Kali
  Future<bool> _mountKali() async {
    try {
      final mounts = [
        ['mount', '-o', 'bind', '/dev', '$_kaliPath/dev'],
        ['mount', '-o', 'bind', '/dev/pts', '$_kaliPath/dev/pts'],
        ['mount', '-t', 'proc', 'proc', '$_kaliPath/proc'],
        ['mount', '-t', 'sysfs', 'sysfs', '$_kaliPath/sys'],
      ];

      for (final mount in mounts) {
        final result = await Process.run('su', ['-c', mount.join(' ')], runInShell: true);
        if (result.exitCode != 0) return false;
      }

      return true;
    } catch (_) {
      return false;
    }
  }

  /// فهرسة الأدوات
  Future<void> _indexTools() async {
    final searchPaths = [
      '$_kaliPath/usr/bin',
      '$_kaliPath/usr/sbin',
      '$_kaliPath/bin',
      '$_kaliPath/sbin',
      '$_kaliPath/usr/local/bin',
    ];

    for (final path in searchPaths) {
      final dir = Directory(path);
      if (await dir.exists()) {
        await for (final entity in dir.list()) {
          if (entity is File) {
            final name = entity.path.split('/').last;
            _toolCache[name] = entity.path;
          }
        }
      }
    }
  }

  /// تصنيف الأدوات
  void _categorizeTools() {
    _toolCategories['network'] = _toolCache.keys.where((t) =>
        t.contains('nmap') || t.contains('net') || t.contains('ping') ||
        t.contains('traceroute') || t.contains('dns') || t.contains('tcp')).toList();

    _toolCategories['exploit'] = _toolCache.keys.where((t) =>
        t.contains('metasploit') || t.contains('msf') || t.contains('exploit') ||
        t.contains('sqlmap') || t.contains('hydra')).toList();

    _toolCategories['wireless'] = _toolCache.keys.where((t) =>
        t.contains('air') || t.contains('wifi') || t.contains('wlan') ||
        t.contains('wep') || t.contains('wpa')).toList();

    _toolCategories['forensics'] = _toolCache.keys.where((t) =>
        t.contains('forensic') || t.contains('dd') || t.contains('extundelete') ||
        t.contains('testdisk')).toList();

    _toolCategories['web'] = _toolCache.keys.where((t) =>
        t.contains('nikto') || t.contains('dirb') || t.contains('wpscan') ||
        t.contains('burp') || t.contains('zap')).toList();

    _toolCategories['password'] = _toolCache.keys.where((t) =>
        t.contains('john') || t.contains('hashcat') || t.contains('crunch') ||
        t.contains('wordlist')).toList();
  }

  /// تشغيل أداة Kali
  Future<Map<String, dynamic>> runKaliTool(String toolName, {List<String>? args, Duration timeout = const Duration(seconds: 30)}) async {
    if (!_kaliReady) return {'success': false, 'error': 'Kali not ready'};

    if (!_toolCache.containsKey(toolName)) {
      return {'success': false, 'error': 'Tool not found: $toolName'};
    }

    try {
      final command = StringBuffer();
      command.write('chroot $_kaliPath /bin/bash -c "');
      command.write(toolName);
      if (args != null && args.isNotEmpty) {
        command.write(' ${args.join(' ')}');
      }
      command.write('"');

      final result = await Process.run('su', ['-c', command.toString()], runInShell: true).timeout(timeout);

      return {
        'success': result.exitCode == 0,
        'stdout': result.stdout.toString(),
        'stderr': result.stderr.toString(),
        'tool': toolName,
      };
    } catch (e) {
      return {'success': false, 'error': e.toString(), 'tool': toolName};
    }
  }

  /// تشغيل أدوات متعددة بالتوازي (Parallel Execution)
  Future<Map<String, Map<String, dynamic>>> runParallelTools(Map<String, List<String>> toolArgs) async {
    _parallelResults.clear();

    await Future.wait(toolArgs.entries.map((entry) async {
      final tool = entry.key;
      final args = entry.value;
      final result = await runKaliTool(tool, args: args);
      _parallelResults[tool] = result;
    }));

    return _parallelResults;
  }

  /// هجوم متوازي شامل
  Future<Map<String, dynamic>> parallelAttack(String target) async {
    _log('⚔️ بدء هجوم متوازي شامل على: $target');

    // إعداد الأدوات المتوازية
    final tools = {
      'nmap': ['-sV', '-O', '-p', '1-1000', target],
      'nikto': ['-h', target],
      'dirb': ['http://$target'],
      'sqlmap': ['-u', 'http://$target', '--batch', '--dbs'],
      'hydra': ['-L', '$_kaliPath/usr/share/wordlists/usernames.txt', '-P', '$_kaliPath/usr/share/wordlists/rockyou.txt', 'ssh://$target'],
    };

    final results = await runParallelTools(tools);

    // تحليل النتائج
    int successes = 0;
    int failures = 0;
    final openPorts = <String>[];
    final vulnerabilities = <String>[];

    for (final entry in results.entries) {
      if (entry.value['success'] == true) {
        successes++;
        // استخراج المعلومات من النتائج
        final stdout = entry.value['stdout'] as String;
        if (entry.key == 'nmap') {
          final portLines = stdout.split('\n').where((l) => l.contains('open'));
          for (final line in portLines) {
            openPorts.add(line.trim());
          }
        }
      } else {
        failures++;
      }
    }

    return {
      'target': target,
      'tools_used': tools.length,
      'successes': successes,
      'failures': failures,
      'open_ports': openPorts,
      'vulnerabilities': vulnerabilities,
      'full_results': results,
    };
  }

  /// فئة كاملة من الهجوم
  Future<Map<String, dynamic>> attackCategory(String target, String category) async {
    if (!_toolCategories.containsKey(category)) {
      return {'error': 'Category not found: $category'};
    }

    final tools = _toolCategories[category]!;
    final args = <String, List<String>>{};

    for (final tool in tools.take(5)) {
      args[tool] = [target];
    }

    return await runParallelTools(args);
  }

  /// تقرير Kali
  Map<String, dynamic> getKaliReport() {
    return {
      'kali_path': _kaliPath,
      'kali_ready': _kaliReady,
      'total_tools': _toolCache.length,
      'categories': _toolCategories.map((k, v) => MapEntry(k, v.length)),
    };
  }

  void _log(String message) {
    print('[KaliAgentSi] $message');
  }
}
