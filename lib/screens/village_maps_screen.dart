import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class VillageMapsScreen extends StatefulWidget {
  const VillageMapsScreen({super.key});

  @override
  State<VillageMapsScreen> createState() => _VillageMapsScreenState();
}

class _VillageMapsScreenState extends State<VillageMapsScreen> {
  late GoogleMapController mapController;

  // Approximate coordinates for Randusari, Pasuruan, East Java
  static const LatLng _center = LatLng(-7.6469, 112.7183);

  // Placeholder markers for residents (can be replaced with real data from Supabase)
  final Set<Marker> _markers = {
    const Marker(
      markerId: MarkerId('resident1'),
      position: LatLng(-7.6469, 112.7183),
      infoWindow: InfoWindow(
        title: 'Resident 1',
        snippet: 'Sample resident location',
      ),
    ),
    const Marker(
      markerId: MarkerId('resident2'),
      position: LatLng(-7.6475, 112.7190),
      infoWindow: InfoWindow(
        title: 'Resident 2',
        snippet: 'Another sample location',
      ),
    ),
  };

  @override
  void initState() {
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
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
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: const CameraPosition(
            target: _center,
            zoom: 15.0,
          ),
          markers: _markers,
          mapType: MapType.normal,
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: true,
          zoomGesturesEnabled: true,
          scrollGesturesEnabled: true,
          tiltGesturesEnabled: true,
          rotateGesturesEnabled: true,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          mapController.animateCamera(CameraUpdate.newLatLng(_center));
        },
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.center_focus_strong),
        tooltip: 'Center on Randusari',
      ),
    );
  }
}
