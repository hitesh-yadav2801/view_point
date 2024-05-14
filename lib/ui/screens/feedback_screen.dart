import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:view_point/blocs/feedback_bloc/feedback_bloc.dart';
import 'package:view_point/core/constants/app_padding.dart';
import 'package:view_point/core/constants/my_colors.dart';
import 'package:view_point/data/models/category_model.dart';
import 'package:view_point/data/models/response_model.dart';
import 'package:view_point/ui/common_widgets/custom_button.dart';
import 'package:view_point/ui/screens/category_screen.dart';
import 'package:view_point/ui/screens/instructions_screen.dart';

class FeedbackScreen extends StatefulWidget {
  final CategoryModel categoryModel;

  const FeedbackScreen({super.key, required this.categoryModel});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  late List<String> ratings;

  @override
  void initState() {
    super.initState();
    ratings = List<String>.filled(widget.categoryModel.questions.length, '0');
  }

  void _submitFeedback() async {
    final allQuestionsAnswered = ratings.every((rating) => rating != '0');
    if (!allQuestionsAnswered) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please answer every question.'),
        ),
      );
      return;
    }

    final response = ResponseModel(
      questions: widget.categoryModel.questions,
      answers: ratings,
      documentReference: widget.categoryModel.documentReference!,
    );
    context.read<FeedbackBloc>().add(
      FeedbackSubmitEvent(responseModel: response),
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
                        MaterialPageRoute(builder: (context) => const InstructionsScreen()),
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
            title: Text('${widget.categoryModel.categoryName} Feedback'),
          ),
          body: SafeArea(
            child: Padding(
              padding: AppPadding.mainPadding,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.categoryModel.questions.length,
                      itemBuilder: (context, index) {
                        final question = widget.categoryModel.questions[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              question,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                for (int i = 1; i <= 5; i++)
                                  Row(
                                    children: [
                                      Text(
                                        '$i', // Display the number
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      Radio<String>(
                                        value: i.toString(),
                                        groupValue: ratings[index],
                                        onChanged: (String? value) {
                                          setState(() {
                                            ratings[index] = value!;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                            const Divider(),
                          ],
                        );
                      },
                    ),
                  ),
                  CustomButton(
                    title: 'Submit Feedback',
                    onPressed: _submitFeedback,
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
