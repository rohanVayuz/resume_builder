/*
pk.eyJ1IjoibWlnaHR5eDEyMyIsImEiOiJja2lhNTlyY3kwZjIyMnBtdjRwMHBiM3JlIn0.ZFchUTKXENLHz-GFDzuvKw
 */

import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class AbloMapUI extends StatefulWidget {
  @override
  _AbloMapUIState createState() => _AbloMapUIState();
}

class _AbloMapUIState extends State<AbloMapUI> {
  MapboxMapController mapController;

  void _onMapCreated(MapboxMapController _mapController) {
    mapController = _mapController;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    mapController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MapboxMap(
        accessToken:
            "pk.eyJ1IjoibWlnaHR5eDEyMyIsImEiOiJja2lhNTlyY3kwZjIyMnBtdjRwMHBiM3JlIn0.ZFchUTKXENLHz-GFDzuvKw",
        onMapCreated: _onMapCreated,
        styleString: "assets/style.json",
        initialCameraPosition:
            CameraPosition(target: LatLng(-11.989816, -77.063096),
              zoom: 2

            ),
      ),
    );
  }
}
