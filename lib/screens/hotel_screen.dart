import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../gen/assets.gen.dart';
import '../gen/colors.gen.dart';
import '../models/hotel_model.dart';
import '../utilities/app_text.dart';
import '../widgets/app_icon_container_widget.dart';
import '../widgets/custom_button.dart';
import '../widgets/facilities_section_widget.dart';
import '../widgets/price_night_text_widget.dart';
import '../widgets/rating_widget.dart';

class HotelDetailScreen extends StatelessWidget {
  const HotelDetailScreen({
    Key? key,
    required this.hotel,
  }) : super(key: key);

  final Hotel hotel;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Image.asset(
              hotel.thumbnailPath,
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: size.height / 2),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24).copyWith(bottom: 0),
                    child: Column(
                      children: [
                        _HotelTitleSection(hotel: hotel),
                        const SizedBox(height: 16),
                        const FacilitiesSection(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _GallerySection(hotel.gallery),
                  Padding(
                    padding: const EdgeInsets.all(24).copyWith(top: 16),
                    child: _LocationSection(
                      address: hotel.address,
                      coordinate: hotel.coordinate,
                      description: hotel.description,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: SafeArea(
              child: Container(
                margin: const EdgeInsets.all(16),
                height: 50,
                color: Colors.transparent,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppIconContainer(
                      Assets.icon.chevronDown.svg(height: 25),
                      onTap: () => Navigator.of(context).pop(),
                    ),
                    AppIconContainer(Assets.icon.wishlist.svg(height: 25)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _ReserveBar(hotel.price),
    );
  }
}

class _ReserveBar extends StatelessWidget {
  final double price;
  const _ReserveBar(this.price, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.medium(
                'Start from',
                fontWeight: FontWeight.normal,
              ),
              PricePerNightTextWidget(price),
            ],
          ),
          Flexible(
            child: SizedBox(
              width: 150,
              child: CustomButton(
                buttonText: 'Reserve',
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HotelTitleSection extends StatelessWidget {
  const _HotelTitleSection({
    Key? key,
    required this.hotel,
  }) : super(key: key);

  final Hotel hotel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.large(
          hotel.title,
          textAlign: TextAlign.left,
          maxLine: 2,
          textOverflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Assets.icon.location.svg(color: ColorName.darkGrey, height: 15),
            const SizedBox(width: 8),
            AppText.small(hotel.location),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: RatingWidget(
            ratingScore: hotel.ratingScore,
            showReviews: true,
            totalReviewer: hotel.totalReview,
          ),
        ),
      ],
    );
  }
}

class _GallerySection extends StatelessWidget {
  final List<String> galleries;
  const _GallerySection(this.galleries, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: AppText.medium('Gallery', fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 150,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: galleries.length,
            itemBuilder: (context, index) {
              final imgPath = galleries[index];
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (index == 0) const SizedBox(width: 16),
                  AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            image: AssetImage(imgPath),
                            fit: BoxFit.cover,
                          )),
                    ),
                  ),
                  if (index == galleries.length - 1) const SizedBox(width: 16),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _LocationSection extends StatelessWidget {
  final String address;
  final LatLng coordinate;
  final String description;
  const _LocationSection({
    required this.address,
    required this.coordinate,
    required this.description,
    Key? key,
  }) : super(key: key);

  Future<BitmapDescriptor?> _convertToMarkerBitMap() async {
    final data = await rootBundle.load(Assets.icon.pinPng.path);
    final uint8List = data.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(uint8List);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.medium('Location', fontWeight: FontWeight.bold),
        const SizedBox(height: 10),
        AppText.medium(address, fontWeight: FontWeight.normal),
        FutureBuilder<BitmapDescriptor?>(
            future: _convertToMarkerBitMap(),
            builder: (context, snapshot) {
              final bitMapData = snapshot.data;
              if (bitMapData == null) {
                return const SizedBox.shrink();
              }
              return AbsorbPointer(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: GoogleMap(
                    zoomControlsEnabled: false,
                    myLocationEnabled: false,
                    initialCameraPosition:
                        CameraPosition(target: coordinate, zoom: 15),
                    markers: {
                      Marker(
                        markerId: MarkerId(address),
                        position: coordinate,
                        // icon: BitmapDescriptor.fromBytes(
                        //     File('icon/pin.png').readAsBytesSync()),
                        icon: bitMapData,
                      ),
                    },
                  ),
                ),
              );
            }),
        AppText.medium(description, fontWeight: FontWeight.normal),
        const SizedBox(height: 6),
        AppText.medium(
          'Show more',
          textDecoration: TextDecoration.underline,
        )
      ],
    );
  }
}
