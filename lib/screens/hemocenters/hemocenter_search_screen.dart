import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme.dart';
import '../webview_screen.dart';

class HemocenterSearchScreen extends StatefulWidget {
  static const route = '/hemocenters';
  const HemocenterSearchScreen({super.key});

  @override
  State<HemocenterSearchScreen> createState() => _HemocenterSearchScreenState();
}

class _HemocenterSearchScreenState extends State<HemocenterSearchScreen> {
  final TextEditingController _cepCtrl = TextEditingController();
  final MapController _mapController = MapController();

  LatLng _center = LatLng(-23.55052, -46.633308); // fallback: São Paulo
  double _zoom = 12;

  bool _loading = false;
  List<_Place> _places = [];

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  Future<void> _initLocation() async {
    try {
      final enabled = await Geolocator.isLocationServiceEnabled();
      if (!enabled) return;

      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.deniedForever ||
          perm == LocationPermission.denied) {
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      _center = LatLng(pos.latitude, pos.longitude);
      _zoom = 13;
      if (mounted) setState(() {});
      // centraliza no mapa
      try {
        _mapController.move(_center, _zoom);
      } catch (_) {}
    } catch (_) {
      // mantém fallback SP
    }
  }

  bool _validateCep(String cep) => RegExp(r'^\d{5}-?\d{3}$').hasMatch(cep);

  Future<Map<String, dynamic>> _viaCep(String cep) async {
    final clean = cep.replaceAll(RegExp(r'\D'), '');
    final res =
        await http.get(Uri.parse('https://viacep.com.br/ws/$clean/json/'));
    if (res.statusCode != 200) {
      throw Exception('Erro ao buscar CEP');
    }
    final data = json.decode(res.body);
    if (data is Map && data['erro'] == true) {
      throw Exception('CEP não encontrado');
    }
    return Map<String, dynamic>.from(data);
  }

  Future<LatLng> _geocodeNominatim(String address) async {
    final url =
        'https://nominatim.openstreetmap.org/search?format=json&q=${Uri.encodeComponent(address)}';
    final res = await http.get(Uri.parse(url), headers: {
      'User-Agent': 'blood-donation-simulator/1.0 (flutter)'
    });
    if (res.statusCode != 200) throw Exception('Erro ao geocodificar endereço');
    final data = json.decode(res.body);
    if (data is List && data.isNotEmpty) {
      final lat = double.parse(data[0]['lat']);
      final lon = double.parse(data[0]['lon']);
      return LatLng(lat, lon);
    }
    throw Exception('Não foi possível converter o endereço em coordenadas');
  }

  Future<List<_Place>> _overpassAround(LatLng loc, {String? cep}) async {
    final q = '''
[out:json];
(
  node["amenity"="hospital"](around:5000,${loc.latitude},${loc.longitude});
  node["name"~"banco de sangue",i](around:10000,${loc.latitude},${loc.longitude});
  node["name"~"hemocentro",i](around:10000,${loc.latitude},${loc.longitude});
  node["name"~"hemos",i](around:10000,${loc.latitude},${loc.longitude});
  ${cep != null ? 'node["name"~"hemocentro $cep",i](around:10000,${loc.latitude},${loc.longitude});' : ''}
);
out;
''';
    final url =
        'https://overpass-api.de/api/interpreter?data=${Uri.encodeComponent(q)}';
    final res = await http.get(Uri.parse(url));
    if (res.statusCode != 200) {
      throw Exception('Erro ao consultar pontos no mapa');
    }
    final body = json.decode(res.body);
    final elements = (body['elements'] as List?) ?? [];

    return elements
        .where((e) => e['lat'] != null && e['lon'] != null)
        .map<_Place>((e) {
      final tags = Map<String, dynamic>.from(e['tags'] ?? {});
      final name = (tags['name'] as String?)?.trim().isNotEmpty == true
          ? tags['name'] as String
          : 'Hemocentro/Hospital';
      final street = (tags['addr:street'] as String?) ?? '';
      final lat = (e['lat'] as num).toDouble();
      final lon = (e['lon'] as num).toDouble();
      final dist = _distanceKm(_center, LatLng(lat, lon));
      return _Place(
        name: name,
        address: street,
        point: LatLng(lat, lon),
        distanceKm: dist,
      );
    }).toList()
      ..sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
  }

  double _distanceKm(LatLng a, LatLng b) {
    const R = 6371.0; // km
    final dLat = _deg2rad(b.latitude - a.latitude);
    final dLon = _deg2rad(b.longitude - a.longitude);
    final la1 = _deg2rad(a.latitude);
    final la2 = _deg2rad(b.latitude);
    final h = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(la1) * math.cos(la2) *
            math.sin(dLon / 2) * math.sin(dLon / 2);
    return R * 2 * math.atan2(math.sqrt(h), math.sqrt(1 - h));
  }

  double _deg2rad(double d) => d * math.pi / 180.0;

  Future<void> _onSearch() async {
    final cep = _cepCtrl.text.trim();
    if (!_validateCep(cep)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite um CEP válido')),
      );
      return;
    }

    setState(() {
      _loading = true;
      _places = [];
    });

    try {
      final via = await _viaCep(cep);
      final full =
          '${via['logradouro'] ?? ''}, ${via['bairro'] ?? ''}, ${via['localidade'] ?? ''} - ${via['uf'] ?? ''}';
      final loc = await _geocodeNominatim(full);

      // centraliza no mapa
      _center = loc;
      _zoom = 13;
      try {
        _mapController.move(loc, _zoom);
      } catch (_) {}

      final found = await _overpassAround(loc, cep: cep);
      setState(() {
        _places = found;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

List<Marker> get _markers {
  final list = <Marker>[
    // marcador da localização central (usuário ou CEP)
    Marker(
      point: _center,
      width: 40,
      height: 40,
      child: const Icon(
        Icons.location_searching,
        size: 32,
        color: kPrimary,
      ),
    ),
  ];

  for (final p in _places) {
    list.add(
      Marker(
        point: p.point,
        width: 44,
        height: 44,
        child: const Icon(
          Icons.location_on,
          size: 36,
          color: Colors.redAccent,
        ),
      ),
    );
  }
  return list;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // LOGO
              Center(
                child: Image.asset('assets/img/logo2.png',
                    height: 80, fit: BoxFit.contain),
              ),
              const SizedBox(height: 12),

              // CARD
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12.withOpacity(0.06),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Encontre um Hemocentro',
                      style: TextStyle(
                        color: kPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Digite seu CEP para encontrar os locais de doação mais próximos de você.',
                      style: TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 12),

                    // input + botão
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _cepCtrl,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Digite seu CEP',
                              filled: true,
                              fillColor: const Color(0xFFF1F1F1),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          height: 48,
                          child: ElevatedButton.icon(
                            onPressed: _loading ? null : _onSearch,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            icon: const Icon(Icons.search, color: Colors.white),
                            label: const Text(
                              'Buscar',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // MAPA (já aparece antes da busca)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        height: 220,
                        child: FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(
                            initialCenter: _center,
                            initialZoom: _zoom,
                            interactionOptions: const InteractionOptions(
                              pinchZoomThreshold: 2.5,
                            ),
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'blood-donation-simulator',
                            ),
                            MarkerLayer(markers: _markers),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    if (_loading)
                      Column(
                        children: const [
                          SizedBox(height: 8),
                          CircularProgressIndicator(color: kPrimary),
                          SizedBox(height: 12),
                          Text('Buscando locais de doação próximos',
                              style: TextStyle(
                                  fontSize: 16, color: Colors.black54)),
                        ],
                      ),

                    if (!_loading && _places.isNotEmpty)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Resultados',
                            style: TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          ..._places.map((p) => _PlaceCard(place: p)),
                        ],
                      ),

                    if (!_loading && _places.isEmpty)
                      const SizedBox.shrink(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Place {
  final String name;
  final String address;
  final LatLng point;
  final double distanceKm;
  _Place({
    required this.name,
    required this.address,
    required this.point,
    required this.distanceKm,
  });

  String get mapsUrl => Uri.encodeFull(
      'https://www.google.com/maps/search/?api=1&query=${name} ${address}');
}

class _PlaceCard extends StatelessWidget {
  final _Place place;
  const _PlaceCard({required this.place});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.local_hospital, color: kPrimary, size: 28),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(place.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 15)),
                if (place.address.isNotEmpty)
                  Text(place.address,
                      style: const TextStyle(fontSize: 13, color: Colors.black87)),
                Text('Distância: ${place.distanceKm.toStringAsFixed(1)} km',
                    style: const TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () async {
              final url = Uri.parse(
                 'https://www.google.com/maps/search/?api=1&query=${place.name} ${place.address}');
  
              await launchUrl(
                url,
                mode: LaunchMode.externalNonBrowserApplication
              );
          },

            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: kPrimary,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Ver no Maps'),
          ),
        ],
      ),
    );
  }
}
