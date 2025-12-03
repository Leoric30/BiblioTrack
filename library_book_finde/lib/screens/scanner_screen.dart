import 'package:flutter/material.dart';
// import 'bibliotrack_service.dart'; // Comentado si no tienes este archivo aún

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  // Estado
  bool _isAnalyzing = false;
  int _photosTaken = 0;
  String _statusMessage = "Apunta al estante completo";
  
  // 1️⃣ CAMBIO AQUÍ: Usamos las rutas locales de tus assets
  final String _mockPhoto1 = "assets/Prueba1.jpg";
  final String _mockPhoto2 = "assets/Prueba2.jpg";

  // Función para simular el "Click" de la cámara
  void _takePicture() async {
    setState(() {
      _photosTaken++;
    });
  }

  // Función para enviar las fotos a "analizar"
  void _analyzeImages() async {
    setState(() {
      _isAnalyzing = true;
      _statusMessage = "Subiendo imágenes (2/2)...";
    });

    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() => _statusMessage = "Fusionando imágenes...");
    
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() => _statusMessage = "Detectando códigos Dewey...");

    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() => _statusMessage = "Consultando base de datos...");

    // Simulamos que terminó
    setState(() {
      _isAnalyzing = false;
    });

    if (!mounted) return;
    
    // 2️⃣ CAMBIO: Mostramos el Dialog Grande en lugar del SnackBar pequeño
    _showSuccessDialog();
  }

  // 3️⃣ NUEVA FUNCIÓN: Dialog grande y bonito
  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Obliga a presionar el botón
      builder: (context) => Dialog(
        backgroundColor: Colors.grey[900],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle, size: 60, color: Colors.greenAccent),
              ),
              const SizedBox(height: 24),
              const Text(
                "¡Análisis Exitoso!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "La demo ha finalizado correctamente.\nTodo parece estar en orden.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Cerrar dialog
                    _resetScanner(); // Reiniciar escáner
                  },
                  child: const Text("ACEPTAR", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _resetScanner() {
    setState(() {
      _photosTaken = 0;
      _statusMessage = "Apunta al estante completo";
      _isAnalyzing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    String buttonText = "CAPTURAR FOTO 1";
    if (_photosTaken == 1) buttonText = "CAPTURAR FOTO 2";
    if (_photosTaken == 2) buttonText = "ANALIZAR ESTANTE";

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Captura de Evidencia', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // 1. VISOR DE CÁMARA
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.grey[900],
            child: _photosTaken < 2 
            ? const Center(child: Icon(Icons.camera_alt, size: 80, color: Colors.white12))
            : Image.asset(
                _mockPhoto1, 
                fit: BoxFit.cover, 
                color: Colors.black54, 
                colorBlendMode: BlendMode.darken
              ), 
          ),

          // 2. GUIAS DE ENCUADRE
          if (_photosTaken < 2)
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white54, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      _cornerLine(), Transform.rotate(angle: 1.57, child: _cornerLine())
                    ]),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Transform.rotate(angle: -1.57, child: _cornerLine()), Transform.rotate(angle: 3.14, child: _cornerLine())
                    ]),
                  ],
                ),
              ),
            ),

          // 3. MINIATURAS
          Positioned(
            bottom: 150,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_photosTaken >= 1)
                  _buildThumbnail(_mockPhoto1, "Izquierda"),
                
                const SizedBox(width: 20),

                if (_photosTaken >= 2)
                  _buildThumbnail(_mockPhoto2, "Derecha"),
              ],
            ),
          ),

          // 4. INTERFAZ DE CONTROL
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(bottom: 40, top: 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black, Colors.transparent],
                ),
              ),
              child: Column(
                children: [
                  Text(
                    _isAnalyzing ? _statusMessage : "Paso ${_photosTaken + 1} de 2",
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  
                  GestureDetector(
                    onTap: () {
                      if (_isAnalyzing) return;
                      if (_photosTaken < 2) {
                        _takePicture();
                      } else {
                        _analyzeImages();
                      }
                    },
                    child: _isAnalyzing 
                    ? const CircularProgressIndicator(color: Colors.greenAccent)
                    : Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: _photosTaken == 2 ? Colors.greenAccent : Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                           BoxShadow(color: _photosTaken == 2 ? Colors.greenAccent.withOpacity(0.5) : Colors.transparent, blurRadius: 20)
                        ]
                      ),
                      child: Icon(
                        _photosTaken == 2 ? Icons.search : Icons.camera, 
                        size: 40, 
                        color: _photosTaken == 2 ? Colors.black : Colors.black
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 10),
                  Text(
                    _isAnalyzing ? "Por favor espere..." : buttonText,
                    style: TextStyle(color: _photosTaken == 2 ? Colors.greenAccent : Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cornerLine() {
    return Container(
      width: 20, height: 20,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.white, width: 3),
          left: BorderSide(color: Colors.white, width: 3),
        )
      ),
    );
  }

  Widget _buildThumbnail(String assetPath, String label) {
    return Column(
      children: [
        Container(
          width: 80, height: 80,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.greenAccent, width: 2),
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: AssetImage(assetPath), 
              fit: BoxFit.cover
            )
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10))
      ],
    );
  }
}