import 'package:flutter/material.dart';
import 'package:video_360/video_360.dart';
import 'package:view_point/data/models/category_model.dart';
import 'package:view_point/data/models/response_model.dart';
import 'package:view_point/ui/common_widgets/custom_button.dart';
import 'package:view_point/ui/screens/feedback_screen.dart';

class NavigatorButton extends StatelessWidget {
  final CategoryModel categoryModel;

  const NavigatorButton({super.key, required this.categoryModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: CustomButton(
            onPressed: () {
              final responseModel = ResponseModel(
                categoryName: categoryModel.categoryName,
                videoResponses: [],
                documentReference: categoryModel.documentReference!,
              );

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => View360(
                    categoryModel: categoryModel,
                    videoIndex: 0,
                    responseModel: responseModel,
                  ),
                ),
              );
            },
            title: '360° View',
          ),
        ),
      ),
    );
  }
}

class View360 extends StatefulWidget {
  final CategoryModel categoryModel;
  final int videoIndex;
  final ResponseModel responseModel;

  const View360({
    super.key,
    required this.categoryModel,
    required this.videoIndex,
    required this.responseModel,
  });

  @override
  State<View360> createState() => _View360State();
}

class _View360State extends State<View360> {
  late Video360Controller controller;
  late String videoUrl;
  late List<String> ratings;

  @override
  void initState() {
    videoUrl = widget.categoryModel.videos[widget.videoIndex].videoUrl;
    ratings = List<String>.filled(
        widget.categoryModel.videos[widget.videoIndex].questions.length, '0');
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _showFeedbackPopup(BuildContext context) {
    List<String> localRatings = List<String>.from(ratings);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Feedback for Video ${widget.videoIndex + 1}'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.categoryModel
                            .videos[widget.videoIndex].questions.length,
                        itemBuilder: (context, index) {
                          final question = widget.categoryModel
                              .videos[widget.videoIndex].questions[index];
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
                              Wrap(
                                alignment: WrapAlignment.start,
                                spacing: 4,
                                children: List.generate(5, (i) {
                                  return Column(
                                    children: [
                                      Text(
                                        '${i + 1}', // Display the number
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      Radio<String>(
                                        value: (i + 1).toString(),
                                        groupValue: localRatings[index],
                                        onChanged: (String? value) {
                                          setState(() {
                                            localRatings[index] = value!;
                                          });
                                        },
                                      ),
                                    ],
                                  );
                                }),
                              ),
                              const Divider(),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          actions: <Widget>[
            CustomButton(
              onPressed: () {
                setState(() {
                  ratings = localRatings;
                });
                final allQuestionsAnswered =
                    ratings.every((rating) => rating != '0');
                if (!allQuestionsAnswered) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please answer every question.'),
                    ),
                  );
                } else {
                  final videoResponse = VideoResponse(
                    questions:
                    widget.categoryModel.videos[widget.videoIndex].questions,
                    answers: ratings,
                  );

                  final updatedResponses = List<VideoResponse>.from(
                      widget.responseModel.videoResponses)
                    ..add(videoResponse);

                  final updatedResponseModel = widget.responseModel.copyWith(
                    videoResponses: updatedResponses,
                  );

                  Navigator.of(context).pop();
                  if (widget.videoIndex + 1 <
                      widget.categoryModel.videos.length) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => View360(
                          categoryModel: widget.categoryModel,
                          videoIndex: widget.videoIndex + 1,
                          responseModel: updatedResponseModel,
                        ),
                      ),
                    );
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            FeedbackScreen(responseModel: updatedResponseModel),
                      ),
                    );
                  }
                }
              },
              title: 'Next',
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Center(
            child: SizedBox(
              width: width,
              height: height,
              child: Video360View(
                onVideo360ViewCreated: _onVideo360ViewCreated,
                url: videoUrl,
                onPlayInfo: (Video360PlayInfo info) {
                  // if (mounted) {
                  //   setState(() {
                  //
                  //   });
                  // }
                },
              ),
            ),
          ),
          Positioned(
            right: 20,
            top: 20,
            child: MaterialButton(
              onPressed: () {
                _showFeedbackPopup(context);
              },
              color: Colors.grey[100],
              child: const Text('Give Feedback'),
            ),
          )
        ],
      ),
    );
  }

  void _onVideo360ViewCreated(Video360Controller controller) {
    this.controller = controller;
    controller.play();
  }
}
