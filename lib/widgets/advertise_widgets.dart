import 'package:flutter/material.dart';
import '../models/Advertise_model/GetAdvertiseModel.dart';

class AdvertiseListWidget extends StatelessWidget {
  final List<Data> advertises;
  final VoidCallback onRefresh;
  final Function(int) onDelete;
  // Navigate to AdvertiseUpdateScreen when tapping an item
  final Function(Data) onTap;

  const AdvertiseListWidget({
    super.key,
    required this.advertises,
    required this.onRefresh,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView.builder(
        itemCount: advertises.length,
        itemBuilder: (context, index) {
          final advertise = advertises[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              onTap: () => onTap(advertise),
              leading: const Icon(Icons.campaign),
              title: Text(advertise.title ?? 'No title'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Platform: ${advertise.socialmedia ?? 'N/A'}'),
                  Text('Date: ${advertise.date ?? 'N/A'}'),
                ],
              ),
              isThreeLine: true,
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Delete Advertisement'),
                      content: const Text(
                          'Are you sure you want to delete this advertisement?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            onDelete(advertise.id!);
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
