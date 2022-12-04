import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/hotel_model.dart';
import '../gen/assets.gen.dart';
import '../gen/colors.gen.dart';
import '../repositories/hotel_repository.dart';
import '../utilities/constants.dart';
import '../widgets/custom_button.dart';
import '../widgets/app_icon_container_widget.dart';
import '../widgets/hotel_card.dart';
import '../widgets/custom_text_field.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          height: double.infinity,
          margin: EdgeInsets.only(top: size.height * 0.25),
          color: Colors.white,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: const [
              _HeaderSection(),
              _SearchCard(),
              SizedBox(height: 20),
              Flexible(child: _NearbyHotelSection()),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeaderSection extends StatelessWidget {
  const _HeaderSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: Assets.image.photo.provider(),
            ),
            AppIconContainer(
              Assets.icon.notification.svg(height: 25),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Welcome back 👋',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}

class _SearchCard extends HookWidget {
  const _SearchCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locationTextController = useTextEditingController();
    final dateFromTextController = useTextEditingController();
    final dateToTextController = useTextEditingController();
    locationTextController.text = 'Yogyakarta';
    dateFromTextController.text =
        dateToTextController.text = dmyDateFormat.format(DateTime.now());

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: ColorName.lightGrey.withAlpha(50),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Assets.icon.location.svg(color: ColorName.blue),
              const SizedBox(width: 16),
              CustomTextField(
                label: 'Where',
                controller: locationTextController,
              ),
            ],
          ),
          Row(
            children: [
              Assets.icon.calendar.svg(color: ColorName.blue),
              const SizedBox(width: 16),
              CustomTextField(
                label: 'From',
                controller: dateFromTextController,
              ),
              CustomTextField(
                label: 'to',
                controller: dateToTextController,
              ),
            ],
          ),
          const SizedBox(height: 16),
          CustomButton(
            buttonText: 'Search',
            onPressed: () {},
          )
        ],
      ),
    );
  }
}

class _NearbyHotelSection extends ConsumerWidget {
  const _NearbyHotelSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hotelRepo = ref.watch(hotelRepositoryProvider);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Nearby hotels',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Text(
              'See all',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: ColorName.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Flexible(
          child: FutureBuilder<List<Hotel>>(
            future: hotelRepo.getHotelList(),
            builder: (context, snapshot) {
              final listHotel = snapshot.data;
              if (listHotel == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(0),
                shrinkWrap: true,
                itemCount: listHotel.length,
                itemBuilder: (context, index) {
                  final hotel = listHotel[index];
                  return HotelCard(hotel: hotel);
                },
              );
            },
          ),
        )
      ],
    );
  }
}
