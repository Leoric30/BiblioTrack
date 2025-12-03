// lib/screens/simple_camera_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class SimpleCameraScreen extends StatefulWidget {
  final String section;
  
  const SimpleCameraScreen({super.key, required this.section});

  @override
  State<SimpleCameraScreen> createState() => _SimpleCameraScreenState();
}

class _SimpleCameraScreenState extends State<SimpleCameraScreen> {
  CameraController? _controller;
  final List<XFile> _takenPhotos = [];
  bool _isCameraReady = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;
    
    _controller = CameraController(
      cameras.first,
      ResolutionPreset.medium,
    );
    
    await _controller!.initialize();
    setState(() => _isCameraReady = true);
  }

  Future<void> _takePhoto() async {
    if (!_isCameraReady || _takenPhotos.length >= 3) return;
    
    try {
      final photo = await _controller!.takePicture();
      setState(() => _takenPhotos.add(photo));
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _sendToApi() async {
    if (_takenPhotos.length < 3) {
      _showMessage('Necesitas 3 fotos');
      return;
    }
    
    // Convertir XFile a bytes temporales
    final List<List<int>> photosBytes = [];
    for (var photo in _takenPhotos) {
      final bytes = await photo.readAsBytes();
      photosBytes.add(bytes);
    }
    
    // Aquí llamas a la API de tu amigo
    print('Enviando ${_takenPhotos.length} fotos de sección ${widget.section}');
    
    // Mostrar resultado
    _showResult();
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  void _showResult() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('✅ Análisis Completado'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Sección: ${widget.section}'),
            const SizedBox(height: 10),
            const Text('3 fotos analizadas'),
            const SizedBox(height: 10),
            const Text('Resultado: Ubicación CORRECTA ✓'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _resetPhotos() {
    setState(() => _takenPhotos.clear());
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sección ${widget.section}'),
      ),
      body: Column(
        children: [
          // Vista de cámara
          Expanded(
            child: _isCameraReady && _controller != null
                ? CameraPreview(_controller!)
                : const Center(child: CircularProgressIndicator()),
          ),
          
          // Contador de fotos
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Fotos: ${_takenPhotos.length}/3'),
                Text('Sección: ${widget.section}'),
              ],
            ),
          ),
          
          // Miniaturas de fotos
          if (_takenPhotos.isNotEmpty)
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _takenPhotos.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.file(
                      File(_takenPhotos[index].path),
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
          
          // Botones
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _resetPhotos,
                    child: const Text('REINICIAR'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _takenPhotos.length >= 3 ? _sendToApi : _takePhoto,
                    child: Text(
                      _takenPhotos.length >= 3 ? 'ANALIZAR' : 'TOMAR FOTO',
                    ),
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