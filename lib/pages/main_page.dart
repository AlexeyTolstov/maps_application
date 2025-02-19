import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps_application/api_client.dart';

/// Нужно переписать:
/// - Получение списка точек
/// - получение предложений по {id}
/// - редактирования предложения по {id}
/// - создание предложения

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Position? userPosition;

  Marker? tempMarker;
  Set<Marker> _markers = {};

  bool isLoaded = false;
  int current_id = 0;

  Map<int, List<String>> pointsWithDescription = {};

  TextEditingController controllerNamePoint = TextEditingController();
  TextEditingController controllerDescriptionPoint = TextEditingController();

  Future<void> getPosition() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
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
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getPosition().then((_) {
      joke(
        latLng:
            LatLng(userPosition?.latitude ?? 0, userPosition?.longitude ?? 0),
      ).then((_) {
        setState(() {
          isLoaded = true;
        });
      });
    });

    Future.delayed(Duration.zero, () => _showTutorialDialog());
  }

  void _showTutorialDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Добро пожаловать!"),
        content: Text(
            "Хотите пройти небольшое обучение по использованию приложения?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Нет, я все знаю"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _tutorial1();
            },
            child: Text("Да"),
          ),
        ],
      ),
    );
  }

  void _tutorial1() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        title: Text(
          "Обучение",
          style: TextStyle(color: Colors.white),
        ),
        content: Container(
          width: double.infinity,
          child: Container(
            padding: EdgeInsets.all(20),
            child: Text(
              style: TextStyle(color: Colors.white),
              "Если хотите добавить точку с описанием, просто нажмите в нужное место, введите текст – и готово!",
            ),
          ),
        ),
        actions: [
          TextButton(
            style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.white)),
            onPressed: () {
              Navigator.pop(context);
              _tutorial2();
            },
            child: Text("Дальше ->"),
          ),
        ],
      ),
    );
  }

  void _tutorial2() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        title: Text(
          "Обучение",
          style: TextStyle(color: Colors.white),
        ),
        content: Container(
          width: double.infinity,
          child: Container(
            padding: EdgeInsets.all(20),
            child: Text(
              style: TextStyle(color: Colors.white),
              "Чтобы построить маршрут или добавить предложение, откройте меню в верхнем правом углу.",
            ),
          ),
        ),
        actions: [
          TextButton(
            style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.white)),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Завершить!"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoaded)
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
      appBar: AppBar(
        title: Text('Карта'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/menu");
            },
            icon: Icon(Icons.menu),
          )
        ],
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        markers: {
          ..._markers,
          if (tempMarker != null) tempMarker!,
        },
        onTap: (LatLng latLng) {
          int my_id = current_id++;
          setState(() {
            tempMarker = Marker(
              markerId: MarkerId(latLng.toString()),
              position: latLng,
              onTap: () {
                controllerNamePoint.text =
                    pointsWithDescription[my_id]?[0] ?? "";
                controllerDescriptionPoint.text =
                    pointsWithDescription[my_id]?[1] ?? "";
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) => _buildBottomSheet(latLng, my_id),
                ).then((_) {
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
          ).then((_) {
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
                target: LatLng(55.75222, 37.61556),
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  textInputAction: TextInputAction.done,
                  controller: controllerNamePoint,
                  decoration: InputDecoration(
                    hintText: "Название",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  textInputAction: TextInputAction.done,
                  controller: controllerDescriptionPoint,
                  decoration: InputDecoration(
                    hintText: "Описание",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 10,
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _markers.add(tempMarker!);
                          pointsWithDescription[my_id] = [
                            controllerNamePoint.text,
                            controllerDescriptionPoint.text,
                          ];
                          tempMarker = null;
                          Navigator.pop(context);
                        });
                      },
                      child: Text("Добавить"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        tempMarker = null;
                      },
                      child: Text("Отмена"),
                    ),
                  ],
                ),
                Text(
                    "Координаты: ${latLng.latitude.toStringAsFixed(3)}/${latLng.longitude.toStringAsFixed(3)}"),
              ],
            ),
          ),
        );
      },
    );
  }
}
