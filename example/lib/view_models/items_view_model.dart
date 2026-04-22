import 'dart:convert';

import 'package:athmovil_checkout_dummy/utils/local_storage_key_utils.dart';
import 'package:athmovil_checkout_dummy/utils/utils.dart';
import 'package:athmovil_checkout_flutter/model/athmovil_item.dart';
import 'package:flutter/material.dart';

class ItemsViewModel extends ChangeNotifier {
  List<ATHMovilItem> items = [];

  Future<void> fetchItems() async {
    final stringItems = await Utils().getPrefsString(key: ITEMS_PREF_KEY);

    if (stringItems == null) return;

    final jsonItems = jsonDecode(stringItems);
    items = List<ATHMovilItem>.from(
      jsonItems.map((item) => ATHMovilItem.fromMap(item)),
    );
    notifyListeners();
  }

  Future<void> addItem({required ATHMovilItem item}) async {
    items.add(item);
    updateItems(items: items);
    notifyListeners();
  }

  Future<void> deleteItem({required int position}) async {
    items.removeAt(position);
    updateItems(items: items);
    notifyListeners();
  }

  Future<void> updateItems({required List<ATHMovilItem> items}) async {
    final jsonItems = items.map((item) => item.toJson()).toList();
    Utils().setPrefsString(key: ITEMS_PREF_KEY, value: jsonEncode(jsonItems));
    notifyListeners();
  }
}
