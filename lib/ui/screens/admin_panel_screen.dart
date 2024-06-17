import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:view_point/blocs/category_bloc/category_bloc.dart';
import 'package:view_point/blocs/login_bloc/login_bloc.dart';
import 'package:view_point/core/constants/app_padding.dart';
import 'package:view_point/data/models/category_model.dart';
import 'package:view_point/ui/common_widgets/custom_button.dart';
import 'package:view_point/ui/common_widgets/custom_textfield.dart';
import 'package:view_point/ui/screens/onboarding_screen.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  _AdminPanelScreenState createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _categoryNameController = TextEditingController();
  final List<VideoInput> _videoInputs = [VideoInput(onRemove: null)];

  @override
  void dispose() {
    _categoryNameController.dispose();
    for (var videoInput in _videoInputs) {
      videoInput.dispose();
    }
    super.dispose();
  }

  void _removeVideoInput(VideoInput videoInput) {
    setState(() {
      _videoInputs.remove(videoInput);
    });
  }
  bool _validateInputs() {
    if (_categoryNameController.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Category Name cannot be empty')));
      return false;
    }

    for (var videoInput in _videoInputs) {
      if (videoInput.selectedFile == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Please select a video file for each video input')));
        return false;
      }
      for (var controller in videoInput.questionControllers) {
        if (controller.text.isEmpty) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Questions cannot be empty')));
          return false;
        }
      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Admin Panel'),
        actions: [
          BlocConsumer<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is LogoutSuccessStateLogin) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const OnboardingScreen()),
                      (route) => false,
                );
              } else if (state is LoginScreenErrorState) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
            builder: (context, state) {
              return IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  context.read<LoginBloc>().add(LogoutEventLogin());
                },
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<CategoryBloc, CategoryState>(
        listener: (context, state) {
          if (state is CategoryAddSuccessState) {
            _categoryNameController.clear();
            setState(() {
              _videoInputs.clear();
              _videoInputs.add(VideoInput(onRemove: null));
            });
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text('Category added successfully!')));
          } else if (state is CategoryErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is CategoryLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          return SafeArea(
            child: Padding(
              padding: AppPadding.mainPadding,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CustomTextField(
                        controller: _categoryNameController,
                        hintText: 'Category Name',
                      ),
                      const SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: _videoInputs.length,
                        itemBuilder: (context, index) {
                          return _videoInputs[index];
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            _videoInputs.add(VideoInput(onRemove: _removeVideoInput));
                          });
                        },
                      ),
                      const SizedBox(height: 40),
                      CustomButton(
                        title: 'Submit',
                        onPressed: () {
                          if (_formKey.currentState!.validate() && _validateInputs() ) {
                            List<Video> videos = _videoInputs.map((videoInput) {
                              return Video(
                                videoUrl: '', // Empty string for videoUrl
                                questions: videoInput.questionControllers.map((controller) => controller.text).toList(),
                              );
                            }).toList();

                            List<File> videoFiles = _videoInputs.map((videoInput) {
                              return videoInput.selectedFile!;
                            }).toList();

                            CategoryModel categoryModel = CategoryModel(
                              categoryName: _categoryNameController.text,
                              videos: videos,
                            );

                            context.read<CategoryBloc>().add(CategoryAddEvent(
                              categoryModel: categoryModel,
                              files: videoFiles,
                            ));
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class VideoInput extends StatefulWidget {
  final List<TextEditingController> questionControllers = [TextEditingController()];
  final Function(VideoInput)? onRemove;

  File? selectedFile;

  VideoInput({super.key, this.onRemove});

  @override
  _VideoInputState createState() => _VideoInputState();

  void dispose() {
    for (var controller in questionControllers) {
      controller.dispose();
    }
  }
}

class _VideoInputState extends State<VideoInput> {
  Future<void> _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.video);

    if (result != null) {
      setState(() {
        widget.selectedFile = File(result.files.single.path!);
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('No file selected')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.onRemove != null)
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.remove_circle),
              onPressed: () {
                widget.onRemove!(widget);
              },
            ),
          ),
        if (widget.selectedFile != null)
          Container(
            color: Colors.blue.shade50,
            child: Text(widget.selectedFile!.path),
          ),
        CustomButton(
          onPressed: _selectFile,
          title: 'Select Video File',
          color: Colors.transparent,
          textColor: Colors.black,
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          itemCount: widget.questionControllers.length,
          itemBuilder: (context, index) {
            return Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: CustomTextField(
                      controller: widget.questionControllers[index],
                      hintText: 'Question ${index + 1}',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      widget.questionControllers.removeAt(index);
                    });
                  },
                ),
              ],
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            setState(() {
              widget.questionControllers.add(TextEditingController());
            });
          },
        ),
        const Divider(thickness: 1),
      ],
    );
  }
}
