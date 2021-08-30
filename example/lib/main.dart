import 'package:athmovil_checkout_flutter/interfaces/athmovil_payment_response_listener.dart';
import 'package:athmovil_checkout_flutter/model/athmovil_item.dart';
import 'package:athmovil_checkout_flutter/model/athmovil_payment.dart';
import 'package:athmovil_checkout_flutter/model/athmovil_payment_response.dart';
import 'package:athmovil_checkout_flutter/util/constants_util.dart';
import 'package:athmovil_checkout_flutter/widget/athmovil_payment_button.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ATHM Checkout Flutter Demo",
      debugShowCheckedModeBanner: false,
      home: MyWidget(),
    );
  }
}

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget>
    implements ATHMovilPaymentResponseListener {
  // List of items
  final items = <ATHMovilItem>[
    ATHMovilItem(
      name: 'Shirt',
      description: '',
      price: 10.99,
      quantity: 1,
      // Just as an example, we are using the metadata for an image
      metadata:
          'https://cdn11.bigcommerce.com/s-rxzabllq/images/stencil/1280x1280/products/910/18045/Kids-Plain-Poly-Fit-Quick_Dry-Tshirt-red__13799.1567089094.jpg',
    ),
    ATHMovilItem(
      name: 'Shoes for men',
      description: '',
      price: 16.99,
      quantity: 1,
      // Just as an example, we are using the metadata for an image
      metadata:
          'https://assets.ajio.com/medias/sys_master/root/h97/hbd/13018773553182/-288Wx360H-460319109-navy-MODEL.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Car Shop'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return CarItem(item: items[index]);
                },
              ),
              transactionDetail(),
              Expanded(child: SizedBox.shrink()),
              Container(
                height: 55,
                child: ATHMovilPaymentButton(
                  buildType: ".qa",
                  athMovilPayment: ATHMovilPayment(
                    businessToken: 'dummy',
                    callbackSchema: 'ATHMSDK',
                    total: getTotal(),
                    subtotal: getTotalPriceItems(),
                    tax: getTax(),
                    timeout: ConstantsUtil.ATHM_MIN_TIMEOUT,
                    items: [
                      ATHMovilItem.createDefault(),
                      ATHMovilItem.createDefault()
                    ],
                  ),
                  listener: this,
                  style: Style.dark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void onCancelledPayment(ATHMovilPaymentResponse athMovilPaymentResponse) {
    _showATHMPaymentResult(
      title: 'Cancelled Payment',
      content: SizedBox.shrink(),
    );
    // TODO If its possible to get the referenced data if not remove it.
  }

  @override
  void onCompletedPayment(ATHMovilPaymentResponse athMovilPaymentResponse) {
    _showATHMPaymentResult(
      title: 'Completed Payment',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SimpleItem(
            title: 'Reference Number',
            description: athMovilPaymentResponse.referenceNumber,
          ),
          SizedBox(height: 8),
          SimpleItem(
            title: 'Total',
            description: athMovilPaymentResponse.total.toString(),
          ),
        ],
      ),
    );
  }

  @override
  void onExpiredPayment(ATHMovilPaymentResponse athMovilPaymentResponse) {
    _showATHMPaymentResult(
      title: 'Expired Payment',
      content: SizedBox.shrink(),
    );
  }

  @override
  void onPaymentException(String error, String description) {
    _showATHMPaymentResult(
      title: 'Payment Exception',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SimpleItem(
            title: 'Error',
            description: error,
          ),
          SizedBox(height: 8),
          SimpleItem(
            title: 'Message',
            description: description,
          ),
        ],
      ),
    );
  }

  Future<void> _showATHMPaymentResult({String title, Widget content}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            overflow: TextOverflow.ellipsis,
          ),
          actions: [
            TextButton(
              child: Text(
                'Ok',
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          content: content,
        );
      },
    );
  }

  Widget transactionDetail() {
    final _textStyle = Theme.of(context).textTheme.subtitle2.copyWith(
          fontSize: 17,
        );
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          SimpleItem(
            title: 'Subtotal',
            description: '\$${getTotalPriceItems().toString()}',
            textStyle: _textStyle,
          ),
          SizedBox(height: 8),
          SimpleItem(
            title: 'Tax',
            description: '\$${getTax()}',
            textStyle: _textStyle,
          ),
          SizedBox(height: 32),
          SimpleItem(
            title: 'TOTAL',
            description: '\$${getTotal()}',
            textStyle: _textStyle.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  double getTotalPriceItems() {
    var totalPriceItems = 0.0;
    items.forEach((e) => totalPriceItems += e.price * e.quantity);
    return double.parse(totalPriceItems.toStringAsFixed(2));
  }

  double getTax() {
    var totalTax = getTotalPriceItems() * 0.08;
    return double.parse(totalTax.toStringAsFixed(2));
  }

  double getTotal() {
    return double.parse((getTotalPriceItems() + getTax()).toStringAsFixed(2));
  }
}

class CarItem extends StatelessWidget {
  final ATHMovilItem item;

  CarItem({Key key, @required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 80,
            height: 90,
            child: Icon(
              Icons.shopping_bag_outlined,
              size: 30.0,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                item.name,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              '\$${item.price}',
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class SimpleItem extends StatelessWidget {
  final String title;
  final String description;
  final TextStyle textStyle;

  SimpleItem({
    @required this.title,
    @required this.description,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: textStyle != null
              ? textStyle
              : Theme.of(context).textTheme.bodyText1,
        ),
        Expanded(
          child: Text(
            description,
            style: textStyle != null
                ? textStyle
                : Theme.of(context).textTheme.bodyText2,
            overflow: TextOverflow.ellipsis,
            textAlign: textStyle != null ? TextAlign.right : TextAlign.left,
          ),
        ),
      ],
    );
  }
}
