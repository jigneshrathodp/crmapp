import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/category_bloc.dart';
import '../events/category_events.dart';
import '../states/category_state.dart';
import '../widgets/category_widgets.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';
import 'category_view_screen.dart';
import 'notification_screen.dart';
import 'profile_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}


class _CategoryScreenState extends State<CategoryScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(GetCategoryList());
  }

  void _onDrawerItemTapped(int index) {
    Navigator.pushReplacementNamed(context, _indexToRoute(index));
  }

  String _indexToRoute(int index) {
    switch (index) {
      case 0:
        return '/dashboard';
      case 1:
      case 2:
        return '/orders';
      case 3:
      case 4:
        return '/products';
      case 5:
      case 6:
        return '/categories';
      case 7:
      case 8:
        return '/advertisements';
      case 9:
        return '/notifications';
      case 10:
      case 11:
      case 12:
        return '/profile';
      default:
        return '/dashboard';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'Categories',
        onMenuPressed: () => _scaffoldKey.currentState?.openDrawer(),
        onNotificationPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const NotificationScreen()),
        ),
        onProfilePressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProfileScreen()),
        ),
      ),
      drawer: CustomDrawer(
        selectedIndex: 5,
        onItemTapped: _onDrawerItemTapped,
        headerTitle: 'CRM App',
        headerSubtitle: 'Categories',
      ),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<CategoryBloc>().add(GetCategoryList()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state.categoryList?.data == null ||
              state.categoryList!.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No categories found'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<CategoryBloc>().add(GetCategoryList()),
                    child: const Text('Refresh'),
                  ),
                ],
              ),
            );
          }

          return CategoryListWidget(
            categories: state.categoryList!.data!,
            onRefresh: () =>
                context.read<CategoryBloc>().add(GetCategoryList()),
            onDelete: (id) =>
                context.read<CategoryBloc>().add(DeleteCategory(id)),
            // Navigate to view/update screen on tap
            onTap: (category) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryViewScreen(
                    categoryId: category.id!,
                    categoryName: category.name,
                    categorySku: category.skubarCode,
                    categoryImage: category.image,
                  ),
                ),
              ).then((_) => context.read<CategoryBloc>().add(GetCategoryList()));
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateCategoryScreen(),
            ),
          ).then((_) => context.read<CategoryBloc>().add(GetCategoryList()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CreateCategoryScreen extends StatefulWidget {
  const CreateCategoryScreen({super.key});

  @override
  State<CreateCategoryScreen> createState() => _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends State<CreateCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _skuController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<CategoryBloc>().add(
        CreateCategory({
          'name': _nameController.text,
          'skubar_code': _skuController.text,
        }),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Category'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 1,
      ),
      body: BlocListener<CategoryBloc, CategoryState>(
        listener: (context, state) {
          if (!state.isLoading && state.error == null && state.createdCategory != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Category created successfully')),
            );
          }
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.error}')),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Name is required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _skuController,
                  decoration: const InputDecoration(
                    labelText: 'SKU Barcode',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'SKU is required' : null,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.save),
                  label: const Text('Create'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
