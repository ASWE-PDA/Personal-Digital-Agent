import "package:flutter/material.dart";

/// Widget that displays a setting.
///
/// The [title] describes the functionality of the setting.
/// The [icon] icon is displayed in front of the setting description.
/// The optional [action] implements the functionailty of the setting.
///
/// The [paddingRight] defines the padding of the [action].
/// By default the padding is set to zero (which is the value that is needed
/// if the [action] is an `IconButton`)
///
/// By default overflow for the title of the setting is prevented.
/// If the [action] widget is a `TextButton`
/// it could be more important to prevent text overflow for the text button
/// instead of the title overflow (for example for the mail setting).
/// In that case the [preventActionOverflow] bool can be set to true.
class SettingsWidget extends StatelessWidget {
  SettingsWidget(
      {super.key,
      required this.title,
      required this.icon,
      required this.action,
      this.paddingRight = 0.0,
      this.preventActionOverflow = false});
  final String title;
  final Icon icon;
  final Widget action;
  final double paddingRight;
  final bool preventActionOverflow;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.secondary,
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Container(
        padding: EdgeInsets.only(
          left: 8.0,
          right: paddingRight,
          top: 4.0,
          bottom: 4.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Theme.of(context).colorScheme.secondaryContainer,
        ),
        child: preventActionOverflow
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: icon,
                  ),
                  Text(title),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: action,
                    ),
                  )
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: icon,
                  ),
                  Expanded(flex: 2, child: Text(title)),
                  Container(child: action)
                ],
              ),
      ),
    );
  }
}
