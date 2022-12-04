import 'package:flutter/material.dart';
import '../gen/assets.gen.dart';
import '../utilities/app_text.dart';

class FacilitiesSection extends StatelessWidget {
  const FacilitiesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.medium('Facilities', fontWeight: FontWeight.bold),
        const SizedBox(height: 10),
        Table(
          columnWidths: const {
            0: FlexColumnWidth(),
            1: FlexColumnWidth(),
          },
          children: [
            TableRow(children: [
              _IconLabel(
                icon: Assets.icon.amenities.hotel.svg(),
                label: '4-Star Hotel',
              ),
              _IconLabel(
                icon: Assets.icon.amenities.roomService.svg(),
                label: 'Room Service',
              ),
            ]),
            TableRow(
              children: [
                _IconLabel(
                  icon: Assets.icon.amenities.wifi.svg(),
                  label: 'Free Wi-Fi',
                ),
                _IconLabel(
                  icon: Assets.icon.amenities.ac.svg(),
                  label: 'Air Conditioner',
                ),
              ],
            ),
            TableRow(
              children: [
                _IconLabel(
                  icon: Assets.icon.amenities.transport.svg(),
                  label: 'Airport Pickup',
                ),
                _IconLabel(
                  icon: Assets.icon.amenities.swimmingPool.svg(),
                  label: 'Swimming Pool',
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}

class _IconLabel extends StatelessWidget {
  final Widget icon;
  final String label;
  const _IconLabel({required this.icon, required this.label, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(width: 6),
          AppText.medium(label, fontWeight: FontWeight.normal),
        ],
      ),
    );
  }
}
