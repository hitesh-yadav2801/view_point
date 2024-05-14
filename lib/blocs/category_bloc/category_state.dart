part of 'category_bloc.dart';

@immutable
sealed class CategoryState {}

final class CategoryInitialState extends CategoryState {}

final class CategoryLoadingState extends CategoryState {}

final class CategoryLoadedSuccessState extends CategoryState {
  final List<CategoryModel> categories;

  CategoryLoadedSuccessState(this.categories);
}

final class CategoryAddSuccessState extends CategoryState {}

final class CategoryErrorState extends CategoryState {
  final String message;

  CategoryErrorState(this.message);
}
