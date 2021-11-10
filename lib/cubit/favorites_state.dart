part of 'favorites_cubit.dart';

@immutable
abstract class FavoritesState {}

class FavoritesInitial extends FavoritesState {}
class FavoritesLoaded extends FavoritesState {
  final Favorite? favorites;

  FavoritesLoaded({required this.favorites});
}
