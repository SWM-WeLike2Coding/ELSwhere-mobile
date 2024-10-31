import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Widget? title;
  final List<Widget>? actions;
  final PreferredSizeWidget? bottom;
  final double elevation;
  final Color backgroundColor;
  final Color foregroundColor;
  final bool centerTitle;
  final SystemUiOverlayStyle? systemOverlayStyle;

  const CustomAppBar({
    super.key,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.title,
    this.actions,
    this.bottom,
    this.elevation = 0,
    this.backgroundColor = Colors.white,
    this.foregroundColor = Colors.black,
    this.centerTitle = false,
    this.systemOverlayStyle,
  });

  @override
  Size get preferredSize => Size.fromHeight(bottom == null ? 56.0 : 96.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      title: title,
      actions: actions,
      bottom: bottom,
      elevation: elevation,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      centerTitle: centerTitle,
      systemOverlayStyle: systemOverlayStyle,
    );
  }
}
