import 'package:athmovil_checkout_dummy/constants/app_constants.dart';
import 'package:athmovil_checkout_dummy/pages/cart/cart_page.dart';
import 'package:athmovil_checkout_dummy/pages/items/widgets/item_card.dart';
import 'package:athmovil_checkout_dummy/pages/payment_settings/payment_settings_page.dart';
import 'package:athmovil_checkout_dummy/view_models/items_view_model.dart';
import 'package:athmovil_checkout_dummy/widgets/primary_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ItemsPage extends StatefulWidget {
  @override
  _ItemsPageState createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<ItemsViewModel>(context, listen: false).fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.of(context)!.itemsLbl),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).pushNamed(
              "/item-form",
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PaymentSettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<ItemsViewModel>(
        builder: (context, itemsViewModel, child) {
          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 2),
                  child: ListView.separated(
                    itemCount: itemsViewModel.items.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        Divider(
                      height: 1,
                    ),
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: UniqueKey(),
                        background: Container(),
                        secondaryBackground: Container(
                          color: Theme.of(context).primaryColor,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: const Padding(
                              padding: EdgeInsets.all(16),
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        confirmDismiss: (DismissDirection direction) async {
                          if (direction == DismissDirection.endToStart) {
                            return true;
                          } else {
                            return false;
                          }
                        },
                        onDismissed: (DismissDirection direction) {
                          if (direction == DismissDirection.endToStart) {
                            Provider.of<ItemsViewModel>(context, listen: false)
                                .deleteItem(
                              position: index,
                            );
                          }
                        },
                        child: ItemCard(
                          item: itemsViewModel.items[index],
                        ),
                      );
                    },
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: PrimaryButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => CartPage(),
                        ),
                      );
                    },
                    text: AppConstants.of(context)!.goToCartLbl,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
