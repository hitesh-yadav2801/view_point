part of 'category_bloc.dart';

@immutable
sealed class CategoryEvent {}

final class CategoryInitialEvent extends CategoryEvent {}

final class CategoryLoadEvent extends CategoryEvent {}