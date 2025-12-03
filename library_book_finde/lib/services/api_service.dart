import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';

class ApiService {
  static const int FLASK_PORT = 5000;

  static String get baseUrl {
    if (Platform.isAndroid) {
      // ⚠️ IMPORTANTE: Si 10.0.2.2 sigue fallando, cambiaremos esto por tu IP real
      return 'http://10.0.2.2:$FLASK_PORT'; 
    }
    return 'http://localhost:$FLASK_PORT';
  }

  static Future<Map<String, dynamic>> uploadPhotos({
    required String section,
    required List<XFile> photos,
  }) async {
    final uri = Uri.parse('$baseUrl/upload');
    
    // Creamos un cliente persistente
    final client = http.Client();

    try {
      final request = http.MultipartRequest('POST', uri);
      
      // ELIMINAMOS esta línea porque estaba cortando la conexión prematuramente
      // request.headers['Connection'] = 'close'; 

      request.fields['section'] = section;

      for (int i = 0; i < photos.length; i++) {
        request.files.add(
          await http.MultipartFile.fromPath('file_$i', photos[i].path),
        );
      }

      print('⏳ Enviando fotos a $uri... Espere...');

      // Usamos el cliente con un timeout explícito de 60 segundos
      final streamedResponse = await client.send(request).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          throw Exception('Tiempo de espera agotado. El servidor tardó demasiado.');
        },
      );

      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Error del Servidor (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    } finally {
      client.close(); // Cerramos el cliente limpiamente al terminar
    }
  }
}