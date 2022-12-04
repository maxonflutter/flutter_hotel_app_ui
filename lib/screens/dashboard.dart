import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../gen/assets.gen.dart';
import '../gen/colors.gen.dart';
import '../gen/fonts.gen.dart';
import 'home_screen.dart';
import 'map_screen.dart';

class Dashboard extends HookWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tabController = useTabController(initialLength: 4);
    useListenable(tabController);

    return Scaffold(
      backgroundColor: ColorName.blue,
      bottomNavigationBar: _BottomNavBar(tabController: tabController),
      body: SafeArea(
        child: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: tabController,
          children: const [
            HomeScreen(),
            MapScreen(),
            Center(child: Text('Booking')),
            Center(child: Text('Profile')),
          ],
        ),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final TabController tabController;
  const _BottomNavBar({required this.tabController, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      color: Colors.white,
      padding: const EdgeInsets.only(
        top: 10.0,
        bottom: 20.0,
        left: 20.0,
        right: 20.0,
      ),
      child: TabBar(
        controller: tabController,
        indicator: const BoxDecoration(),
        labelColor: ColorName.primaryColor,
        unselectedLabelColor: ColorName.lightGrey,
        onTap: (index) {
          // Disable tab index 2 and 3
          tabController.index = index > 1 ? tabController.previousIndex : index;
        },
        tabs: [
          _TabButton(
            iconPath: Assets.icon.home.path,
            text: 'Home',
            isSelected: tabController.index == 0,
          ),
          _TabButton(
            iconPath: Assets.icon.map.path,
            text: 'Map',
            isSelected: tabController.index == 1,
          ),
          _TabButton(
            iconPath: Assets.icon.booking.path,
            text: 'Booking',
          ),
          _TabButton(
            iconPath: Assets.icon.profile.path,
            text: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    Key? key,
    required this.iconPath,
    required this.text,
    this.isSelected = false,
  }) : super(key: key);

  final String iconPath;
  final String text;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? ColorName.primaryColor : ColorName.lightGrey;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(iconPath, color: color),
        const SizedBox(height: 5),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontFamily: FontFamily.workSans,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}
