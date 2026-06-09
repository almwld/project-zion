import 'package:riverpod/riverpod.dart';
import '../systems/ultimate_kali_loader_system.dart';
import '../systems/ultimate_crypto_system.dart';
import '../systems/ultimate_osint_system.dart';

final unifiedCoreProvider = Provider<UnifiedCoreService>((ref) => UnifiedCoreService());

class UnifiedCoreService {
  final UltimateKaliLoaderSystem _kaliLoader = UltimateKaliLoaderSystem();
  final UltimateCryptoSystem _crypto = UltimateCryptoSystem();
  final UltimateOsintSystem _osint = UltimateOsintSystem();

  Future<String> execute(String command, {String? target, Map<String, String>? options}) async {
    try {
      switch (command) {
        case 'nmap':
          final result = await _kaliLoader.runNmap(target ?? '127.0.0.1', args: options?['args']);
          return result['stdout'] ?? result['stderr'] ?? 'No output';
        case 'msfconsole':
          final result = await _kaliLoader.runMsfconsole(commands: options?['commands']);
          return result['stdout'] ?? result['stderr'] ?? 'No output';
        case 'sqlmap':
          final result = await _kaliLoader.runSqlmap(target ?? 'http://localhost', args: options?['args']);
          return result['stdout'] ?? result['stderr'] ?? 'No output';
        case 'hydra':
          final result = await _kaliLoader.runHydra(target ?? '127.0.0.1', options?['service'] ?? 'ssh', options?['username'] ?? 'root', options?['wordlist'] ?? '/usr/share/wordlists/rockyou.txt');
          return result['stdout'] ?? result['stderr'] ?? 'No output';
        case 'aircrack':
          final result = await _kaliLoader.runAircrack(options?['file'] ?? '/tmp/capture.cap', wordlist: options?['wordlist']);
          return result['stdout'] ?? result['stderr'] ?? 'No output';
        case 'john':
          final result = await _kaliLoader.runJohn(options?['hash'] ?? '/tmp/hash.txt', wordlist: options?['wordlist']);
          return result['stdout'] ?? result['stderr'] ?? 'No output';
        case 'nikto':
          final result = await _kaliLoader.runNikto(target ?? 'http://localhost');
          return result['stdout'] ?? result['stderr'] ?? 'No output';
        case 'dirb':
          final result = await _kaliLoader.runDirb(target ?? 'http://localhost');
          return result['stdout'] ?? result['stderr'] ?? 'No output';
        case 'wpscan':
          final result = await _kaliLoader.runWpscan(target ?? 'http://localhost');
          return result['stdout'] ?? result['stderr'] ?? 'No output';
        case 'tshark':
          final result = await _kaliLoader.runTshark(interface: options?['interface'], filter: options?['filter']);
          return result['stdout'] ?? result['stderr'] ?? 'No output';
        case 'tools':
          final tools = await _kaliLoader.getInstalledTools();
          return 'Installed tools: ${tools.length}\n${tools.take(50).join('\n')}...';
        case 'sha256':
          return _crypto.sha256(target ?? '');
        case 'sha3':
          return _crypto.sha3(target ?? '');
        case 'gatherIpInfo':
          final info = await _osint.gatherIpInfo(target ?? '8.8.8.8');
          return info.toString();
        case 'gatherEmailInfo':
          final info = _osint.gatherEmailInfo(target ?? 'test@example.com');
          return info.toString();
        case 'searchSocialMedia':
          final results = _osint.searchSocialMedia(target ?? 'testuser');
          return results.toString();
        case 'help':
          return _getHelpText();
        default:
          return 'Unknown command: $command';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

  String _getHelpText() => '''
=== PROJECT ZION ===
nmap <target>    - Network scan
msfconsole       - Metasploit
sqlmap <target>  - SQL inject
hydra <target>   - Brute force
aircrack <file>  - WiFi crack
john <hash>      - John Ripper
nikto <target>   - Web scan
dirb <target>    - Dir brute
wpscan <target>  - WP scan
tshark           - Sniffer
tools            - Kali tools
sha256 <text>    - Hash
sha3 <text>      - Hash
help             - Help
==================
''';
}
