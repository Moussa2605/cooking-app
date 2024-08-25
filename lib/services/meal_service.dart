import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/meal.dart';
import '../utils/constants/configs.dart';

class MealService extends GetxService {

  Future<List<Meal>> fetchMealsByCategory(String category) async {
    try {
      final response = await http.get(Uri.parse("${AppConfig.mealsByCategoryUrl}?c=$category"));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> mealsJson = data['meals'];

        List<Meal> meals = mealsJson.map((json) => Meal.fromJson(json)).toList();
        return meals;
      } else {
        throw Exception('Failed to load meals');
      }
    } catch (e) {
      throw Exception('Failed to fetch meals: $e');
    }
  }
}
