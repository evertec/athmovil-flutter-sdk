import 'package:athmovil_checkout_flutter/util/constants_util.dart';

class ATHMovilItem {
  ATHMovilItem({
    required this.name,
    required this.price,
    required this.quantity,
    this.description,
    this.metadata,
  });

  String? name;
  String? description;
  final double? price;
  final int? quantity;
  String? metadata;

  factory ATHMovilItem.createDefault() => ATHMovilItem(
        name: ConstantsUtil.ATHM_DEFAULT,
        description: "",
        price: 1.0,
        quantity: 1,
        metadata: "",
      );

  factory ATHMovilItem.fromMap(Map<String, dynamic> data) {
    return ATHMovilItem(
      name: data['name'],
      description: dataToDescription(data['description'], data['desc']),
      price: dataToDouble(data['price'].toDouble() ?? 0.00),
      quantity: data['quantity'].toInt() ?? 1,
      metadata: data['metadata'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'quantity': quantity,
      'metadata': metadata,
      //ios
      'desc': description,
    };
  }

  Map toJson() => {
        'name': name,
        'description': description,
        'price': price,
        'quantity': quantity,
        'metadata': metadata,
      };

  static String itemsToJson(List<ATHMovilItem>? items) {
    String json = "";
    if (items != null) {
      json = "";
      items.forEach((element) {
        json = json + "\n" + element.toJson().toString();
      });
    }
    return json;
  }

  static double dataToDouble(double num) {
    return double.parse(num.toStringAsFixed(2));
  }

  static String? dataToDescription(String? description, String? desc) {
    if (description == null || description == "null") {
      return desc;
    }
    return description;
  }
}
