import 'package:cookbymas/utils/constants/configs.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/categorie.dart';

class CategorieService extends GetxService {

  Future<List<Categorie>> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse("${AppConfig.categoriesUrl}"));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List<dynamic> categoriesJson = data['categories'];

        List<Categorie> categories = categoriesJson.map((json) => Categorie.fromJson(json)).toList();
        return categories;
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      throw Exception('Failed to fetch categories: $e');
    }
  }
}
