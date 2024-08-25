import 'package:cookbymas/views/onboarding.dart';
import 'package:get/get.dart';

import '../views/Home.dart';




class AppRoutes {
  static const HOME = '/home';
  static const ONBOARDING = '/onboarding';


  static final List<GetPage> routes = [
    GetPage(
      name: HOME,
      page: () => Home(),
    ),
    GetPage(name: ONBOARDING, page: () => OnboardingPage()),




  ];
}
