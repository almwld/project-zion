import 'dart:async';
import 'dart:io';

class KaliLoaderService {
  static const String _installPath = '/data/local/kali';
  static const String _zionFolder = '/storage/emulated/0/Zion Universal';
  static const String _prootBinary = '/data/data/com.termux/files/usr/bin/proot';

  /// المصادر المحتملة للتوزيعة (مرتبة حسب الأفضلية)
  static final List<Map<String, String>> _sources = [
    {'name': 'bootstrap-aarch64.zip', 'path': '$_zionFolder/bootstrap-aarch64.zip', 'type': 'zip'},
    {'name': 'kali-bootstrap.tar.gz', 'path': '$_zionFolder/kali-bootstrap.tar.gz', 'type': 'tar'},
  ];

  /// ============ التثبيت والتجهيز ============
  static Future<String> install() async {
    // 1. فحص إذا كان Kali مثبتًا بالفعل
    if (await _isInstalled()) {
      return '✅ Kali Linux مثبت مسبقًا وجاهز.';
    }

    // 2. البحث عن أفضل مصدر متاح
    String? bestSource;
    String? sourceType;
    for (final source in _sources) {
      if (await File(source['path']!).exists()) {
        bestSource = source['path'];
        sourceType = source['type'];
        break;
      }
    }

    if (bestSource == null) {
      return '❌ لم يتم العثور على أي توزيعة في $_zionFolder';
    }

    // 3. التثبيت من المصدر المختار
    final success = await _extract(bestSource, sourceType!);
    if (!success) return '❌ فشل فك الضغط. تأكد من وجود مساحة كافية.';

    // 4. تجهيز البيئة
    await _setupEnvironment();

    return '✅ تم تثبيت Kali Linux بنجاح (600+ أداة جاهزة)';
  }

  /// ============ التشغيل والتنفيذ ============
  static Future<Map<String, dynamic>> execute(String command) async {
    if (!await _isInstalled()) {
      return {'success': false, 'error': 'Kali غير مثبت. قم بالتثبيت أولاً.'};
    }

    try {
      final prootArgs = [
        '-r', _installPath,
        '-b', '/dev:/dev',
        '-b', '/proc:/proc',
        '-b', '/sys:/sys',
        '-b', '/sdcard:/sdcard',
        '-b', '/storage/emulated/0:/storage/emulated/0',
        '/bin/bash', '-c', command,
      ];

      final result = await Process.run(_prootBinary, prootArgs, runInShell: true);

      return {
        'success': result.exitCode == 0,
        'stdout': result.stdout.toString().trim(),
        'stderr': result.stderr.toString().trim(),
        'exitCode': result.exitCode,
      };
    } catch (e) {
      return {'success': false, 'error': e.toString()};
    }
  }

  /// ============ أوامر جاهزة للأدوات الشائعة ============
  static Future<String> nmap(String target, {String args = '-sV -O'}) async {
    final result = await execute('nmap $args $target');
    return result['stdout'] ?? result['stderr'] ?? 'Error';
  }

  static Future<String> msfconsole(String commands) async {
    final result = await execute('msfconsole -q -x "$commands"');
    return result['stdout'] ?? result['stderr'] ?? 'Error';
  }

  static Future<String> sqlmap(String url) async {
    final result = await execute('sqlmap -u "$url" --batch --dbs');
    return result['stdout'] ?? result['stderr'] ?? 'Error';
  }

  static Future<String> hydra(String target, String service, String user, String wordlist) async {
    final result = await execute('hydra -l $user -P $wordlist $service://$target');
    return result['stdout'] ?? result['stderr'] ?? 'Error';
  }

  static Future<String> aircrack(String capFile, String wordlist) async {
    final result = await execute('aircrack-ng $capFile -w $wordlist');
    return result['stdout'] ?? result['stderr'] ?? 'Error';
  }

  static Future<String> john(String hashFile, {String wordlist = '/usr/share/wordlists/rockyou.txt'}) async {
    final result = await execute('john $hashFile --wordlist=$wordlist');
    return result['stdout'] ?? result['stderr'] ?? 'Error';
  }

  static Future<String> nikto(String url) async {
    final result = await execute('nikto -h $url');
    return result['stdout'] ?? result['stderr'] ?? 'Error';
  }

  static Future<String> dirb(String url) async {
    final result = await execute('dirb $url');
    return result['stdout'] ?? result['stderr'] ?? 'Error';
  }

  static Future<String> wpscan(String url) async {
    final result = await execute('wpscan --url $url --enumerate');
    return result['stdout'] ?? result['stderr'] ?? 'Error';
  }

  /// ============ الحالة والمعلومات ============
  static Future<bool> _isInstalled() async {
    try {
      final result = await Process.run(_prootBinary, [
        '-r', _installPath,
        '-b', '/dev:/dev',
        '/bin/bash', '-c', 'ls /bin/bash'
      ], runInShell: true);
      return result.exitCode == 0;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> isAvailable() async => await _isInstalled();

  static Future<int> getToolCount() async {
    final result = await execute('ls /usr/bin /usr/sbin /usr/local/bin 2>/dev/null | wc -l');
    return int.tryParse(result['stdout']?.trim() ?? '0') ?? 0;
  }

  static Future<Map<String, dynamic>> getStatus() async {
    final installed = await _isInstalled();
    final toolCount = installed ? await getToolCount() : 0;

    return {
      'installed': installed,
      'path': _installPath,
      'tools_available': toolCount,
      'method': 'proot',
    };
  }

  /// ============ الدوال الداخلية ============
  static Future<bool> _extract(String archivePath, String type) async {
    try {
      await Process.run('mkdir', ['-p', _installPath], runInShell: true);

      ProcessResult result;
      if (type == 'zip') {
        result = await Process.run('unzip', ['-o', archivePath, '-d', _installPath], runInShell: true);
      } else {
        result = await Process.run('tar', ['-xzf', archivePath, '-C', _installPath], runInShell: true);
      }

      return result.exitCode == 0;
    } catch (_) {
      return false;
    }
  }

  static Future<void> _setupEnvironment() async {
    final dirs = ['$_installPath/dev', '$_installPath/proc', '$_installPath/sys', '$_installPath/tmp'];
    for (final dir in dirs) {
      await Process.run('mkdir', ['-p', dir], runInShell: true);
    }
  }
}
