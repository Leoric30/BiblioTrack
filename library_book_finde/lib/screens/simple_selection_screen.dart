import 'package:flutter/material.dart';

class SimpleSelectionScreen extends StatelessWidget {
  const SimpleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scanner de Biblioteca')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.library_books, size: 80, color: Colors.indigo),
              const SizedBox(height: 20),
              const Text(
                'Selecciona el estante a auditar:',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/camera', arguments: '600'),
                child: const Padding(padding: EdgeInsets.all(15), child: Text('Sección 600 (Tecnología)')),
              ),
              const SizedBox(height: 15),
              
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/camera', arguments: '800'),
                child: const Padding(padding: EdgeInsets.all(15), child: Text('Sección 800 (Literatura)')),
              ),
              const SizedBox(height: 15),

              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/camera', arguments: '900'),
                child: const Padding(padding: EdgeInsets.all(15), child: Text('Sección 900 (Historia)')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}