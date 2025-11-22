import 'dart:convert';
import 'package:http/http.dart' as http;

class CepResult {
  final String cep;
  final String street;
  final String city;
  final String state;
  final double lat;
  final double lon;

  CepResult({required this.cep, required this.street, required this.city, required this.state, required this.lat, required this.lon});
}

class CepService {
  static Future<CepResult> fetch(String cep) async {
    final sanitized = cep.replaceAll(RegExp(r'[^0-9]'), '');
    final uri = Uri.parse('https://brasilapi.com.br/api/cep/v2/' + sanitized);
    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('CEP não encontrado');
    }
    final data = json.decode(res.body);
    final lat = (data['location'] != null && data['location']['coordinates'] != null)
        ? (data['location']['coordinates']['latitude'] as num?)?.toDouble() ?? 0
        : 0.0;
    final lon = (data['location'] != null && data['location']['coordinates'] != null)
        ? (data['location']['coordinates']['longitude'] as num?)?.toDouble() ?? 0
        : 0.0;
    return CepResult(
      cep: data['cep'] ?? sanitized,
      street: data['street'] ?? '',
      city: data['city'] ?? data['city_ibge'] ?? '',
      state: data['state'] ?? '',
      lat: lat,
      lon: lon,
    );
  }
}
