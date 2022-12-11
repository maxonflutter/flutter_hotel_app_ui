import 'package:flutter/material.dart';
import 'package:flutter_hotel_app_ui/utilities/constants.dart';
import '../models/hotel_model.dart';
import '../gen/assets.gen.dart';
import '../gen/colors.gen.dart';
import '../screens/hotel_screen.dart';
import 'custom_rating.dart';
import '../utilities/app_text.dart';

class HotelCard extends StatelessWidget {
  const HotelCard({
    Key? key,
    required this.hotel,
  }) : super(key: key);

  final HotelModel hotel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HotelDetailScreen(hotel: hotel),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          children: [
            Flexible(
              flex: 1,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  bottomLeft: Radius.circular(20.0),
                ),
                child: Image.asset(
                  hotel.thumbnailPath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.large(
                      hotel.title,
                      fontSize: 18,
                      textAlign: TextAlign.left,
                      maxLine: 2,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Assets.icon.location.svg(
                          color: ColorName.darkGrey,
                          height: 15,
                        ),
                        const SizedBox(width: 8),
                        AppText.small(hotel.location),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: CustomRating(ratingScore: hotel.ratingScore),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          AppTextSpan.large(hotel.price.moneyFormat()),
                          AppTextSpan.medium(' /night'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// class PricePerNightTextWidget extends StatelessWidget {
//   final double price;
//   const PricePerNightTextWidget(this.price, {Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return RichText(
//       text: TextSpan(
//         children: [
//           AppTextSpan.large(price.moneyFormat()),
//           AppTextSpan.medium(' /night'),
//         ],
//       ),
//     );
//   }
// }
