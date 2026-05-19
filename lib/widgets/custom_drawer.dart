import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../events/auth_events.dart';
import '../screens/login_screen.dart';
import '../bloc/profile_bloc.dart';
import '../states/profile_state.dart';

class CustomDrawer extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final String? headerTitle;
  final String? headerSubtitle;
  final Widget? headerWidget;
  final List<DrawerItem>? drawerItems;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final Color? selectedTileColor;
  final TextStyle? itemTextStyle;
  final bool showHeader;

  const CustomDrawer({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    this.headerTitle,
    this.headerSubtitle,
    this.headerWidget,
    this.drawerItems,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.selectedTileColor,
    this.itemTextStyle,
    this.showHeader = true,
  });

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final Set<String> _expandedItems = {};

  late Color _drawerBackgroundColor;
  late Color _selectedColor;
  late Color _unselectedColor;
  late Color? _tileColor;
  double _maxDrawerWidth = 0;
  late List<DrawerItem> _defaultDrawerItems;

  @override
  void initState() {
    super.initState();
    _initializeCachedValues();
  }

  @override
  void didUpdateWidget(CustomDrawer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.backgroundColor != widget.backgroundColor ||
        oldWidget.selectedItemColor != widget.selectedItemColor ||
        oldWidget.unselectedItemColor != widget.unselectedItemColor ||
        oldWidget.drawerItems != widget.drawerItems) {
      _initializeCachedValues();
    }
  }

  void _initializeCachedValues() {
    _drawerBackgroundColor = widget.backgroundColor ?? Colors.black87;
    _selectedColor = widget.selectedItemColor ?? Colors.white;
    _unselectedColor = widget.unselectedItemColor ?? Colors.grey.shade400;
    _tileColor = widget.selectedTileColor ?? Colors.white.withValues(alpha: 0.12);
    _defaultDrawerItems = widget.drawerItems ?? _getDefaultDrawerItems();
  }

  String _getItemKey(int index) => 'drawer_item_$index';
  bool _isExpanded(int index) => _expandedItems.contains(_getItemKey(index));

  void _toggleExpansion(int index) {
    setState(() {
      final key = _getItemKey(index);
      if (_expandedItems.contains(key)) {
        _expandedItems.remove(key);
      } else {
        _expandedItems.add(key);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_maxDrawerWidth == 0) {
      final screenWidth = MediaQuery.of(context).size.width;
      final drawerWidth = screenWidth * 0.80;
      _maxDrawerWidth = drawerWidth > 320 ? 320.0 : drawerWidth;
    }

    return SizedBox(
      width: _maxDrawerWidth,
      child: Drawer(
        backgroundColor: _drawerBackgroundColor,
        child: SafeArea(
          child: Column(
            children: [
              if (widget.showHeader) _buildDrawerHeader(context),
              Expanded(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ..._buildDrawerItems(context),
                    const Divider(color: Colors.grey, height: 1),
                    const SizedBox(height: 8),
                    _buildLogoutItem(context),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDrawerItems(BuildContext context) {
    return List.generate(_defaultDrawerItems.length, (index) {
      final item = _defaultDrawerItems[index];
      final isExpanded = _isExpanded(index);
      final hasSubItems = _getSubItems(index).isNotEmpty;

      if (hasSubItems) {
        return _buildExpandableItem(context, index, item, isExpanded);
      } else {
        return _buildStandaloneItem(context, index, item);
      }
    });
  }

  Widget _buildExpandableItem(
    BuildContext context,
    int index,
    DrawerItem item,
    bool isExpanded,
  ) {
    return Column(
      children: [
        ListTile(
          leading: Icon(item.icon, color: _unselectedColor, size: 22),
          title: Text(
            item.title,
            style: widget.itemTextStyle ??
                TextStyle(color: _unselectedColor, fontSize: 15),
          ),
          trailing: Icon(
            isExpanded ? Icons.expand_less : Icons.expand_more,
            color: _unselectedColor,
            size: 20,
          ),
          onTap: () => _toggleExpansion(index),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          dense: true,
        ),
        if (isExpanded) ..._buildSubItems(context, index),
      ],
    );
  }

  Widget _buildStandaloneItem(
    BuildContext context,
    int index,
    DrawerItem item,
  ) {
    final screenIndex = _getStandaloneScreenIndex(index);
    final isSelected = widget.selectedIndex == screenIndex;

    return ListTile(
      leading: Icon(
        item.icon,
        color: isSelected ? _selectedColor : _unselectedColor,
        size: 22,
      ),
      title: Text(
        item.title,
        style: widget.itemTextStyle ??
            TextStyle(
              color: isSelected ? _selectedColor : _unselectedColor,
              fontSize: 15,
              fontWeight:
                  isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
      ),
      onTap: () {
        Navigator.pop(context); // close drawer
        widget.onItemTapped(screenIndex);
      },
      selected: isSelected,
      selectedTileColor: _tileColor,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      dense: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  List<Widget> _buildSubItems(BuildContext context, int parentIndex) {
    final subItems = _getSubItems(parentIndex);
    return List.generate(subItems.length, (subIndex) {
      final subItem = subItems[subIndex];
      final isSelected =
          widget.selectedIndex == _getSubItemGlobalIndex(parentIndex, subIndex);

      return ListTile(
        leading: Icon(
          subItem.icon,
          color: isSelected ? _selectedColor : _unselectedColor,
          size: 18,
        ),
        title: Text(
          subItem.title,
          style: widget.itemTextStyle ??
              TextStyle(
                color: isSelected ? _selectedColor : _unselectedColor,
                fontSize: 14,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
        ),
        onTap: () {
          Navigator.pop(context); // close drawer
          widget.onItemTapped(
              _getSubItemGlobalIndex(parentIndex, subIndex));
        },
        selected: isSelected,
        selectedTileColor: _tileColor,
        contentPadding: const EdgeInsets.only(
          left: 44,
          right: 16,
          top: 0,
          bottom: 0,
        ),
        dense: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      );
    });
  }

  Widget _buildDrawerHeader(BuildContext context) {
    if (widget.headerWidget != null) {
      return widget.headerWidget!;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      decoration: BoxDecoration(
        color: _drawerBackgroundColor,
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.1), width: 1),
        ),
      ),
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          final profileDetails = state.profileDetails;
          final details = profileDetails?['details'];
          final logoLight = details?['logo_light'] as String?;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: logoLight != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          logoLight,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.store_rounded, color: Colors.white, size: 30),
                        ),
                      )
                    : const Icon(Icons.store_rounded, color: Colors.white, size: 30),
              ),
              const SizedBox(height: 14),
              if (widget.headerTitle != null)
                Text(
                  widget.headerTitle!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              if (widget.headerSubtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  widget.headerSubtitle!,
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildLogoutItem(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 22),
      title: const Text(
        'Logout',
        style: TextStyle(color: Colors.redAccent, fontSize: 15),
      ),
      onTap: () => _handleLogout(context),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      dense: true,
    );
  }

  void _handleLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('શું તમે logout કરવા માંગો છો?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<AuthBloc>().add(Logout());
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  List<DrawerItem> _getDefaultDrawerItems() {
    return const [
      DrawerItem(icon: Icons.dashboard_rounded, title: 'Dashboard'),
      DrawerItem(icon: Icons.shop_rounded, title: 'Orders'),
      DrawerItem(icon: Icons.shopping_bag_rounded, title: 'Products'),
      DrawerItem(icon: Icons.category_rounded, title: 'Category'),
      DrawerItem(icon: Icons.campaign_rounded, title: 'Advertise'),
      DrawerItem(icon: Icons.notifications_rounded, title: 'Notifications'),
      DrawerItem(icon: Icons.settings_rounded, title: 'Settings'),
    ];
  }

  List<DrawerItem> _getSubItems(int parentIndex) {
    switch (parentIndex) {
      case 1: // Orders
        return const [
          DrawerItem(icon: Icons.add_shopping_cart, title: 'Order Now'),
          DrawerItem(icon: Icons.shopping_cart, title: 'Order List'),
        ];
      case 2: // Products
        return const [
          DrawerItem(icon: Icons.list_alt, title: 'Product List'),
          DrawerItem(icon: Icons.add_box, title: 'Create Product'),
        ];
      case 3: // Category
        return const [
          DrawerItem(icon: Icons.list_alt, title: 'Category List'),
          DrawerItem(icon: Icons.add_box, title: 'Create Category'),
        ];
      case 4: // Advertise
        return const [
          DrawerItem(icon: Icons.list_alt, title: 'Ad List'),
          DrawerItem(icon: Icons.add_box, title: 'Create Ad'),
        ];
      case 6: // Settings
        return const [
          DrawerItem(icon: Icons.person, title: 'Profile'),
          DrawerItem(icon: Icons.edit, title: 'Edit Profile'),
          DrawerItem(icon: Icons.lock, title: 'Change Password'),
        ];
      default:
        return [];
    }
  }

  int _getSubItemGlobalIndex(int parentIndex, int subIndex) {
    switch (parentIndex) {
      case 1: // Orders dropdown
        return 1 + subIndex; // Order Now (1), Order List (2)
      case 2: // Products dropdown
        return 3 + subIndex; // Product List (3), Create Product (4)
      case 3: // Category dropdown
        return 5 + subIndex; // Category List (5), Create Category (6)
      case 4: // Advertise dropdown
        return 7 + subIndex; // Ad List (7), Create Ad (8)
      case 6: // Settings dropdown
        return 10 + subIndex; // Profile (10), Edit Profile (11), Change Password (12)
      default:
        return parentIndex;
    }
  }

  int _getStandaloneScreenIndex(int drawerIndex) {
    switch (drawerIndex) {
      case 0: // Dashboard
        return 0;
      case 5: // Notifications — drawer index 5, screen index 9
        return 9;
      default:
        return drawerIndex;
    }
  }
}

// ─── Data Classes ──────────────────────────────────────────────────────────────

class DrawerItem {
  final IconData icon;
  final String title;
  final String? badge;

  const DrawerItem({required this.icon, required this.title, this.badge});
}

class CustomDrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final String? badge;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? selectedTileColor;

  const CustomDrawerItem({
    super.key,
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
    this.badge,
    this.selectedColor,
    this.unselectedColor,
    this.selectedTileColor,
  });

  @override
  Widget build(BuildContext context) {
    final selected = selectedColor ?? Colors.white;
    final unselected = unselectedColor ?? Colors.grey;
    final tileColor = selectedTileColor ?? Colors.grey[800];

    return ListTile(
      leading: Icon(icon, color: isSelected ? selected : unselected, size: 22),
      title: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? selected : unselected,
                fontSize: 15,
              ),
            ),
          ),
          if (badge != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                badge!,
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ],
        ],
      ),
      onTap: onTap,
      selected: isSelected,
      selectedTileColor: tileColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      dense: true,
    );
  }
}
