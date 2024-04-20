import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:view_point/data/models/response_model.dart';
import 'package:view_point/data/services/firebase_services.dart';

part 'feedback_event.dart';

part 'feedback_state.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  FeedbackBloc() : super(FeedbackInitial()) {
    on<FeedbackEvent>((event, emit) => emit(FeedbackLoadingState()));

    on<FeedbackSubmitEvent>((event, emit) async {
      try {
        await FirebaseServices.postFeedback(response: event.responseModel);
        emit(FeedbackSubmittedSuccessState());
      } catch (e) {
        emit(FeedbackErrorState(e.toString()));
      }
    });
  }
}
