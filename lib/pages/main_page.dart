import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maps_application/api_client.dart';
import 'package:maps_application/data/suggestion.dart';
import 'package:maps_application/widgets/tutorial.dart';

int myUserId = 1;

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Position? userPosition;

  Marker? tempMarker;
  Set<Marker> _markers = {};

  bool isEnabled = true;
  bool isLoaded = false;

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

  void update_points() {
    for (var suggestion in getListPoints()) {
      var suggestionMarker = Marker(
        markerId: MarkerId(suggestion.coords.toString()),
        position: suggestion.coords!,
        onTap: () {
          setState(() => isEnabled = (myUserId == suggestion.author_id));
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => _buildBottomSheet(suggestion),
          ).then((_) {
            setState(() {
              isEnabled = false;
              controllerNamePoint.clear();
              controllerDescriptionPoint.clear();
            });
          });
        },
        icon: BitmapDescriptor.defaultMarker,
      );

      _markers.add(suggestionMarker);
    }
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

    update_points();

    setState(() {});
    Future.delayed(Duration.zero, () => Tutorial(context).showTutorialDialog());
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
          Suggestion tempSuggestion = Suggestion(
              name: "", description: "", author_id: myUserId, coords: latLng);

          controllerNamePoint.text = tempSuggestion.name;
          controllerDescriptionPoint.text = tempSuggestion.description;

          isEnabled = (myUserId == tempSuggestion.author_id);

          setState(() {
            tempMarker = Marker(
              markerId: MarkerId(latLng.toString()),
              position: latLng,
              onTap: () {
                setState(() {
                  isEnabled = (myUserId == tempSuggestion.author_id);
                });
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) => _buildBottomSheet(tempSuggestion),
                ).then((_) {
                  setState(() {
                    tempMarker = null;
                    isEnabled = false;
                    controllerNamePoint.clear();
                    controllerDescriptionPoint.clear();
                  });
                });
              },
              icon: BitmapDescriptor.defaultMarker,
            );
          });

          setState(() => isEnabled = (myUserId == tempSuggestion.author_id));

          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) => _buildBottomSheet(tempSuggestion),
          ).then((_) {
            setState(() {
              tempMarker = null;
              isEnabled = false;
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
                /// Москва
                target: LatLng(55.75222, 37.61556),
                zoom: 5,
              ),
      ),
    );
  }

  Widget _buildBottomSheet(Suggestion suggestion) {
    controllerNamePoint.text = suggestion.name;
    controllerDescriptionPoint.text = suggestion.description;

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
                  readOnly: !isEnabled,
                  decoration: InputDecoration(
                    hintText: "Название",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => suggestion.name = value,
                ),
                SizedBox(height: 10),
                TextField(
                  textInputAction: TextInputAction.done,
                  controller: controllerDescriptionPoint,
                  readOnly: !isEnabled,
                  decoration: InputDecoration(
                    hintText: "Описание",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 10,
                  onChanged: (value) => suggestion.description = value,
                ),
                Row(
                  children: [
                    if (isEnabled)
                      TextButton(
                        onPressed: (isHaveId(suggestion.id))
                            ? () {
                                setState(() {
                                  if (myUserId == suggestion.author_id)
                                    editSuggestion(
                                      suggestion.id,
                                      name: suggestion.name,
                                      description: suggestion.description,
                                      category: suggestion.category,
                                    );

                                  tempMarker = null;
                                  Navigator.pop(context);
                                });
                              }
                            : () {
                                if (myUserId == suggestion.author_id)
                                  addSuggestion(suggestion);
                                update_points();
                                tempMarker = null;
                                Navigator.pop(context);
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
                    "Координаты: ${suggestion.coords!.latitude.toStringAsFixed(3)}/${suggestion.coords!.longitude.toStringAsFixed(3)}"),
              ],
            ),
          ),
        );
      },
    );
  }
}
