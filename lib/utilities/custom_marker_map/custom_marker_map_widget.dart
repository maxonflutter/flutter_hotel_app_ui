import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'marker_widget.dart';
part 'widget_to_marker_generator.dart';

class CustomMarkerMap extends StatefulWidget {
  final MapCreatedCallback? onMapCreated;
  final CameraPosition initialCameraPosition;
  final Set<MarkerWidget> markerWidgets;
  final bool zoomControlsEnabled;
  final bool zoomGesturesEnabled;
  final bool myLocationEnabled;

  const CustomMarkerMap({
    Key? key,
    required this.initialCameraPosition,
    this.onMapCreated,
    required this.markerWidgets,
    this.zoomControlsEnabled = true,
    this.zoomGesturesEnabled = true,
    this.myLocationEnabled = false,
  }) : super(key: key);

  @override
  State<CustomMarkerMap> createState() => _CustomMarkerMapState();
}

class _CustomMarkerMapState extends State<CustomMarkerMap> {
  Set<Marker> markers = {};
  bool isMarkerGenerated = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.markerWidgets.isNotEmpty)
          _MarkerGenerator(
            markerWidgets: widget.markerWidgets.toList(growable: false),
            callbackAction: (listMarker) {
              // Set generated Marker with custom widget to Gmap
              setState(
                () {
                  markers = listMarker.toSet();
                  isMarkerGenerated = true;
                },
              );
            },
          ),
        isMarkerGenerated
            ? GoogleMap(
                key: widget.key,
                initialCameraPosition: widget.initialCameraPosition,
                onMapCreated: widget.onMapCreated,
                markers: markers,
                zoomControlsEnabled: widget.zoomControlsEnabled,
                zoomGesturesEnabled: widget.zoomGesturesEnabled,
                myLocationEnabled: widget.myLocationEnabled,
              )
            : Center(
                child: CircularProgressIndicator(),
              ),
      ],
    );
  }
}
