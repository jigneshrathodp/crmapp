import 'package:flutter/material.dart';
import '../models/product_model/GetproductModel.dart';

class ProductListWidget extends StatelessWidget {
  final List<Data> products;
  final VoidCallback onRefresh;
  final Function(int) onDelete;
  // Navigate to ProductViewScreen when tapping an item
  final Function(Data) onTap;

  const ProductListWidget({
    super.key,
    required this.products,
    required this.onRefresh,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              onTap: () => onTap(product),
              leading: product.image != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        product.image!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.inventory_2),
                      ),
                    )
                  : const Icon(Icons.inventory_2),
              title: Text(product.name ?? 'No name'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('SKU: ${product.sku ?? 'N/A'}'),
                  Text('Price: \$${product.sellPrice ?? '0'}'),
                  Text('Qty: ${product.quantity ?? '0'}'),
                ],
              ),
              isThreeLine: true,
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Product'),
                      content: const Text(
                          'Are you sure you want to delete this product?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            onDelete(product.id!);
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Delete',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
