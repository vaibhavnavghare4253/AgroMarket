import 'package:agri_market/config/colors.dart';
import 'package:agri_market/providers/check_out_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class CustomGoogleMap extends StatefulWidget {
  @override
  _GoogleMapState createState() => _GoogleMapState();
}

class _GoogleMapState extends State<CustomGoogleMap> {
  LatLng _initialCameraPosition = LatLng(19.8776, 75.3423);
  late GoogleMapController controller;
  Location _location = Location();
  Set<Marker> _markers = {}; // Set to hold the markers

  void _onMapCreated(GoogleMapController _value) {
    controller = _value;
    _location.onLocationChanged.listen((event) {
      LatLng currentPosition = LatLng(event.latitude!, event.longitude!);
      // Update the camera position and marker
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: currentPosition,
            zoom: 15,
          ),
        ),
      );
      setState(() {
        _markers = {
          Marker(
            markerId: MarkerId("currentLocation"),
            position: currentPosition,
            infoWindow: InfoWindow(title: "You are here"),
          ),
        };
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    CheckoutProvider checkoutProvider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Location"),
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _initialCameraPosition,
                  zoom: 10,
                ),
                mapType: MapType.normal,
                onMapCreated: _onMapCreated,
                mapToolbarEnabled: true,
                markers: _markers, // Add markers to the map
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 50,
                  width: double.infinity,
                  margin: EdgeInsets.only(
                    right: 60,
                    left: 10,
                    bottom: 40,
                    top: 40,
                  ),
                  child: MaterialButton(
                    onPressed: () async {
                      await _location.getLocation().then((value) {
                        setState(() {
                          LatLng selectedLocation =
                          LatLng(value.latitude!, value.longitude!);
                          _markers.add(
                            Marker(
                              markerId: MarkerId("selectedLocation"),
                              position: selectedLocation,
                              infoWindow:
                              InfoWindow(title: "Selected Location"),
                            ),
                          );
                          checkoutProvider.setLocation = value;
                        });
                      });
                      Navigator.of(context).pop();
                    },
                    color: primaryColor, // Replace with primaryColor
                    child: Text("Confirm Location"),
                    shape: StadiumBorder(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
