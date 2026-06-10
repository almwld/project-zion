import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:ui' as ui;
import 'package:shared_preferences/shared_preferences.dart';

class CameraBackgroundToggle extends StatefulWidget {
  final Widget child;
  const CameraBackgroundToggle({super.key, required this.child});

  @override
  State<CameraBackgroundToggle> createState() => _CameraBackgroundToggleState();
}

class _CameraBackgroundToggleState extends State<CameraBackgroundToggle> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraActive = false;
  bool _cameraEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _cameraEnabled = prefs.getBool('camera_background') ?? false;
    });
    if (_cameraEnabled) {
      _initCamera();
    }
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _cameraController = CameraController(
          _cameras![1], // كاميرا أمامية
          ResolutionPreset.low,
          enableAudio: false,
        );
        await _cameraController!.initialize();
        setState(() => _isCameraActive = true);
      }
    } catch (e) {
      debugPrint('Camera error: $e');
    }
  }

  Future<void> _toggleCamera() async {
    final prefs = await SharedPreferences.getInstance();
    if (!_cameraEnabled) {
      await _initCamera();
      setState(() => _cameraEnabled = true);
      await prefs.setBool('camera_background', true);
    } else {
      await _cameraController?.dispose();
      setState(() {
        _cameraEnabled = false;
        _isCameraActive = false;
      });
      await prefs.setBool('camera_background', false);
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // خلفية الكاميرا أو الخلفية العادية
        if (_isCameraActive && _cameraController != null && _cameraController!.value.isInitialized)
          Positioned.fill(
            child: ClipRect(
              child: BackdropFilter(
                filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Opacity(
                  opacity: 0.6,
                  child: CameraPreview(_cameraController!),
                ),
              ),
            ),
          )
        else
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF00FF41), Colors.black],
              ),
            ),
          ),
        // المحتوى الرئيسي
        widget.child,
        // زر تفعيل الكاميرا
        Positioned(
          top: 10,
          right: 10,
          child: FloatingActionButton.small(
            onPressed: _toggleCamera,
            backgroundColor: _cameraEnabled ? Colors.green : Colors.grey,
            child: Icon(Icons.camera_alt, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
