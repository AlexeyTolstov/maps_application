import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps_application/api_client.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

/// Нужен рефакторинг создания и отметки точки

class _MainPageState extends State<MainPage> {
  Marker? tempMarker;
  Set<Marker> _markers = {};
  Position? userPosition;
  bool isLoading = true;
  int current_id = 0;

  Map<int, List<String>> pointsWithDescription = {};

  TextEditingController controllerNamePoint = TextEditingController();
  TextEditingController controllerDescriptionPoint = TextEditingController();

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
    }

    if (userPosition != null)
      print("${userPosition!.latitude} ${userPosition!.longitude}");

    setState(() {});
  }

  @override
  void initState() {
    getPosition().then((_) {
      joke(
              latLng: LatLng(
                  userPosition?.latitude ?? 0, userPosition?.longitude ?? 0))
          .then((args) {
        setState(() {
          isLoading = false;
        });
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
        mapType: MapType.normal,
        markers: {
          ..._markers,
          if (tempMarker != null) tempMarker!,
        },
        onTap: (LatLng latLng) {
          print("${latLng.latitude} ${latLng.longitude}");
          int my_id = current_id++;
          setState(() {
            tempMarker = Marker(
              markerId: MarkerId(latLng.toString()),
              position: latLng,
              onTap: () {
                controllerNamePoint.text = pointsWithDescription[my_id]![0];
                controllerDescriptionPoint.text =
                    pointsWithDescription[my_id]![1];

                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) => _buildBottomSheet(latLng, my_id),
                ).then((value) {
                  setState(() {
                    tempMarker = null;
                    controllerNamePoint.clear();
                    controllerDescriptionPoint.clear();
                  });
                });
              },
              icon: BitmapDescriptor.defaultMarker,
            );
          });

          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => _buildBottomSheet(latLng, my_id),
          ).then((value) {
            setState(() {
              tempMarker = null;
              controllerNamePoint.clear();
              controllerDescriptionPoint.clear();
            });
          });
        },
        initialCameraPosition: (userPosition != null)
            ? CameraPosition(
                target: LatLng(userPosition!.latitude, userPosition!.longitude),
                zoom: 15,
              )
            : CameraPosition(
                target: LatLng(55.75222, 37.61556), // Москва
                zoom: 5,
              ),
      ),
    );
  }

  Widget _buildBottomSheet(LatLng latLng, int my_id) {
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.55,
      maxChildSize: 0.7,
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
                  /// Имя точки

                  TextField(
                    controller: controllerNamePoint,
                    decoration: InputDecoration(
                      hintText: "Название",
                      border: OutlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.done,
                  ),

                  SizedBox(height: 10),

                  /// Описание точки

                  TextField(
                    controller: controllerDescriptionPoint,
                    decoration: InputDecoration(
                      hintText: "Описание",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 10,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.done,
                  ),

                  /// Панель кнопок

                  Row(
                    children: [
                      /// Кнопка добавления
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _markers.add(tempMarker!);
                            pointsWithDescription[my_id] = [
                              controllerNamePoint.text,
                              controllerDescriptionPoint.text
                            ];
                            tempMarker = null;
                            Navigator.pop(context);
                          });
                        },
                        child: const Text("Добавить"),
                      ),

                      /// Кнопка отмены
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          tempMarker = null;
                        },
                        child: const Text("Отмена"),
                      ),
                    ],
                  ),

                  /// Координаты точки
                  Text(
                    "Координаты: ${latLng.latitude.toStringAsFixed(3)}/${latLng.longitude.toStringAsFixed(3)}",
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
