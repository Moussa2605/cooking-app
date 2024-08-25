import 'package:cookbymas/utils/constants/assets.dart';
import 'package:cookbymas/utils/constants/colors.dart';
import 'package:cookbymas/utils/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/onboarding_controller.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingController controller = Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double padding = size.width * 0.05;

    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.onPageChanged,
            children: [
              buildPage(
                imagePath: firstImage,
                title: onboardingPage1,
                size: size,
              ),
              buildPage(
                imagePath: fourthImage,
                title:onboardingPage2,
                size: size,
              ),
              buildPage(
                imagePath: thirdImage,
                title: onboardingPage3,
                size: size,
              ),
            ],
          ),
          Positioned(
            bottom: padding,
            left: 0,
            right: 0,
            child: Center(
              child: Container(

                width: size.width * 0.8,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(size.width),
                  ),
                  elevation: 0,

                  color: Colors.white.withOpacity(0.15),
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(top: padding, bottom: padding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: controller.previousPage,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(size.width * 0.07),
                              child: Icon(Icons.arrow_back, size: size.width * 0.07),
                            ),
                          ),
                        ),
                        Obx(() => Row(
                          children: List.generate(
                            3,
                                (index) => Container(
                              margin: EdgeInsets.symmetric(horizontal: padding * 0.2),
                              width: size.width * 0.02,
                              height: size.width * 0.02,
                              decoration: BoxDecoration(
                                color: controller.currentIndex.value == index
                                    ? Colors.white
                                    : Colors.grey,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        )),
                        GestureDetector(
                          onTap: () {
                            if (controller.currentIndex.value == 2) {
                              Get.offNamed('/home');
                            } else {
                              controller.nextPage();
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(size.width * 0.07),
                              child: Icon(Icons.arrow_forward, color: Colors.white, size: size.width * 0.07),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPage({required String imagePath, required String title, required Size size}) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(size.width * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: size.width * 0.3),
            Text(
              title,
              style: TextStyle(
                fontSize: size.width * 0.1,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
