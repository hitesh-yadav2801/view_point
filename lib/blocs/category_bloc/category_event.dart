part of 'category_bloc.dart';

@immutable
sealed class CategoryEvent {}

final class CategoryInitialEvent extends CategoryEvent {}

final class CategoryLoadEvent extends CategoryEvent {}

final class CategoryAddEvent extends CategoryEvent {
  final CategoryModel categoryModel;
  final List<File> files;

  CategoryAddEvent({required this.categoryModel, required this.files});
}