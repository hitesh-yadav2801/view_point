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
  final List<TextEditingController> _questionControllers = [
    TextEditingController()
  ];

  File? _selectedFile;

  Future<void> _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('No file selected')));
    }
  }

  @override
  void dispose() {
    _categoryNameController.dispose();
    for (var controller in _questionControllers) {
      controller.dispose();
    }
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .primaryColor,
        title: const Text('Admin Panel'),
        actions: [
          BlocConsumer<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is LogoutSuccessStateLogin) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => const OnboardingScreen()),
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
          if(state is CategoryAddSuccessState) {
            _categoryNameController.clear();
            for (var controller in _questionControllers) {
              controller.clear();
            }
            _questionControllers.removeRange(1, _questionControllers.length);
            setState(() {
              _selectedFile = null;
            });
          } else if(state is CategoryErrorState){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if(state is CategoryLoadingState) {
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
                        itemCount: _questionControllers.length,
                        itemBuilder: (context, index) {
                          return Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                                  child: CustomTextField(
                                    controller: _questionControllers[index],
                                    hintText: 'Question ${index + 1}',
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () {
                                  setState(() {
                                    _questionControllers.removeAt(index);
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
                            _questionControllers.add(TextEditingController());
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      if(_selectedFile != null)
                        Container(
                          color: Colors.blue.shade50,
                          child: Text(_selectedFile!.path),
                        ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: CustomButton(
                              onPressed: _selectFile,
                              title: 'Select File',
                              color: Colors.transparent,
                              textColor: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      CustomButton(
                        title: 'Submit',
                        onPressed: () {
                          if (_formKey.currentState!.validate() && _selectedFile != null) {
                            CategoryModel categoryModel = CategoryModel(
                              categoryName: _categoryNameController.text,
                              questions: _questionControllers.map((controller) => controller.text).toList(),
                              videoUrl: '',
                              //documentReference: FirebaseFirestore.instance.collection('categories').doc(),
                            );
                            context.read<CategoryBloc>().add(CategoryAddEvent(categoryModel: categoryModel, file: _selectedFile!));
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
