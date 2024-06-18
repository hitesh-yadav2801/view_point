import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:view_point/blocs/feedback_bloc/feedback_bloc.dart';
import 'package:view_point/core/constants/app_padding.dart';
import 'package:view_point/core/constants/my_colors.dart';
import 'package:view_point/data/models/response_model.dart';
import 'package:view_point/ui/common_widgets/custom_button.dart';
import 'package:view_point/ui/screens/category_screen.dart';
import 'package:view_point/ui/screens/instructions_screen.dart';

class FeedbackScreen extends StatelessWidget {
  final ResponseModel responseModel;

  const FeedbackScreen({
    super.key,
    required this.responseModel,
  });

  void _submitFeedback(BuildContext context) {
    context.read<FeedbackBloc>().add(
      FeedbackSubmitEvent(responseModel: responseModel),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FeedbackBloc, FeedbackState>(
      listener: (context, state) {
        if (state is FeedbackErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }
        if (state is FeedbackSubmittedSuccessState) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                    SizedBox(width: 8),
                    Text('Response Submitted'),
                  ],
                ),
                content: const Text('Your response has been submitted.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const CategoryScreen()),
                            (route) => false,
                      );
                    },
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        }
      },
      builder: (context, state) {
        if (state is FeedbackLoadingState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Scaffold(
          backgroundColor: MyColors.backgroundColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: const Text('Feedback Summary'),
          ),
          body: SafeArea(
            child: Padding(
              padding: AppPadding.mainPadding,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: responseModel.videoResponses.length,
                      itemBuilder: (context, videoIndex) {
                        final videoResponse = responseModel.videoResponses[videoIndex];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Video ${videoIndex + 1}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                             const Divider(thickness: 1, color: Colors.black,),
                            ...List.generate(videoResponse.questions.length, (qIndex) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    videoResponse.questions[qIndex],
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Answer: ${videoResponse.answers[qIndex]}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const Divider(),
                                ],
                              );
                            }),
                            const SizedBox(height: 10),
                          ],
                        );
                      },
                    ),
                  ),
                  CustomButton(
                    title: 'Submit All Feedback',
                    onPressed: () => _submitFeedback(context),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
