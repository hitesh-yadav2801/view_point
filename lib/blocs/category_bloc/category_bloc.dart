import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:view_point/data/models/category_model.dart';
import 'package:view_point/data/services/firebase_services.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(CategoryInitialState()) {
    on<CategoryEvent>((event, emit) => emit(CategoryLoadingState()));
    on<CategoryLoadEvent>(_onCategoryLoadEvent);
    on<CategoryAddEvent>(_onCategoryAddEvent);
  }

  void _onCategoryLoadEvent(CategoryLoadEvent event, Emitter<CategoryState> emit) async {

    try {
      final response = await FirebaseServices.getCategories();
      emit(CategoryLoadedSuccessState(response));
    } catch (e) {
      emit(CategoryErrorState(e.toString()));
    }
  }

  void _onCategoryAddEvent(CategoryAddEvent event, Emitter<CategoryState> emit) async {
    try {
      await FirebaseServices.postCategories(categoryModel: event.categoryModel, files: event.files);
      emit(CategoryAddSuccessState());
    } catch (e) {
      emit(CategoryErrorState(e.toString()));
    }
  }
}
