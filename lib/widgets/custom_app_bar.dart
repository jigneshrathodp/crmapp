import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/profile_bloc.dart';
import '../states/profile_state.dart';

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
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        final profileDetails = state.profileDetails;
        final details = profileDetails?['details'];
        final user = profileDetails?['user'];
        final logoDark = details?['logo_dark'] as String?;
        final profileImage = user?['image'] as String?;

        return AppBar(
          backgroundColor: backgroundColor ?? Colors.white,
          foregroundColor: foregroundColor ?? Colors.black87,
          elevation: elevation ?? 1,
          centerTitle: centerTitle,
          titleSpacing: titleSpacing,
          automaticallyImplyLeading: automaticallyImplyLeading,
          bottom:
              bottom ??
              (title != null
                  ? PreferredSize(
                      preferredSize: const Size.fromHeight(48),
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Text(
                          title!,
                          style: TextStyle(
                            color: foregroundColor ?? Colors.black87,
                            fontWeight: FontWeight.w700,
                            fontSize: 22,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    )
                  : null),
          title:
              titleWidget ??
              (logoDark != null
                  ? Image.network(
                      logoDark,
                      height: 18,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Text(
                        'CRM App',
                        style: TextStyle(
                          color: foregroundColor ?? Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    )
                  : Text(
                      'CRM App',
                      style: TextStyle(
                        color: foregroundColor ?? Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    )),
          leading:
              leading ??
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
          actions:
              actions ??
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
                    icon: profileImage != null
                        ? ClipOval(
                            child: Image.network(
                              profileImage,
                              width: _iconSize,
                              height: _iconSize,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Icon(
                                Icons.account_circle_outlined,
                                color: foregroundColor ?? Colors.black87,
                                size: _iconSize,
                              ),
                            ),
                          )
                        : Icon(
                            Icons.account_circle_outlined,
                            color: foregroundColor ?? Colors.black87,
                            size: _iconSize,
                          ),
                    onPressed: onProfilePressed ?? () {},
                    tooltip: 'Profile',
                  ),
              ],
        );
      },
    );
  }

  @override
  Size get preferredSize {
    double bottomHeight = bottom?.preferredSize.height ?? 0.0;
    if (bottom == null && title != null) {
      bottomHeight = 48.0; // The height added for the title in bottom
    }
    return Size.fromHeight(kToolbarHeight + bottomHeight);
  }
}
