import 'package:athmovil_checkout_dummy/widgets/item_settings_widget.dart';
import 'package:athmovil_checkout_flutter/model/athmovil_item.dart';
import 'package:athmovil_checkout_flutter/model/athmovil_payment_response.dart';
import 'package:flutter/material.dart';

class PaymentResultPage extends StatefulWidget {
  PaymentResultPage({required this.athMovilPaymentResponse})
      : assert(athMovilPaymentResponse != null);
  final ATHMovilPaymentResponse? athMovilPaymentResponse;

  @override
  _PaymentResultState createState() => _PaymentResultState();
}

class _PaymentResultState extends State<PaymentResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.athMovilPaymentResponse!.status.toString()),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          ItemSettings(
            title: 'Status',
            value: widget.athMovilPaymentResponse!.status.toString(),
          ),
          SizedBox(height: 8),
          ItemSettings(
            title: 'Date',
            value: widget.athMovilPaymentResponse!.date.toString(),
          ),
          SizedBox(height: 8),
          ItemSettings(
            title: 'Reference Number',
            value: widget.athMovilPaymentResponse!.referenceNumber,
          ),
          SizedBox(height: 8),
          ItemSettings(
            title: 'Daily Transaction ID',
            value: widget.athMovilPaymentResponse!.dailyTransactionID,
          ),
          SizedBox(height: 8),
          ItemSettings(
            title: 'Name',
            value: widget.athMovilPaymentResponse!.name.toString(),
          ),
          SizedBox(height: 8),
          ItemSettings(
            title: 'Phone',
            value: widget.athMovilPaymentResponse!.phoneNumber.toString(),
          ),
          SizedBox(height: 8),
          ItemSettings(
            title: 'Email',
            value: widget.athMovilPaymentResponse!.email.toString(),
          ),
          SizedBox(height: 8),
          ItemSettings(
            title: 'Total',
            value: widget.athMovilPaymentResponse!.total!.toStringAsFixed(2),
          ),
          SizedBox(height: 8),
          ItemSettings(
            title: 'Tax',
            value: widget.athMovilPaymentResponse!.tax!.toStringAsFixed(2),
          ),
          SizedBox(height: 8),
          ItemSettings(
            title: 'Subtotal',
            value: widget.athMovilPaymentResponse!.subtotal!.toStringAsFixed(2),
          ),
          SizedBox(height: 8),
          ItemSettings(
            title: 'Fee',
            value: widget.athMovilPaymentResponse!.fee!.toStringAsFixed(2),
          ),
          SizedBox(height: 8),
          ItemSettings(
            title: 'NetAmount',
            value:
                widget.athMovilPaymentResponse!.netAmount!.toStringAsFixed(2),
          ),
          SizedBox(height: 8),
          ItemSettings(
            title: 'Metadata1',
            value: widget.athMovilPaymentResponse!.metadata1.toString(),
          ),
          SizedBox(height: 8),
          ItemSettings(
            title: 'Metadata2',
            value: widget.athMovilPaymentResponse!.metadata2.toString(),
          ),
          SizedBox(height: 8),
          ItemSettings(
            title: 'Items',
            value:
                ATHMovilItem.itemsToJson(widget.athMovilPaymentResponse!.items),
          ),
        ],
      ),
    );
  }
}
