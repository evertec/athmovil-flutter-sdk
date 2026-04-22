import 'package:flutter/material.dart';

class ItemSettings extends StatelessWidget {
  final String title;
  final String? value;
  final Widget? dropDown;
  final Function? onPressed;

  ItemSettings({
    Key? key,
    required this.title,
    this.value,
    this.dropDown,
    this.onPressed,
  }) : super();

  @override
  Widget build(BuildContext context) {
    final valueStyle = Theme.of(context).textTheme.bodySmall!.copyWith(
          fontSize: 16,
        );

    final titleWidget = Text(
      title,
      style: Theme.of(context).textTheme.titleSmall!.copyWith(
            fontSize: 16,
          ),
    );

    return InkWell(
      onTap: onPressed as void Function()?,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Row(
          children: [
            if (dropDown != null) ...[
              Expanded(flex: 3, child: titleWidget),
              Expanded(flex: 2, child: dropDown!),
            ],
            if (dropDown == null) ...[
              titleWidget,
              SizedBox(width: 8),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    value!,
                    style: valueStyle,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
