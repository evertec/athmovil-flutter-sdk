import 'package:athmovil_checkout_flutter/model/athmovil_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItemCard extends StatelessWidget {
  final ATHMovilItem? item;
  final formatter = new NumberFormat("#,##0.00", "en_US");

  ItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final _textTheme = Theme.of(context).textTheme;
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      leading: CircleAvatar(),
      title: Text(item!.name!),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4),
          Text(item!.description!),
          SizedBox(height: 4),
          Text(item!.metadata!),
        ],
      ),
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "x${item!.quantity}",
            style: _textTheme.titleSmall,
          ),
          SizedBox(height: 4),
          Text(
            ("\$" + item!.price!.toStringAsFixed(2)),
            style: _textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}
