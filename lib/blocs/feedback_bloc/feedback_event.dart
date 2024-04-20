part of 'feedback_bloc.dart';

@immutable
sealed class FeedbackEvent {}

final class FeedbackSubmitEvent extends FeedbackEvent {
  final ResponseModel responseModel;

  FeedbackSubmitEvent({required this.responseModel});
}
