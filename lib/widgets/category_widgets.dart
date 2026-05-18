import 'package:flutter/material.dart';
import '../models/Category_model/GetCatgoryModel.dart';

class CategoryListWidget extends StatelessWidget {
  final List<Data> categories;
  final VoidCallback onRefresh;
  final Function(int) onDelete;
  // Navigate to CategoryViewScreen when tapping an item
  final Function(Data) onTap;

  const CategoryListWidget({
    super.key,
    required this.categories,
    required this.onRefresh,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              onTap: () => onTap(category),
              leading: category.image != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        category.image!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.category),
                      ),
                    )
                  : const Icon(Icons.category),
              title: Text(category.name ?? 'No name'),
              subtitle: Text('SKU: ${category.skubarCode ?? 'N/A'}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Category'),
                      content: const Text(
                          'Are you sure you want to delete this category?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            onDelete(category.id!);
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
