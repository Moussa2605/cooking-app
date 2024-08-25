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
    final size = MediaQuery.of(context).size;

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
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(firstImage),
                    radius: 25,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.search, color: Colors.black, size: 30),
                      onPressed: () {
                      },
                    ),
                  ),
                ],
              ),
              Text(
                homePageTitle,
                style: titleStyle,
              ),
              Obx(() {
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
              }),
              SizedBox(height: 30),
              Obx(() {
                if (mealController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                } else if (randomMeals.isNotEmpty) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: randomMeals.map((meal) {
                        return buildFoodCard(
                          size,
                          meal.strMeal,
                          'Voir la recette du ${meal.strMeal.length > 15 ? meal.strMeal.substring(0, 15) + "..." : meal.strMeal}!',
                          meal.strMealThumb,
                        );
                      }).toList(),
                    ),
                  );
                } else {
                  return Container();
                }
              }),
              SizedBox(height: 20),

              buildBottomNavigationBar(size),
            ],
          ),
        ),
      ),
    );
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
            color: isSelected ? Colors.white:Colors.black,
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
                      SizedBox(height: 50),
                      Text(
                        title.length > 10 ? title.substring(0, 10) : title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),
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
          top: -15,
          left: (size.width * 0.8) / 2 - 30,
          child: CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(imagePath),
            backgroundColor: Colors.transparent,
          ),
        ),
      ],
    );
  }

}
