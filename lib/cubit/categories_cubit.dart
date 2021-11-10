import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rosemary/data/models/category.dart';
import 'package:rosemary/data/repository.dart';

part 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  final Repository repository;

  CategoriesCubit({required this.repository}) : super(CategoriesInitial());

  void fetchCategories() {
    repository.getCategories().then((categories) {
      emit(CategoriesLoaded(categories: categories));
    });
  }

  Future<void> postCategory(
      {String? token, required String categoryName, File? image}) async {
    repository.postCategory(
        token: token, categoryName: categoryName, image: image);
  }

  Future<void> deleteCategory(
      {required String id, required String token}) async {
    repository.deleteCategory(id, token);
  }

  Future<void> updateCategory(
      String id, String token, String categoryName, File? imageFile) async {
    repository.putCategory(id, token, categoryName, imageFile);
  }
}
