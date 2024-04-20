import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:view_point/blocs/category_bloc/category_bloc.dart';
import 'package:view_point/core/constants/my_colors.dart';
import 'package:view_point/data/models/category_model.dart';
import 'package:view_point/ui/common_widgets/custom_button.dart';
import 'package:view_point/ui/screens/category_display_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  CategoryModel? _selectedCategory;

  @override
  void initState() {
    context.read<CategoryBloc>().add(CategoryLoadEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('Categories'),
      ),
      body: BlocConsumer<CategoryBloc, CategoryState>(
        listener: (context, state) {
          if (state is CategoryErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is CategoryLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is CategoryLoadedSuccessState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Choose a Category:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: state.categories.length,
                        itemBuilder: (context, index) {
                          final category = state.categories[index];
                          return RadioListTile<CategoryModel>(
                            title: Text(category.categoryName),
                            value: category,
                            groupValue: _selectedCategory,
                            onChanged: (value) {
                              setState(() {
                                _selectedCategory = value;
                              });
                            },
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      title: 'Next',
                      onPressed: _selectedCategory != null
                          ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryDisplayScreen(
                              categoryModel: _selectedCategory!,
                            ),
                          ),
                        );
                      }
                          : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please select a category'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
