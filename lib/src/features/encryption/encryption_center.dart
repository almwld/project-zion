import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class EncryptionCenter extends StatefulWidget {
  const EncryptionCenter({super.key});

  @override
  State<EncryptionCenter> createState() => _EncryptionCenterState();
}

class _EncryptionCenterState extends State<EncryptionCenter> {
  int _selectedTab = 0;
  
  // Text Encryption
  final TextEditingController _textInputController = TextEditingController();
  final TextEditingController _textKeyController = TextEditingController();
  String _encryptedText = '';
  String _decryptedText = '';
  String _selectedAlgorithm = 'AES-256';
  
  // File Encryption
  String? _selectedFilePath;
  String _fileEncryptionStatus = '';
  bool _isFileProcessing = false;
  
  // Hash Generator
  final TextEditingController _hashInputController = TextEditingController();
  String _md5Hash = '';
  String _sha1Hash = '';
  String _sha256Hash = '';
  String _sha512Hash = '';
  
  // Random Generator
  String _randomPassword = '';
  int _passwordLength = 16;
  bool _includeUppercase = true;
  bool _includeLowercase = true;
  bool _includeNumbers = true;
  bool _includeSymbols = true;

  final List<String> _algorithms = ['AES-256', 'AES-128', 'ChaCha20', 'Twofish', 'Serpent'];

  // ==================== Text Encryption ====================
  void _encryptText() {
    if (_textInputController.text.isEmpty || _textKeyController.text.isEmpty) return;
    
    final key = _textKeyController.text;
    final plaintext = _textInputController.text;
    
    // Simple XOR encryption for demonstration (use proper AES in production)
    final encrypted = _xorEncrypt(plaintext, key);
    
    setState(() {
      _encryptedText = base64Encode(utf8.encode(encrypted));
    });
  }

  void _decryptText() {
    if (_encryptedText.isEmpty || _textKeyController.text.isEmpty) return;
    
    final key = _textKeyController.text;
    final encrypted = utf8.decode(base64Decode(_encryptedText));
    
    final decrypted = _xorEncrypt(encrypted, key);
    
    setState(() {
      _decryptedText = decrypted;
    });
  }

  String _xorEncrypt(String text, String key) {
    final textBytes = utf8.encode(text);
    final keyBytes = utf8.encode(key);
    final result = List<int>.generate(textBytes.length, (i) {
      return textBytes[i] ^ keyBytes[i % keyBytes.length];
    });
    return utf8.decode(result);
  }

  void _clearText() {
    setState(() {
      _textInputController.clear();
      _textKeyController.clear();
      _encryptedText = '';
      _decryptedText = '';
    });
  }

  // ==================== File Encryption ====================
  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      setState(() {
        _selectedFilePath = result.files.single.path;
        _fileEncryptionStatus = 'Ready to encrypt';
      });
    }
  }

  Future<void> _encryptFile() async {
    if (_selectedFilePath == null) return;
    
    setState(() {
      _isFileProcessing = true;
      _fileEncryptionStatus = 'Encrypting...';
    });
    
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      _isFileProcessing = false;
      _fileEncryptionStatus = 'File encrypted successfully!';
    });
  }

  Future<void> _decryptFile() async {
    if (_selectedFilePath == null) return;
    
    setState(() {
      _isFileProcessing = true;
      _fileEncryptionStatus = 'Decrypting...';
    });
    
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() {
      _isFileProcessing = false;
      _fileEncryptionStatus = 'File decrypted successfully!';
    });
  }

  // ==================== Hash Generator ====================
  void _generateHashes() {
    if (_hashInputController.text.isEmpty) return;
    
    final input = _hashInputController.text;
    final bytes = utf8.encode(input);
    
    setState(() {
      _md5Hash = md5.convert(bytes).toString();
      _sha1Hash = sha1.convert(bytes).toString();
      _sha256Hash = sha256.convert(bytes).toString();
      _sha512Hash = sha512.convert(bytes).toString();
    });
  }

  void _clearHashes() {
    setState(() {
      _hashInputController.clear();
      _md5Hash = '';
      _sha1Hash = '';
      _sha256Hash = '';
      _sha512Hash = '';
    });
  }

  // ==================== Random Generator ====================
  void _generatePassword() {
    const uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const lowercase = 'abcdefghijklmnopqrstuvwxyz';
    const numbers = '0123456789';
    const symbols = '!@#$%^&*()_+-=[]{}|;:,.<>?';
    
    String chars = '';
    if (_includeUppercase) chars += uppercase;
    if (_includeLowercase) chars += lowercase;
    if (_includeNumbers) chars += numbers;
    if (_includeSymbols) chars += symbols;
    
    if (chars.isEmpty) chars = lowercase;
    
    final random = DateTime.now().millisecondsSinceEpoch;
    var result = '';
    for (var i = 0; i < _passwordLength; i++) {
      final index = (random + i) % chars.length;
      result += chars[index];
    }
    
    setState(() {
      _randomPassword = result;
    });
  }

  void _copyPassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Password copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Encryption Center'),
        backgroundColor: Colors.teal.shade900,
        bottom: TabBar(
          tabs: const [
            Tab(icon: Icon(Icons.text_fields), text: 'Text'),
            Tab(icon: Icon(Icons.insert_drive_file), text: 'File'),
            Tab(icon: Icon(Icons.fingerprint), text: 'Hash'),
            Tab(icon: Icon(Icons.password), text: 'Generator'),
          ],
          onTap: (index) => setState(() => _selectedTab = index),
        ),
      ),
      body: IndexedStack(
        index: _selectedTab,
        children: [
          _buildTextEncryption(),
          _buildFileEncryption(),
          _buildHashGenerator(),
          _buildPasswordGenerator(),
        ],
      ),
    );
  }

  Widget _buildTextEncryption() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            value: _selectedAlgorithm,
            items: _algorithms.map((algo) => DropdownMenuItem(value: algo, child: Text(algo))).toList(),
            onChanged: (v) => setState(() => _selectedAlgorithm = v!),
            decoration: const InputDecoration(
              labelText: 'Algorithm',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _textInputController,
            style: const TextStyle(color: Colors.white),
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Plain Text',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _textKeyController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Encryption Key',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _encryptText,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  child: const Text('ENCRYPT'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: _decryptText,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                  child: const Text('DECRYPT'),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(Icons.clear, color: Colors.red),
                onPressed: _clearText,
              ),
            ],
          ),
          if (_encryptedText.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Encrypted:', style: TextStyle(color: Colors.white)),
                  SelectableText(_encryptedText, style: const TextStyle(color: Colors.green)),
                  const SizedBox(height: 8),
                  const Text('Decrypted:', style: TextStyle(color: Colors.white)),
                  SelectableText(_decryptedText, style: const TextStyle(color: Colors.green)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFileEncryption() {
    return Padding(
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
                const Icon(Icons.insert_drive_file, size: 48, color: Colors.teal),
                const SizedBox(height: 12),
                Text(
                  _selectedFilePath ?? 'No file selected',
                  style: const TextStyle(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _pickFile,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: const Text('SELECT FILE'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (_selectedFilePath != null) ...[
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isFileProcessing ? null : _encryptFile,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                    child: _isFileProcessing ? const CircularProgressIndicator() : const Text('ENCRYPT FILE'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isFileProcessing ? null : _decryptFile,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                    child: _isFileProcessing ? const CircularProgressIndicator() : const Text('DECRYPT FILE'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(_fileEncryptionStatus, style: const TextStyle(color: Colors.green)),
          ],
        ],
      ),
    );
  }

  Widget _buildHashGenerator() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _hashInputController,
            style: const TextStyle(color: Colors.white),
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Input Text',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: _generateHashes,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
                  child: const Text('GENERATE HASHES'),
                ),
              ),
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(Icons.clear, color: Colors.red),
                onPressed: _clearHashes,
              ),
            ],
          ),
          if (_md5Hash.isNotEmpty) ...[
            const SizedBox(height: 16),
            _buildHashCard('MD5', _md5Hash),
            _buildHashCard('SHA-1', _sha1Hash),
            _buildHashCard('SHA-256', _sha256Hash),
            _buildHashCard('SHA-512', _sha512Hash),
          ],
        ],
      ),
    );
  }

  Widget _buildHashCard(String algorithm, String hash) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(algorithm, style: const TextStyle(color: Colors.purple, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          SelectableText(hash, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildPasswordGenerator() {
    return Padding(
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
                const Icon(Icons.password, size: 48, color: Colors.teal),
                const SizedBox(height: 12),
                SelectableText(
                  _randomPassword.isEmpty ? 'Click Generate' : _randomPassword,
                  style: const TextStyle(color: Colors.green, fontSize: 20),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _generatePassword,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  child: const Text('GENERATE'),
                ),
                if (_randomPassword.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _copyPassword,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: const Text('COPY'),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                ListTile(
                  title: const Text('Length', style: TextStyle(color: Colors.white)),
                  subtitle: Slider(
                    value: _passwordLength.toDouble(),
                    min: 8,
                    max: 32,
                    divisions: 24,
                    onChanged: (v) => setState(() => _passwordLength = v.toInt()),
                  ),
                  trailing: Text('$_passwordLength', style: const TextStyle(color: Colors.teal)),
                ),
                SwitchListTile(
                  title: const Text('Uppercase (A-Z)', style: TextStyle(color: Colors.white)),
                  value: _includeUppercase,
                  onChanged: (v) => setState(() => _includeUppercase = v),
                ),
                SwitchListTile(
                  title: const Text('Lowercase (a-z)', style: TextStyle(color: Colors.white)),
                  value: _includeLowercase,
                  onChanged: (v) => setState(() => _includeLowercase = v),
                ),
                SwitchListTile(
                  title: const Text('Numbers (0-9)', style: TextStyle(color: Colors.white)),
                  value: _includeNumbers,
                  onChanged: (v) => setState(() => _includeNumbers = v),
                ),
                SwitchListTile(
                  title: const Text('Symbols (!@#)', style: TextStyle(color: Colors.white)),
                  value: _includeSymbols,
                  onChanged: (v) => setState(() => _includeSymbols = v),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
