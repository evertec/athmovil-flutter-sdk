import 'package:athmovil_checkout_dummy/constants/app_constants.dart';
import 'package:athmovil_checkout_dummy/view_models/items_view_model.dart';
import 'package:athmovil_checkout_dummy/widgets/primary_button_widget.dart';
import 'package:athmovil_checkout_flutter/model/athmovil_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemFormPage extends StatefulWidget {
  @override
  _ItemFormPageState createState() => _ItemFormPageState();
}

class _ItemFormPageState extends State<ItemFormPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final quantityController = TextEditingController();
  final metadataController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _constants = AppConstants.of(context)!;
    final verticalSpace = SizedBox(height: 16);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _constants.addItemLbl,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: _constants.nameLbl,
                  ),
                ),
                verticalSpace,
                TextFormField(
                  controller: priceController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: _constants.priceLbl,
                  ),
                ),
                verticalSpace,
                TextFormField(
                  controller: quantityController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: _constants.quantityLbl,
                  ),
                ),
                verticalSpace,
                TextFormField(
                  controller: descriptionController,
                  decoration: InputDecoration(
                    labelText: _constants.descriptionLbl,
                  ),
                ),
                verticalSpace,
                TextFormField(
                  controller: metadataController,
                  decoration: InputDecoration(
                    labelText: _constants.metadataLbl,
                  ),
                  onSaved: (value) {},
                ),
                verticalSpace,
                verticalSpace,
                PrimaryButton(
                  onPressed: addItem,
                  text: _constants.addLbl,
                ),
                verticalSpace,
                PrimaryButton(
                  onPressed: addDefaultItem,
                  text: _constants.addDefaultLbl,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addItem() async {
    final newItem = ATHMovilItem(
      name: nameController.text,
      description: descriptionController.text,
      price: convertToCurrency(priceController.text),
      quantity: convertToInt(quantityController.text),
      metadata: metadataController.text,
    );

    await Provider.of<ItemsViewModel>(context, listen: false).addItem(
      item: newItem,
    );

    Navigator.of(context).pop();
  }

  void addDefaultItem() async {
    await Provider.of<ItemsViewModel>(context, listen: false).addItem(
      item: ATHMovilItem(
        name: "Item",
        description: "Description",
        price: 1,
        quantity: 1,
        metadata: "Metadata",
      ),
    );
    Navigator.of(context).pop();
  }

  double convertToDouble(String value) {
    try {
      return double.parse(value);
    } catch (e) {
      return 0.0;
    }
  }

  double convertToCurrency(String value) {
    try {
      String _onlyDigits = value.replaceAll(
        RegExp('[^-?[0-9]\d*(\.\d+)?\$]'),
        "",
      );
      var result = double.parse(_onlyDigits);
      return result;
    } catch (e) {
      return 0.0;
    }
  }

  int convertToInt(String value) {
    try {
      return int.parse(value);
    } catch (e) {
      return 0;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();
    metadataController.dispose();
    super.dispose();
  }
}
