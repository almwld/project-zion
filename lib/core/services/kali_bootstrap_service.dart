import 'dart:async';
import 'dart:io';

class KaliBootstrapService {
  static const String _kaliPath = '/data/local/kali';
  static const String _kaliArchive = '/sdcard/kali-armhf.tar.gz';

  /// الفحص والتجهيز الكامل
  static Future<String> bootstrap() async {
    // 1. فحص إذا كانت التوزيعة موجودة
    if (await _isKaliInstalled()) {
      // 2. تجهيز بيئة chroot
      final mountResult = await _mountFilesystems();
      if (!mountResult) return 'Failed to mount filesystems. Root required.';

      // 3. تشغيل الخدمات
      await _startServices();

      return 'Kali Linux is ready.';
    }

    // 4. إذا لم تكن موجودة، محاولة التثبيت
    final installResult = await _installKali();
    if (!installResult) return 'Failed to install Kali. Archive not found at $_kaliArchive';

    // 5. بعد التثبيت، تجهيز وتشغيل
    final mountResult = await _mountFilesystems();
    if (!mountResult) return 'Failed to mount filesystems. Root required.';

    await _startServices();

    return 'Kali Linux installed and ready.';
  }

  /// فحص وجود التوزيعة
  static Future<bool> _isKaliInstalled() async {
    try {
      final result = await Process.run('su', ['-c', 'ls $_kaliPath/bin/bash'], runInShell: true);
      return result.exitCode == 0;
    } catch (_) {
      return false;
    }
  }

  /// تثبيت التوزيعة من الأرشيف
  static Future<bool> _installKali() async {
    try {
      // فحص وجود الأرشيف
      final archive = File(_kaliArchive);
      if (!await archive.exists()) return false;

      // إنشاء المجلد
      await Process.run('su', ['-c', 'mkdir -p $_kaliPath'], runInShell: true);

      // فك الضغط
      final result = await Process.run(
        'su',
        ['-c', 'tar -xzf $_kaliArchive -C $_kaliPath --numeric-owner'],
        runInShell: true,
      );

      return result.exitCode == 0;
    } catch (_) {
      return false;
    }
  }

  /// ربط أنظمة الملفات
  static Future<bool> _mountFilesystems() async {
    try {
      final mounts = [
        'mount -o bind /dev $_kaliPath/dev',
        'mount -o bind /dev/pts $_kaliPath/dev/pts',
        'mount -o bind /proc $_kaliPath/proc',
        'mount -o bind /sys $_kaliPath/sys',
        'mount -t tmpfs tmpfs $_kaliPath/tmp',
      ];

      for (final mount in mounts) {
        final result = await Process.run('su', ['-c', mount], runInShell: true);
        if (result.exitCode != 0) return false;
      }

      return true;
    } catch (_) {
      return false;
    }
  }

  /// تشغيل الخدمات الأساسية
  static Future<void> _startServices() async {
    try {
      // بدء SSH
      await Process.run('su', ['-c', 'chroot $_kaliPath /etc/init.d/ssh start'], runInShell: true);
      // بدء الشبكة
      await Process.run('su', ['-c', 'chroot $_kaliPath /etc/init.d/networking start'], runInShell: true);
    } catch (_) {}
  }

  /// إيقاف التوزيعة
  static Future<void> shutdown() async {
    try {
      // إيقاف الخدمات
      await Process.run('su', ['-c', 'chroot $_kaliPath /etc/init.d/ssh stop'], runInShell: true);
      await Process.run('su', ['-c', 'chroot $_kaliPath /etc/init.d/networking stop'], runInShell: true);

      // فصل أنظمة الملفات
      final umounts = [
        'umount $_kaliPath/tmp',
        'umount $_kaliPath/sys',
        'umount $_kaliPath/proc',
        'umount $_kaliPath/dev/pts',
        'umount $_kaliPath/dev',
      ];

      for (final umount in umounts) {
        await Process.run('su', ['-c', umount], runInShell: true);
      }
    } catch (_) {}
  }

  /// الحصول على حالة التوزيعة
  static Future<Map<String, dynamic>> getStatus() async {
    final installed = await _isKaliInstalled();
    return {
      'installed': installed,
      'path': _kaliPath,
      'archive': _kaliArchive,
    };
  }
}
