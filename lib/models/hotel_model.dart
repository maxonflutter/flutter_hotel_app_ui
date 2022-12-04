import 'package:google_maps_flutter/google_maps_flutter.dart';

class Hotel {
  final String thumbnailPath;
  final String title;
  final String location;
  final String address;
  final String description;
  final double ratingScore;
  final double price;
  final LatLng coordinate;
  final List<String> gallery;
  final int totalReview;

  const Hotel({
    required this.thumbnailPath,
    required this.title,
    required this.location,
    required this.address,
    required this.description,
    this.ratingScore = 0,
    required this.price,
    required this.coordinate,
    required this.gallery,
    this.totalReview = 0,
  });
}
