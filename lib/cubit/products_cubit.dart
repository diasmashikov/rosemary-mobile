import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/src/widgets/editable_text.dart';
import 'package:meta/meta.dart';
import 'package:rosemary/cubit/product_detail_cubit.dart';
import 'package:rosemary/data/models/category.dart';
import 'package:rosemary/data/models/modelCharacteristics.dart';
import 'package:rosemary/data/models/product.dart';
import 'package:rosemary/data/models/user.dart';
import 'package:rosemary/data/repository.dart';

part 'products_state.dart';

class ProductsCubit extends Cubit<ProductsState> {
  final Repository repository;

  ProductsCubit({required this.repository}) : super(ProductsInitial());

  void fetchProducts(categoryId) {
    repository.getProducts(categoryId).then((products) {
      emit(ProductsLoaded(products: products));
    });
  }

  Future<void> postFavorite(
      {String? token, User? user, required List<String> products}) async {
    repository.postFavorite(token: token, user: user, products: products);
  }

  Future<void> postProduct(
      {String? token,
      required String categoryId,
      required String name,
      required String price,
      required String color,
      required String sizes,
      required String description,
      required String material,
      required String countryProducer,
      required String style,
      required String countInStock,
      required ModelCharacteristics modelCharacteristics,
      File? image,
      required List<File> images, required  double discount, required  bool recommended, required  bool newArrival,required  String fashionCollection}) async {
    repository.postProduct(
        token: token,
        categoryId: categoryId,
        name: name,
        image: image,
        images: images,
        price: price,
        color: color,
        sizes: sizes,
        description: description,
        material: material,

        discount: discount,
                            recommended:recommended,
                            newArrival: newArrival,
                            fashionCollection:fashionCollection,

        countryProducer: countryProducer,
        style: style,
        modelCharacteristics: modelCharacteristics,
        countInStock: countInStock);
  }

  Future<void> deleteProduct(
      {required String id, required String token}) async {
    repository.deleteProduct(id, token);
  }

  Future<void> updateProduct(
      {String? token,
      required String categoryId,
      required String name,
      File? image,
      required String price,
      required String color,
      required String sizes,
      required String description,
      required String material,
      required String countryProducer,
      required String style,
      required ModelCharacteristics modelCharacteristics,
      required String countInStock,
      required String id}) async {
    repository.putProduct(
        token: token,
        categoryId: categoryId,
        name: name,
        image: image,
        price: price,
        color: color,
        sizes: sizes,
        description: description,
        material: material,
        countryProducer: countryProducer,
        style: style,
        modelCharacteristics: modelCharacteristics,
        countInStock: countInStock,
        id: id);
  }
}
