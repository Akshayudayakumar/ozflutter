import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:ozone_erp/components/custom_app_bar.dart';
import 'package:ozone_erp/components/custom_menu.dart';
import 'package:ozone_erp/screens/dashboard/controller/dashboard_controller.dart';
import 'package:ozone_erp/widgets/pop/pop_blocker.dart';

import '../../../constants/constant.dart';
import '../widgets/bottom_bar_widget.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      builder: (DashBoardController controller) {
        return PopBlocker(
          child: Scaffold(
            appBar: customAppBar(title: 'Dashboard'),
            drawer: CustomMenu(),
            body: Stack(
              alignment: Alignment.center,
              children: [
                PageTransitionSwitcher(
                  reverse: controller.isLower,
                  transitionBuilder: (child, animation, secondaryAnimation) {
                    return SharedAxisTransition(
                      animation: animation,
                      secondaryAnimation: secondaryAnimation,
                      transitionType: SharedAxisTransitionType.horizontal,
                      child: child,
                    );
                  },
                  child: controller.screens[controller.screenIndex],
                ),
                Positioned(
                    bottom: 0,
                    child: BottomBarWidget(
                      items: [
                        barItem(
                            icon: AssetConstant.salesNonAnimated,
                            isSelected: controller.screenIndex == 0,
                            activeIcon: AssetConstant.salesAnimated,
                            index: 0),
                        barItem(
                            icon: AssetConstant.cartNonAnimated,
                            isSelected: controller.screenIndex == 1,
                            activeIcon: AssetConstant.cartAnimated,
                            index: 1),
                        barItem(
                            icon: AssetConstant.analyticsNonAnimated,
                            isSelected: controller.screenIndex == 2,
                            activeIcon: AssetConstant.analyticsAnimated,
                            index: 2),
                        // barItem(
                        //     icon: CupertinoIcons.building_2_fill,
                        //     isSelected: controller.screenIndex == 3,
                        //     activeIcon: CupertinoIcons.building_2_fill,
                        //     index: 3),
                      ],
                    )),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget barItem(
      {required String icon,
      required String activeIcon,
      required bool isSelected,
      required int index}) {
    return InkWell(
      onTap: () {
        final controller = Get.find<DashBoardController>();
        controller.isLower = controller.screenIndex > index;
        controller.updateScreenIndex(index);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedSwitcher(
            duration: 300.ms,
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: child,
            ),
            child: isSelected
                ? Image.asset(
                    key: const ValueKey('1'),
                    activeIcon,
                    // color: Colors.black,
                    width: SizeConstant.screenWidth * .12,
                    height: SizeConstant.screenWidth * .12,
                  )
                : Image.asset(
                    key: const ValueKey('2'),
                    icon,
                    color: Colors.black38,
                    width: SizeConstant.screenWidth * .08,
                    height: SizeConstant.screenWidth * .08,
                  ),
          ),
        ],
      ),
    );
  }
}
