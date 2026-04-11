import 'package:flutter/material.dart';
import '../constants.dart';

/// A consistent app bar for use across screens that need a back button + title.
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;

  const MyAppBar({
    super.key,
    required this.title,
    this.actions,
    this.automaticallyImplyLeading = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: DynamicColors.bg(context),
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: automaticallyImplyLeading
          ? GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(kSpaceSM),
                decoration: BoxDecoration(
                  color: DynamicColors.card(context),
                  borderRadius: BorderRadius.circular(kRadiusSM),
                  border: Border.all(color: DynamicColors.border(context)),
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: DynamicColors.textPrimary(context),
                  size: 18,
                ),
              ),
            )
          : null,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: DynamicColors.textPrimary(context),
        ),
      ),
      actions: actions,
    );
  }
}
