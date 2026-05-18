import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/category_bloc.dart';
import '../../events/category_events.dart';
import '../../states/category_state.dart';
import '../../widgets/category_widgets.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_drawer.dart';
import '../notification_screen.dart';
import '../profile/profile_screen.dart';
import '../../utils/navigation_mixin.dart';
import 'create_category_screen.dart';
import 'update_category_screen.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> with DrawerNavigationMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(GetCategoryList());
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
        onItemTapped: onDrawerItemTapped,
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
            onTap: (category) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateCategoryScreen(
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
