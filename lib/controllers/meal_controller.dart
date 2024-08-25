import 'package:get/get.dart';
import '../models/meal.dart';
import '../services/meal_service.dart';
import '../controllers/categorie_controller.dart';

class MealController extends GetxController {
  var meals = <Meal>[].obs;
  var isLoading = true.obs;

  final MealService mealService;
  final CategorieController categorieController;

  MealController({required this.mealService, required this.categorieController});

  void fetchMealsByCategory(String category) async {
    try {
      isLoading(true);
      String englishCategory = categorieController.getEnglishCategory(category);
      var fetchedMeals = await mealService.fetchMealsByCategory(englishCategory);
      if (fetchedMeals.isNotEmpty) {
        meals.assignAll(fetchedMeals);
      } else {
        meals.clear();
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
