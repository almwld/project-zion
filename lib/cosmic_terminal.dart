import 'package:flutter/material.dart';

class CosmicTerminal extends StatefulWidget {
  const CosmicTerminal({super.key});

  @override
  State<CosmicTerminal> createState() => _CosmicTerminalState();
}

class _CosmicTerminalState extends State<CosmicTerminal> {
  final TextEditingController _cmdCtrl = TextEditingController();
  final List<String> _output = ['Zion Terminal v3.0', 'اكتب "help" للمساعدة.'];
  final ScrollController _scrollCtrl = ScrollController();

  void _execute(String cmd) {
    setState(() {
      _output.add('> $cmd');
      switch (cmd.trim().toLowerCase()) {
        case 'help':
          _output.add('ls, pwd, whoami, date, clear, nmap, msfconsole, help');
          break;
        case 'clear':
          _output.clear();
          break;
        case 'ls':
          _output.add('bin  boot  dev  etc  home  lib  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var');
          break;
        case 'pwd':
          _output.add('/home/zion');
          break;
        case 'whoami':
          _output.add('root');
          break;
        case 'date':
          _output.add(DateTime.now().toString());
          break;
        default:
          _output.add('command not found: $cmd');
      }
      _scrollCtrl.animateTo(_scrollCtrl.position.maxScrollExtent, duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
    });
    _cmdCtrl.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('الطرفية الكونية', style: TextStyle(color: Color(0xFF00FF41), fontFamily: 'Cairo')),
        backgroundColor: Colors.black,
        leading: IconButton(icon: const Icon(Icons.close, color: Color(0xFF00FF41)), onPressed: () => Navigator.pop(context)),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.all(16),
              itemCount: _output.length,
              itemBuilder: (context, i) => Text(
                _output[i],
                style: TextStyle(
                  color: _output[i].startsWith('>') ? const Color(0xFF00FF41) : Colors.white70,
                  fontFamily: 'monospace',
                  fontSize: 14,
                ),
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(color: Color(0xFF0A0E0A), border: Border(top: BorderSide(color: Color(0xFF1A3A1A)))),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                const Text('zion:~# ', style: TextStyle(color: Color(0xFF00FF41), fontFamily: 'monospace')),
                Expanded(
                  child: TextField(
                    controller: _cmdCtrl,
                    style: const TextStyle(color: Colors.white, fontFamily: 'monospace'),
                    decoration: const InputDecoration(border: InputBorder.none, isDense: true),
                    cursorColor: const Color(0xFF00FF41),
                    onSubmitted: _execute,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
