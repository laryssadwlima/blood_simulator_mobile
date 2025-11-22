import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/hemocenter.dart';

class HemocenterService {
  static Future<List<Hemocenter>> search({required double lat, required double lon, int radiusMeters = 15000}) async {
    final query = '''
      [out:json][timeout:25];
      (
        node["amenity"="blood_donation"](around:$radiusMeters,$lat,$lon);
        way["amenity"="blood_donation"](around:$radiusMeters,$lat,$lon);
        relation["amenity"="blood_donation"](around:$radiusMeters,$lat,$lon);
        node["healthcare"="blood_donation"](around:$radiusMeters,$lat,$lon);
      );
      out center tags;
    ''';

    final res = await http.post(
      Uri.parse('https://overpass-api.de/api/interpreter'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {'data': query},
    );

    if (res.statusCode != 200) {
      throw Exception('Falha ao buscar hemocentros');
    }

    final data = json.decode(res.body);
    final elements = (data['elements'] as List?) ?? [];

    return elements.map((e) {
      final tags = (e['tags'] ?? {}) as Map<String, dynamic>;
      final name = (tags['name'] ?? 'Hemocentro').toString();
      double latVal = 0;
      double lonVal = 0;
      if (e['lat'] != null && e['lon'] != null) {
        latVal = (e['lat'] as num).toDouble();
        lonVal = (e['lon'] as num).toDouble();
      } else if (e['center'] != null) {
        latVal = (e['center']['lat'] as num).toDouble();
        lonVal = (e['center']['lon'] as num).toDouble();
      }
      final addressParts = [
        tags['addr:street'],
        tags['addr:housenumber'],
        tags['addr:city'],
      ];
      final address = addressParts.whereType<String>().join(', ');
      return Hemocenter(
        name: name,
        lat: latVal,
        lon: lonVal,
        address: address.isEmpty ? null : address,
        phone: tags['phone']?.toString(),
      );
    }).toList();
  }
}
