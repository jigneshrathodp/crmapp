import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/product_bloc.dart';
import '../../events/product_events.dart';
import '../../states/product_state.dart';
import '../../widgets/product_widgets.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_drawer.dart';
import '../notification_screen.dart';
import '../profile/profile_screen.dart';
import '../../utils/navigation_mixin.dart';
import 'create_product_screen.dart';
import 'update_product_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> with DrawerNavigationMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(GetProductList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'Products',
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
        selectedIndex: 3,
        onItemTapped: onDrawerItemTapped,
        headerTitle: 'CRM App',
        headerSubtitle: 'Products',
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
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
                        context.read<ProductBloc>().add(GetProductList()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state.productList?.data == null ||
              state.productList!.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No products found'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<ProductBloc>().add(GetProductList()),
                    child: const Text('Refresh'),
                  ),
                ],
              ),
            );
          }

          return ProductListWidget(
            products: state.productList!.data!,
            onRefresh: () =>
                context.read<ProductBloc>().add(GetProductList()),
            onDelete: (id) =>
                context.read<ProductBloc>().add(DeleteProduct(id)),
            onTap: (product) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateProductScreen(
                    productId: product.id!,
                    productName: product.name,
                    productSku: product.sku,
                    categoryId: product.categoryId,
                    quantity: product.quantity,
                    sellPrice: product.sellPrice,
                    weightInGram: product.weightInGram,
                    costPerGram: product.costPerGram,
                    totalCost: product.totalCost,
                    image: product.image,
                    active: product.active,
                    forSale: product.forSale,
                  ),
                ),
              ).then((_) => context.read<ProductBloc>().add(GetProductList()));
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateProductScreen(),
            ),
          ).then((_) => context.read<ProductBloc>().add(GetProductList()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
