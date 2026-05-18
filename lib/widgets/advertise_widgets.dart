import 'package:flutter/material.dart';
import '../models/Advertise_model/GetAdvertiseModel.dart';

class AdvertiseListWidget extends StatelessWidget {
  final List<Data> advertises;
  final VoidCallback onRefresh;
  final Function(int) onDelete;
  final Function(Data) onTap; // Navigate to Update screen

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
        padding: const EdgeInsets.all(12),
        itemCount: advertises.length,
        itemBuilder: (context, index) {
          final advertise = advertises[index];
          return _AdvertiseCard(
            index: index,
            advertise: advertise,
            onDelete: onDelete,
            onUpdate: onTap,
          );
        },
      ),
    );
  }
}

class _AdvertiseCard extends StatelessWidget {
  final int index;
  final Data advertise;
  final Function(int) onDelete;
  final Function(Data) onUpdate;

  const _AdvertiseCard({
    required this.index,
    required this.advertise,
    required this.onDelete,
    required this.onUpdate,
  });

  IconData _socialIcon(String? platform) {
    switch (platform?.toLowerCase()) {
      case 'facebook':
        return Icons.facebook;
      case 'instagram':
        return Icons.camera_alt;
      case 'twitter':
        return Icons.tag;
      case 'threads':
        return Icons.alternate_email;
      default:
        return Icons.campaign;
    }
  }

  Color _socialColor(String? platform) {
    switch (platform?.toLowerCase()) {
      case 'facebook':
        return const Color(0xFF1877F2);
      case 'instagram':
        return const Color(0xFFE4405F);
      case 'twitter':
        return const Color(0xFF1DA1F2);
      default:
        return Colors.deepPurple;
    }
  }

  @override
  Widget build(BuildContext context) {
    final platformColor = _socialColor(advertise.socialmedia);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Serial No
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(6),
              ),
              alignment: Alignment.center,
              child: Text(
                '${index + 1}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple.shade700,
                ),
              ),
            ),
            const SizedBox(width: 10),

            // Platform Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: platformColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _socialIcon(advertise.socialmedia),
                color: platformColor,
                size: 30,
              ),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    advertise.title ?? 'No Title',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 5),
                  _infoRow(Icons.campaign, 'Platform', advertise.socialmedia ?? 'N/A'),
                  _infoRow(Icons.calendar_today, 'Date', advertise.date ?? 'N/A'),
                  _infoRow(Icons.attach_money, 'Price', advertise.price ?? 'N/A'),
                  if (advertise.url != null && advertise.url!.isNotEmpty)
                    _infoRow(Icons.link, 'URL', advertise.url!),
                  const SizedBox(height: 4),
                  // Platform badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: platformColor.withValues(alpha: 0.1),
                      border: Border.all(color: platformColor.withValues(alpha: 0.4)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      advertise.socialmedia?.toUpperCase() ?? 'N/A',
                      style: TextStyle(
                        fontSize: 11,
                        color: platformColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Action Buttons
            Column(
              children: [
                SizedBox(
                  height: 32,
                  child: ElevatedButton.icon(
                    onPressed: () => onUpdate(advertise),
                    icon: const Icon(Icons.edit, size: 13),
                    label: const Text('Update', style: TextStyle(fontSize: 11)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  height: 32,
                  child: ElevatedButton.icon(
                    onPressed: () => _confirmDelete(context),
                    icon: const Icon(Icons.delete, size: 13),
                    label: const Text('Delete', style: TextStyle(fontSize: 11)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Icon(icon, size: 12, color: Colors.grey.shade500),
          const SizedBox(width: 4),
          Text(
            '$label: ',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Advertisement'),
        content: Text('Are you sure you want to delete "${advertise.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              onDelete(advertise.id!);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
