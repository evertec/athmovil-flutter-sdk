import 'package:athmovil_checkout_dummy/constants/app_constants.dart';
import 'package:athmovil_checkout_dummy/pages/result/payment_result_page.dart';
import 'package:athmovil_checkout_dummy/view_models/items_view_model.dart';
import 'package:athmovil_checkout_dummy/view_models/payment_view_model.dart';
import 'package:athmovil_checkout_dummy/widgets/item_settings_widget.dart';
import 'package:athmovil_checkout_dummy/widgets/primary_button_widget.dart';
import 'package:athmovil_checkout_flutter/interfaces/athmovil_payment_response_listener.dart';
import 'package:athmovil_checkout_flutter/model/athmovil_payment.dart';
import 'package:athmovil_checkout_flutter/model/athmovil_payment_response.dart';
import 'package:athmovil_checkout_flutter/widget/athmovil_payment_secure_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:athmovil_checkout_flutter/generated/l10n.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage>
    implements ATHMovilPaymentResponseListener {
  final formatter = new NumberFormat("#,##0.00", "en_US");
  AppConstants? _constants;

  @override
  void didChangeDependencies() {
    Provider.of<PaymentViewModel>(context, listen: false).fetchInitialValues();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _constants = AppConstants.of(context);
    final _verticalSpace = SizedBox(height: 8);
    return Scaffold(
      appBar: AppBar(
        title: Text(_constants!.cartLbl),
        centerTitle: true,
      ),
      body: Consumer<PaymentViewModel>(
        builder: (
          context,
          paymentViewModel,
          child,
        ) {
          if (paymentViewModel.paymentAmount == null) {
            return Center(child: CircularProgressIndicator());
          }
          //ESCUCHAR LOADING
          return context.watch<PaymentViewModel>().isLoading
              ? Center(child: CircularProgressIndicator())
              : SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: ListView(
                      children: [
                        ItemSettings(
                          title: _constants!.totalLbl,
                          value:
                              "\$${formatter.format(paymentViewModel.paymentAmount)}",
                        ),
                        Divider(),
                        ItemSettings(
                          title: _constants!.subtotal,
                          value:
                              "\$${formatter.format(paymentViewModel.subtotal)}",
                        ),
                        Divider(),
                        ItemSettings(
                          title: _constants!.tax,
                          value: "\$${formatter.format(paymentViewModel.tax)}",
                        ),
                        Divider(),
                        ItemSettings(
                          title: _constants!.publicToken,
                          value: paymentViewModel.businessToken,
                        ),
                        Divider(),
                        ItemSettings(
                          title: _constants!.timeout,
                          value: paymentViewModel.timeout.toString(),
                        ),
                        Divider(),
                        ItemSettings(
                          title: _constants!.metadata1,
                          value: paymentViewModel.metadata1 != null
                              ? paymentViewModel.metadata1
                              : "",
                        ),
                        Divider(),
                        ItemSettings(
                          title: _constants!.metadata2,
                          value: paymentViewModel.metadata2 != null
                              ? paymentViewModel.metadata2
                              : "",
                        ),
                        Divider(),
                        ItemSettings(
                          title: _constants!.itemsLbl,
                          value: "${_constants!.itemsLbl} x${Provider.of<ItemsViewModel>(context).items.length}",
                        ),
                        Divider(),
                        ItemSettings(
                          title: _constants!.phoneNumber,
                          value: paymentViewModel.phoneNumber != null
                              ? paymentViewModel.phoneNumber
                              : "",
                        ),
                        Divider(),
                        Container(
                                height: 45,
                                child: ATHMovilPaymentSecureButton(
                                  style: paymentViewModel.style,
                                  lang: paymentViewModel.lang,
                                  buildType: getBuildType(paymentViewModel.environment),
                                  athMovilPayment: 
                                    ATHMovilPayment(
                                      businessToken: paymentViewModel.businessToken,
                                      callbackSchema: "ATHMSDKEXAMPLE",
                                      total: paymentViewModel.paymentAmount,
                                      subtotal: paymentViewModel.subtotal,
                                      tax: paymentViewModel.tax,
                                      timeout: paymentViewModel.timeout,
                                      metadata1: paymentViewModel.metadata1,
                                      metadata2: paymentViewModel.metadata2,
                                      items: Provider.of<ItemsViewModel>(context).items,
                                      phoneNumber: paymentViewModel.phoneNumber
                                    ),
                                    listener: this,
                                ),
                              ),
                        _verticalSpace,
                        _verticalSpace,
                        PrimaryButton(
                          onPressed: () {},
                          text: _constants!.otherPaymentMethodLbl.toUpperCase(),
                        ),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }

  String getBuildType(String? environment) {
    const productionItem = "Production";

    switch (environment) {
      case productionItem:
        return "";
      default:
        return "";
    }
  }

  @override
  void onCancelledPayment(ATHMovilPaymentResponse athMovilPaymentResponse) {
    context.read<PaymentViewModel>().showLoading(false);
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>
          PaymentResultPage(athMovilPaymentResponse: athMovilPaymentResponse),
    ));
  }

  @override
  void onFailedPayment(ATHMovilPaymentResponse athMovilPaymentResponse) {
    context.read<PaymentViewModel>().showLoading(false);
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>
          PaymentResultPage(athMovilPaymentResponse: athMovilPaymentResponse),
    ));
  }

  @override
  void onCompletedPayment(ATHMovilPaymentResponse athMovilPaymentResponse) {
    context.read<PaymentViewModel>().showLoading(false);
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>
          PaymentResultPage(athMovilPaymentResponse: athMovilPaymentResponse),
    ));
  }

  @override
  void onExpiredPayment(ATHMovilPaymentResponse athMovilPaymentResponse) {
    context.read<PaymentViewModel>().showLoading(false);
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) =>
          PaymentResultPage(athMovilPaymentResponse: athMovilPaymentResponse),
    ));
  }

  @override
  void onPaymentException(String error, String description) {
    context.read<PaymentViewModel>().showLoading(false);
    _showATHMPaymentResult(
      title: AppLocalizations.current.athmExceptionTitle,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[Text(AppLocalizations.current.athmExceptionMessage)],
      ),
    );
  }

  Future<void> _showATHMPaymentResult({String? title, Widget? content}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title!,
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
}

class SimpleItem extends StatelessWidget {
  final String title;
  final String? description;
  final TextStyle? textStyle;

  SimpleItem({
    required this.title,
    required this.description,
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
              : Theme.of(context).textTheme.titleMedium,
        ),
        SizedBox(width: 5),
        Expanded(
          child: Text(
            description!,
            style: textStyle != null
                ? textStyle
                : Theme.of(context).textTheme.bodyMedium,
            overflow: TextOverflow.visible,
            textAlign: textStyle != null ? TextAlign.right : TextAlign.left,
          ),
        ),
      ],
    );
  }
}
