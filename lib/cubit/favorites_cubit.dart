import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:rosemary/data/models/favorite.dart';
import 'package:rosemary/data/models/user.dart';
import 'package:rosemary/data/repository.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final Repository repository;
  FavoritesCubit({required this.repository}) : super(FavoritesInitial());

  void fetchFavorites({String? token, User? user}) {
    repository.getFavorites(token: token, user: user).then((favorites) {
      emit(FavoritesLoaded(favorites: favorites));
    });
  }

  Future<void> deleteFavorite(
      {String? token, User? user, required String favoritedId, required String itemToDelete})  async {
    repository.deleteFavorite(
        token: token, user: user, favoritedId: favoritedId, itemToDelete: itemToDelete);
  }
}
