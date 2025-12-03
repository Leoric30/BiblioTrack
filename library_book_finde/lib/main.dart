import 'package:flutter/material.dart';
import 'package:library_book_finde/screens/scanner_screen.dart'; // Importamos la pantalla de escaneo

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Quita la etiqueta 'DEBUG' para el video
      title: 'Bibliotrack Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bibliotrack', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo o Icono grande
            const Icon(Icons.manage_search, size: 100, color: Colors.green),
            const SizedBox(height: 20),
            
            const Text(
              'Sistema de Auditoría\nBibliotecaria',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),

            // BOTÓN PRINCIPAL PARA EL VIDEO
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.camera_alt, color: Colors.white),
                label: const Text(
                  'AUDITAR ESTANTE',
                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[800],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () {
                  // Navegar a la pantalla de escaneo
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ScannerScreen()),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Botón de relleno (solo visual para que se vea completa la app)
            SizedBox(
              width: double.infinity,
              height: 60,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.history),
                label: const Text('HISTORIAL DE REPORTES'),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Función no requerida para este demo")),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}