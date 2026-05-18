import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final VoidCallback? onMenuPressed;
  final VoidCallback? onNotificationPressed;
  final VoidCallback? onProfilePressed;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final bool automaticallyImplyLeading;
  final bool centerTitle;
  final double? titleSpacing;
  final Widget? leading;
  final bool showNotifications;
  final bool showProfile;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.onMenuPressed,
    this.onNotificationPressed,
    this.onProfilePressed,
    this.onBackPressed,
    this.actions,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.automaticallyImplyLeading = true,
    this.centerTitle = false,
    this.titleSpacing,
    this.leading,
    this.showNotifications = true,
    this.showProfile = true,
    this.bottom,
  });

  static const double _iconSize = 24.0;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? Colors.white,
      foregroundColor: foregroundColor ?? Colors.black87,
      elevation: elevation ?? 1,
      centerTitle: centerTitle,
      titleSpacing: titleSpacing,
      automaticallyImplyLeading: automaticallyImplyLeading,
      bottom: bottom,
      title: titleWidget ??
          (title != null
              ? Text(
                  title!,
                  style: TextStyle(
                    color: foregroundColor ?? Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                )
              : null),
      leading: leading ??
          (onMenuPressed != null
              ? IconButton(
                  icon: Icon(
                    Icons.menu,
                    color: foregroundColor ?? Colors.black87,
                    size: _iconSize,
                  ),
                  onPressed: onMenuPressed,
                )
              : (onBackPressed != null
                  ? IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: foregroundColor ?? Colors.black87,
                        size: _iconSize,
                      ),
                      onPressed: onBackPressed,
                    )
                  : null)),
      actions: actions ??
          [
            if (showNotifications)
              IconButton(
                icon: Icon(
                  Icons.notifications_outlined,
                  color: foregroundColor ?? Colors.black87,
                  size: _iconSize,
                ),
                onPressed: onNotificationPressed ?? () {},
                tooltip: 'Notifications',
              ),
            if (showProfile)
              IconButton(
                icon: Icon(
                  Icons.account_circle_outlined,
                  color: foregroundColor ?? Colors.black87,
                  size: _iconSize,
                ),
                onPressed: onProfilePressed ?? () {},
                tooltip: 'Profile',
              ),
          ],
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}
