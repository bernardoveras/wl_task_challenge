import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  const CustomCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.backgroundColor,
    this.foregroundColor,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final Color? backgroundColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        width: 28,
        height: 28,
        duration: Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: value
              ? (backgroundColor ?? Theme.of(context).primaryColor)
              : Colors.transparent,
          border: value
              ? null
              : Border.all(
                  color: Colors.blueGrey.shade200,
                  width: 2,
                ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: AnimatedSwitcher(
          duration: Duration(milliseconds: 150),
          reverseDuration: Duration(milliseconds: 150),
          switchInCurve: Curves.ease,
          switchOutCurve: Curves.ease,
          transitionBuilder: (child, animation) {
            final offset = Tween<Offset>(
              begin: Offset(0, 0.2),
              end: Offset(0, 0),
            ).animate(animation);

            return SlideTransition(
              position: offset,
              child: child,
            );
          },
          child: value
              ? Icon(
                  Icons.check,
                  key: Key('checked'),
                  color: foregroundColor ?? Colors.white,
                  size: 24,
                )
              : SizedBox.shrink(
                  key: Key('unchecked'),
                ),
        ),
      ),
    );
  }
}
