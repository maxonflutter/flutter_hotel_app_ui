import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controllers/hotel_data_controller.dart';
import '../controllers/location_controller.dart';
import '../utilities/custom_marker_map/custom_marker_map_widget.dart';
import '../widgets/hotel_card.dart';

class MapScreen extends HookConsumerWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationController = ref.watch(locationControllerProvider);
    final hotelController = ref.watch(hotelDataControllerProvider);
    return Scaffold(
      body: locationController.when(
        data: (controller) => Stack(
          children: [
            CustomMarkerMap(
              onMapCreated: controller.onMapCreated,
              initialCameraPosition: CameraPosition(
                target: controller.defaultLocation,
                zoom: 12.0,
              ),
              markerWidgets: controller.markers,
            ),
            hotelController.maybeWhen(
              data: (hotel) => Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: HotelCard(
                    hotel: hotel,
                  ),
                ),
              ),
              orElse: () => const SizedBox.shrink(),
            )
          ],
        ),
        error: (e, s) => const SizedBox.shrink(),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
