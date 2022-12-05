import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../repositories/hotel_repository.dart';
import '../utilities/constants.dart';
import '../widgets/custom_marker_generator.dart';
import '../widgets/map_marker_widget.dart';
import 'hotel_data_controller.dart';

part 'location_controller.g.dart';

@riverpod
Future<LocationController> locationController(LocationControllerRef ref) async {
  final hotelControllerNotifier =
      ref.watch(hotelDataControllerProvider.notifier);
  final hotelRepo = ref.watch(hotelRepositoryProvider);
  final locationController = LocationController();

  Set<MarkerWidget> markerWidgets = (await hotelRepo.getHotelList())
      .map(
        (hotel) => MarkerWidget(
          marker: Marker(
            markerId: MarkerId(hotel.coordinate.toString()),
            position: hotel.coordinate,
            onTap: () async {
              hotelControllerNotifier.setSelectedHotel(hotel);
              await locationController.setNewLocation(
                  hotel.coordinate.latitude, hotel.coordinate.longitude);
            },
          ),
          widget: MapMarkerPrice(
            hotel.price.toUSD(),
          ),
        ),
      )
      .toSet();
  locationController.setMarker(markers: markerWidgets);
  return locationController;
}

class LocationController {
  final globalMarkerKey = GlobalKey();
  final defaultLocation = const LatLng(-7.795529617707741, 110.36872726427349);
  final Completer<GoogleMapController> _mapController = Completer();

  final Set<MarkerWidget> _markers = {};
  Set<MarkerWidget> get markers => _markers;

  LatLng _currentLocation = const LatLng(0, 0);
  LatLng get currentLocation => _currentLocation;

  void onMapCreated(GoogleMapController controller) {
    _mapController.complete(controller);
  }

  Future<void> setNewLocation(double lat, double lng) async {
    _currentLocation = LatLng(lat, lng);
    CameraPosition cameraPos = CameraPosition(
      target: _currentLocation,
      zoom: 15,
    );
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPos));
  }

  void setMarker({required Set<MarkerWidget> markers}) {
    _markers.addAll(markers);
  }
}
