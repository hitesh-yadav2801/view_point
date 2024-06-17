import 'package:flutter/material.dart';
import 'package:video_360/video_360.dart';
import 'package:view_point/data/models/category_model.dart';
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => View360(
                    categoryModel: categoryModel,
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

  const View360({super.key, required this.categoryModel});

  @override
  State<View360> createState() => _View360State();
}

class _View360State extends State<View360> {
  late Video360Controller controller;
  late String videoUrl;
  String durationText = '';
  String totalText = '';

  @override
  void initState() {
    //videoUrl = widget.categoryModel.videoUrl;
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //var statusBar = MediaQuery.of(context).padding.top;

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
                  setState(() {
                    durationText = info.duration.toString();
                    totalText = info.total.toString();
                  });
                },
              ),
            ),
          ),
          Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        controller.play();
                      },
                      color: Colors.grey[100],
                      child: const Text('Play'),
                    ),
                    const SizedBox(width: 10),
                    MaterialButton(
                      onPressed: () {
                        controller.stop();
                      },
                      color: Colors.grey[100],
                      child: const Text('Stop'),
                    ),
                    const SizedBox(width: 10),
                    MaterialButton(
                      onPressed: () {
                        controller.reset();
                      },
                      color: Colors.grey[100],
                      child: const Text('Reset'),
                    ),
                    const SizedBox(width: 10),
                    MaterialButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FeedbackScreen(
                                  categoryModel: widget.categoryModel)),
                        );
                      },
                      color: Colors.grey[100],
                      child: const Text('Next Page'),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  _onVideo360ViewCreated(Video360Controller controller) {
    this.controller = controller;
  }
}
