import 'package:equatable/equatable.dart';

abstract class FavoriteState extends Equatable {
  @override
  List<Object> get props => [];
}

class FavoriteLoading extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final Set<String> favorites;
  FavoriteLoaded(this.favorites);
  @override
  List<Object> get props => [favorites];
}

class FavoriteError extends FavoriteState {
  final String message;
  FavoriteError(this.message);
  @override
  List<Object> get props => [message];
}
