import 'package:flutter/material.dart';

class SimpleDropDown extends StatelessWidget {
  final dynamic value;
  final List<dynamic>? items;
  final Function(dynamic)? onChanged;

  SimpleDropDown({
    this.value,
    this.items,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<dynamic>(
        isExpanded: true,
        focusColor: Colors.white,
        value: value,
        onChanged: onChanged,
        items: items!.map((dynamic value) {
          return DropdownMenuItem<dynamic>(
            value: value,
            child: Text(
              value.toString(),
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    fontSize: 16,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          );
        }).toList(),
      ),
    );
  }
}
