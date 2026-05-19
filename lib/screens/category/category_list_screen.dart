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
import 'update_category_screen.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen>
    with DrawerNavigationMixin {
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
      backgroundColor: Colors.white,
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
      body: BlocConsumer<CategoryBloc, CategoryState>(
        listenWhen: (previous, current) {
          return (previous.deletedCategory != current.deletedCategory &&
                  current.deletedCategory != null) ||
                 (previous.error != current.error && current.error != null);
        },
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state.deletedCategory != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.deletedCategory!.message ?? 'Category deleted successfully'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.black87),
            );
          }

          if (state.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 56,
                    color: Colors.black38,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Error: ${state.error}',
                    style: const TextStyle(color: Colors.black54),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<CategoryBloc>().add(GetCategoryList()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      foregroundColor: Colors.white,
                    ),
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
                  const Icon(
                    Icons.category_outlined,
                    size: 64,
                    color: Colors.black26,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'No Data Available',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<CategoryBloc>().add(GetCategoryList()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      foregroundColor: Colors.white,
                    ),
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
              ).then((_) {
                if (context.mounted) {
                  context.read<CategoryBloc>().add(GetCategoryList());
                }
              });
            },
          );
        },
      ),
    );
  }
}
