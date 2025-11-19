import 'dart:convert';
import 'package:http/http.dart' as http;

class TranslationService {
  static const String baseUrl = 'https://api.funtranslations.com/translate';

  // Lista de traduções disponíveis na API FunTranslations
  static const List<Map<String, String>> availableTranslations = [
    {'id': 'yoda', 'name': 'Yoda'},
    {'id': 'shakespeare', 'name': 'Shakespeare'},
    {'id': 'pirate', 'name': 'Pirate'},
    {'id': 'minion', 'name': 'Minion'},
    {'id': 'chef', 'name': 'Swedish Chef'},
    {'id': 'dothraki', 'name': 'Dothraki'},
    {'id': 'valyrian', 'name': 'Valyrian'},
    {'id': 'klingon', 'name': 'Klingon'},
    {'id': 'vulcan', 'name': 'Vulcan'},
    {'id': 'sith', 'name': 'Sith'},
    {'id': 'gungan', 'name': 'Gungan'},
    {'id': 'mandalorian', 'name': 'Mandalorian'},
    {'id': 'morse', 'name': 'Morse Code'},
    {'id': 'binary', 'name': 'Binary'},
    {'id': 'oldenglish', 'name': 'Old English'},
    {'id': 'leetspeak', 'name': 'Leetspeak'},
  ];

  Future<String> translate(String text, String translationType) async {
    try {
      final url = Uri.parse(
        '$baseUrl/$translationType.json?text=${Uri.encodeComponent(text)}',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['contents']['translated'];
      } else if (response.statusCode == 429) {
        throw Exception(
          'Limite de requisições atingido. Tente novamente em alguns minutos.',
        );
      } else {
        throw Exception('Erro ao traduzir: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro na tradução: $e');
    }
  }
}
