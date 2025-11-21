import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VillageMapsScreen extends StatefulWidget {
  const VillageMapsScreen({super.key});

  @override
  State<VillageMapsScreen> createState() => _VillageMapsScreenState();
}

class _VillageMapsScreenState extends State<VillageMapsScreen> {
  late MapController mapController;

  // Approximate coordinates for Randusari, Pasuruan, East Java
  static final LatLng _center = LatLng(-7.6469, 112.7183);

  List<Marker> _markers = [];

  @override
  void initState() {
    super.initState();
    mapController = MapController();
    _fetchResidents();
  }

  Future<void> _fetchResidents() async {
    try {
      final response = await Supabase.instance.client
          .from('residents')
          .select(
            'id, nama_penduduk, rt, rw, nik, jenis_kelamin, latitude, longitude, address',
          );

      final List<dynamic> data = response as List<dynamic>;

      List<Marker> markers = [];
      for (var resident in data) {
        final marker = Marker(
          point: LatLng(resident['latitude'], resident['longitude']),
          width: 40.0,
          height: 40.0,
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(resident['nama_penduduk']),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ID: ${resident['id']}'),
                      Text('RT: ${resident['rt']}'),
                      Text('RW: ${resident['rw']}'),
                      Text('NIK: ${resident['nik']}'),
                      Text('Jenis Kelamin: ${resident['jenis_kelamin']}'),
                      Text('Alamat: ${resident['address']}'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
            child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
          ),
        );
        markers.add(marker);
      }

      setState(() {
        _markers = markers;
      });
    } catch (e) {
      // Handle error, perhaps show a snackbar
      setState(() {});
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error fetching residents: $e')));
    }
  }

  void _onMapCreated(MapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Village Maps - Randusari'),
        backgroundColor: Colors.blueAccent,
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('About Village Maps'),
                  content: const Text(
                    'This map displays resident locations in Randusari, Pasuruan City, East Java. '
                    'Markers represent sample resident positions. '
                    'Tap on markers for more details.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blueGrey.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FlutterMap(
          mapController: mapController,
          options: MapOptions(
            initialCenter: _center,
            initialZoom: 15.0,
            onMapReady: () => _onMapCreated(mapController),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.app',
            ),
            MarkerLayer(markers: _markers),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          mapController.move(_center, 15.0);
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.center_focus_strong),
        tooltip: 'Center on Randusari',
      ),
    );
  }
}
