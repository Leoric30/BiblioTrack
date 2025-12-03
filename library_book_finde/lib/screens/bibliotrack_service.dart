import 'dart:math';

class ShelfAnalysisResult {
  final bool hasError;
  final String title;
  final String message;
  final String? misplacedBook;
  final String? correctLocation;

  ShelfAnalysisResult({
    required this.hasError,
    required this.title,
    required this.message,
    this.misplacedBook,
    this.correctLocation,
  });
}

class BibliotrackService {
  Future<ShelfAnalysisResult> analyzeShelf() async {
    // Retraso para simular que piensa
    await Future.delayed(const Duration(seconds: 3));

    // A veces da error (Sabotaje), a veces éxito. Ideal para el video.
    bool detectAnomaly = Random().nextBool();

    if (detectAnomaly) {
      return ShelfAnalysisResult(
        hasError: true,
        title: "⚠️ ANOMALÍA DETECTADA",
        message: "Libro fuera de rango Dewey identificado.",
        misplacedBook: "813.54 - Literatura Americana",
        correctLocation: "Pasillo 4, Estante B",
      );
    } else {
      return ShelfAnalysisResult(
        hasError: false,
        title: "✅ ESTANTE VALIDADO",
        message: "Todo en orden. No se detectaron anomalías.",
      );
    }
  }
}