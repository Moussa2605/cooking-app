import 'dart:ui';
import 'dart:math';

import 'package:cookbymas/utils/constants/assets.dart';
import 'package:cookbymas/utils/constants/colors.dart';
import 'package:cookbymas/utils/constants/text-styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/categorie_controller.dart';
import '../controllers/meal_controller.dart';
import '../models/meal.dart';
import '../services/categorie_service.dart';
import '../services/meal_service.dart';
import '../utils/constants/strings.dart';
import '../utils/constants/translation.dart';
import '../widgets/bottomNavBar.dart';

class Home extends StatelessWidget {
  final CategorieController categorieController = Get.put(CategorieController(categorieService: CategorieService()));
  final MealController mealController = Get.put(MealController(mealService: MealService(), categorieController: Get.find()));
  final RxString selectedCategory = ''.obs;
  final Rxn<Meal> randomMeal = Rxn<Meal>();
  final RxList<Meal> randomMeals = <Meal>[].obs;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = MediaQuery.of(context).size;
        final double padding = size.width * 0.05;

        return Scaffold(
          body: Container(
            height: size.height,
            width: size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(fifthImage),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: padding, vertical: padding * 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildHeader(context),
                  buildTitle(),
                  buildCategoryFilter(context),
                  SizedBox(height: padding),
                  buildMealsDisplay(size),
                  SizedBox(height: padding),
                  buildBottomNavigationBar(size),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildHeader(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(
            "https://img.freepik.com/photos-gratuite/portrait-homme-ghaneen_53876-148200.jpg?t=st=1724620184~exp=1724623784~hmac=930ab4db9a8f98fc385d136c6c9dc6c92338e4faa4b9f343cb21d5d56ba50a8d&w=1380",
          ),
          radius: size.width * 0.06,
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
          ),
          child: IconButton(
            icon: Icon(Icons.search, color: Colors.black, size: size.width * 0.07),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget buildTitle() {
    return Text(
      homePageTitle,
      style: titleStyle,
    );
  }

  Widget buildCategoryFilter(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Obx(() {
      if (categorieController.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      } else {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categorieController.categories.map((category) {
              return buildFilterButton(
                categoryTranslations[category.strCategory] ?? category.strCategory,
                englishCategory: category.strCategory,
                isSelected: selectedCategory.value == category.strCategory,
              );
            }).toList(),
          ),
        );
      }
    });
  }

  Widget buildMealsDisplay(Size size) {
    return Obx(() {
      if (mealController.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      } else if (randomMeals.isNotEmpty) {
        return SizedBox(
          height: size.height * 0.3,
          child: PageView.builder(
            controller: PageController(viewportFraction: 0.8),
            itemCount: randomMeals.length,
            itemBuilder: (context, index) {
              final meal = randomMeals[index];
              return buildFoodCard(
                size,
                meal.strMeal,
                'Voir la recette du ${meal.strMeal.length > 15 ? meal.strMeal.substring(0, 15) + "..." : meal.strMeal}!',
                meal.strMealThumb,
              );
            },
          ),
        );
      } else {
        return Container();
      }
    });
  }

  Widget buildFilterButton(String text, {bool isSelected = false, required String englishCategory}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        onPressed: () {
          selectedCategory.value = englishCategory;
          fetchRandomMeal(englishCategory);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? primaryColor : Colors.white.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  void fetchRandomMeal(String category) {
    mealController.fetchMealsByCategory(category);

    ever(mealController.meals, (_) {
      if (mealController.meals.length >= 3) {
        final randomIndexes = <int>{};

        while (randomIndexes.length < 3) {
          final randomIndex = Random().nextInt(mealController.meals.length);
          randomIndexes.add(randomIndex);
        }

        randomMeals.assignAll(randomIndexes.map((index) => mealController.meals[index]).toList());
      } else {
        randomMeals.clear();
      }
    });
  }

  Widget buildFoodCard(Size size, String title, String description, String imagePath) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size.width * 0.8,
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withOpacity(0.3),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: size.height * 0.05),
                      Text(
                        title.length > 10 ? title.substring(0, 10) : title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size.width * 0.06,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: size.height * 0.01),
                      Text(
                        description,
                        style: descriptionStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: -size.height * 0.03,
          left: (size.width * 0.8) / 2 - 30,
          child: CircleAvatar(
            radius: size.width * 0.1,
            backgroundImage: NetworkImage(imagePath),
            backgroundColor: Colors.transparent,
          ),
        ),
      ],
    );
  }
}
