import 'package:get/get.dart';
import '../models/categorie.dart';
import '../services/categorie_service.dart';
import '../utils/constants/translation.dart';

class CategorieController extends GetxController {
  var categories = <Categorie>[].obs;
  var isLoading = true.obs;

  final CategorieService categorieService;

  CategorieController({required this.categorieService});

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  String translateCategory(String categoryName) {
    return categoryTranslations[categoryName] ?? categoryName;
  }

  String getEnglishCategory(String translatedCategory) {
    return categoryTranslations.entries
        .firstWhere((entry) => entry.value == translatedCategory, orElse: () => MapEntry(translatedCategory, translatedCategory))
        .key;
  }

  void fetchCategories() async {
    try {
      isLoading(true);
      var fetchedCategories = await categorieService.fetchCategories();
      if (fetchedCategories.isNotEmpty) {
        categories.assignAll(fetchedCategories.map((category) {
          category.strCategory = translateCategory(category.strCategory);
          return category;
        }).toList());
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
