import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rosemary/data/models/promotion.dart';
import 'package:rosemary/data/repository.dart';

part 'promotions_state.dart';

class PromotionsCubit extends Cubit<PromotionsState> {
  final Repository repository;

  PromotionsCubit({required this.repository}) : super(PromotionsInitial());

  void fetchPromotions() {
    repository.getPromotions().then((promotions) {
      emit(PromotionsLoaded(promotions: promotions));
    });
  }

  Future<void> postPromotion(
      String firstLine,
      String secondLine,
      String thirdLine,
      String description,
      String activePeriod,
      String slogan,
      File? imageFile,
      String? token) async {
    print(firstLine);
    print("CUBIT");
    repository.postPromotion(firstLine, secondLine, thirdLine, description,
        activePeriod, slogan, imageFile, token);
  }

   deletePromotion(String id, String? token) {
    repository.deletePromotion(id, token);
  }
}
