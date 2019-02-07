import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(title: const Text('Google Maps demo')),
      body: MapsDemo(),
    ));
  }
}

class MapsDemo extends StatefulWidget {
  @override
  State createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MapsDemo> {
  GoogleMapController mapController;
  MapType _mapType = MapType.normal;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(0),
        child: Stack(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  bearing: 270.0,
                  target: LatLng(28.5843, 77.8539),
                  tilt: 30.0,
                  zoom: 17.0,
                ),
                mapType: _mapType,
                zoomGesturesEnabled: true,
                compassEnabled: true,
                myLocationEnabled: true,
                trackCameraPosition: true,
                rotateGesturesEnabled: true,
                onMapCreated: _onMapCreated,
              ),
            ),
            Align(
                alignment: Alignment.bottomRight,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 400,
                      width: 100,
                    ),
                    FloatingActionButton(
                        tooltip: 'Camera Position',
                        child: Icon(Icons.location_searching),
                        onPressed: showCameraPositionDialog),
                    SizedBox(
                      height: 8,
                      width: 100,
                    ),
                    FloatingActionButton(
                      tooltip: 'Create marker',
                      child: const Text('Marker'),
                      onPressed: () {
                        LatLng latlong = LatLng(28.573453, 77.847323);
                        mapController.addMarker(MarkerOptions(
                            position: latlong,
                            infoWindowText: InfoWindowText("Tite", "Content"),
                            rotation: 45,
                            icon: BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueOrange)));
                        mapController
                            .animateCamera(CameraUpdate.newLatLng(latlong));
                      },
                    ),
                    SizedBox(
                      height: 8,
                      width: 100,
                    ),
                    FloatingActionButton(
                        tooltip: 'Toggle Map type',
                        child: Icon(Icons.map),
                        onPressed: _changeMapType),
                  ],
                )),
          ],
        ));
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _changeMapType() {
    setState(() {
      _mapType =
          _mapType == MapType.normal ? MapType.satellite : MapType.normal;
    });
  }

  void showCameraPositionDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (_) => new AlertDialog(
              title: Text('Camera Location'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Lat: ${mapController.cameraPosition.target.latitude}' +
                        ', Lon: ${mapController.cameraPosition.target.longitude}'),
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }
}
