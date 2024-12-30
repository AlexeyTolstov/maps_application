import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Marker? tempMarker;
  Set<Marker> _markers = {};
  Position? userPosition;
  bool isLoading = true;

  Future<void> getPosition() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.checkPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      userPosition = null;
    } else {
      userPosition = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.low,
        ),
      );
      setState(() {});
    }
    if (userPosition != null)
      print("${userPosition!.latitude} ${userPosition!.longitude}");
  }

  @override
  void initState() {
    getPosition().then((_) {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading)
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Получение координат пользователя'),
              CircularProgressIndicator()
            ],
          ),
        ),
      );

    return Scaffold(
      appBar: AppBar(title: Text('Карта с панелью')),
      body: GoogleMap(
        mapType: MapType.hybrid,
        markers: {
          ..._markers,
          if (tempMarker != null) tempMarker!,
        },
        onTap: (LatLng latLng) {
          print("${latLng.latitude} ${latLng.longitude}");

          setState(() {
            tempMarker = Marker(
              markerId: MarkerId(latLng.toString()),
              position: latLng,
              infoWindow: InfoWindow(
                title: 'Точка на карте',
                snippet:
                    'Lat: ${latLng.latitude.toStringAsFixed(4)}\nLng: ${latLng.longitude.toStringAsFixed(4)}',
              ),
              icon: BitmapDescriptor.defaultMarker,
            );
          });

          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => _buildBottomSheet(latLng),
          ).then((value) {
            setState(() {
              tempMarker = null;
            });
          });
        },
        initialCameraPosition: (userPosition != null)
            ? CameraPosition(
                target: LatLng(userPosition!.latitude, userPosition!.longitude),
                zoom: 15,
              )
            : CameraPosition(
                target: LatLng(0, 0),
                zoom: 5,
              ),
      ),
    );
  }

  Widget _buildBottomSheet(LatLng latLng) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 1.0,
      expand: false,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Широта ${latLng.latitude.toStringAsFixed(5)}"),
                  Text("Долгота ${latLng.longitude.toStringAsFixed(5)}"),
                  Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            setState(() {
                              _markers.add(tempMarker!);
                              tempMarker = null;
                            });
                          },
                          child: const Text("Добавить точку"))
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
